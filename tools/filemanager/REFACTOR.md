# Refactor plan: `filemanager.sh` -> `filemanager_llm.sh`

Status: phases 0-7 implemented in `tools/filemanager/filemanager_llm.sh`.
`filemanager.sh` is untouched and stays the shipped script; the aliases still
point at it.
Owner: build department.
Target: `tools/filemanager/filemanager_llm.sh`. Source: `filemanager.sh`
(5,498 lines, 121 functions). Result: 5,350 lines, 153 functions.
Line numbers below are from the pre-refactor file.
Test host: Linux, bash 5.3, GNU coreutils. The bash 3.2 checks in section 8.3
were a static review, as planned; the fractional-`read` fallback is code, not a
tested path.

## 1. Goal

Make `filemanager.sh` easy to read and maintain. The first stage is structural, not a bug-fix pass.

A change is in scope when it does one of these:

- puts code where a reader expects it;
- removes duplicated logic;
- gives shared state one declared owner;
- replaces an implicit convention with a named function.

A change is out of scope unless the architecture is its root cause. See section 7.

## 2. Constraints and decisions

| Decision | Value |
|---|---|
| File layout | One file. The refactor lands in `filemanager_llm.sh` next to the original, which stays as the baseline |
| Bash baseline | Bash 3.2 (macOS `/bin/bash`) and bash 5 |
| Runtime testing | Bash 5.3 on Linux (the planned bash 3.2 macOS host was not used) |
| Bash 3.2 verification | Static review checklist only (no bash 3.2 binary) |
| Behavior | Preserved, except bugs caused by duplication or ownership (section 7) |
| Config surface | `HSFM_*` names and the persisted file formats stay unchanged |
| New dependencies | None at runtime |
| Plan location | This file, next to the code |
| Tests location | `tools/filemanager/tests/` (not the repo root `tests/`) |

The aliases `filmanager` (`tools/tools.sh:4`) and `cfm` (`shell/tools/tools.sh:764`) invoke the script by path. The path must not change.

## 3. Current state

### 3.1 Inventory

- 5,498 lines, 121 functions, one file.
- 1,176 comment lines, of which roughly 275 are commented-out code.
- No tests, no CI, no `shellcheck` installed.
- Only `/bin/bash` 3.2.57 is available on this Mac.
- The script is derived from `dylanaraps/fff`. The comment at `filemanager.sh:5055` names `dylanaraps/hsfm`, but that repository does not exist; the text is copied from `fff`. Lineage notes: `docs/research/hsfm-upstream-lineage.md`.

### 3.2 Problems that justify the work

| Problem | Evidence |
|---|---|
| Two line editors implement the same behavior | `fcommand_mode_handler` `:2963-3328` (246 non-comment lines) and `fcommand_line_interact` `:3382-3695` (209 non-comment lines) |
| Directory reading is 395 lines with three identical parse loops | `fterminal_read_dir` `:1359-1753`; loops at `:1461-1512`, `:1527-1578`, `:1593-1644` differ only in the producer command at `:1515`, `:1581`, `:1647` |
| Globals are created by assignment in many functions | `previous_index` (`:1421-1726` writes, `:680` reads), `cur_list` (`:1752`, `:2663`), `VAR_SEARCH_MODE` (`:2537`, `:2666-2668`, `:4481`), `comp`/`c` (`:3526-3545`, `:3694`), `static_var_comp_*` (`:3085-3137`) |
| A command handler is 309 lines of one `case` | `fnormal_mode_handler` `:2499-2807` |
| View functions write model state | `fterminal_draw_file_line` `:939`, `:946`; `fterminal_draw_dir` `:768-769`, `:824` |
| Editor state is written by a mode switch and read by a view | `fmode_setup` `:2440-2486`; `fterminal_draw_command_line` `:1193-1194` |
| The same block is repeated across handlers | yank/cut/trash `:2848-2872` = `:2931-2955`; top/bottom `:2570-2583` = `:2905-2918` |
| The same file-resolution prologue is repeated five times | `:3838-3844`, `:3864-3870`, `:3890-3896`, `:3906-3912`, `:3922-3928` |

## 4. Target structure

### 4.1 Six sections

The sections are a reading order and an ownership scheme. Bash cannot enforce call direction, so this document does not claim it does. Only the rules in section 4.2 are enforced.

| Section | Owns | May read/call | Current code |
|---|---|---|---|
| L0 Driver | stdout and escape emission, print buffer, terminal modes, rectangle drawing | nothing above | `:409`, `:416-473`, `:531-604` |
| L1 View | geometry, all `draw_*`, message and status output | L0 | `:475-510`, `:609-1255`, `:3696-3724` |
| L2 Workspace | directory list, tabs, marks, cursor and scroll numbers, file getters | L1, L0 | `:1257-1358`, `:1359-1753`, `:1837-1945`, `:3330-3341` |
| L3 Commands | `cmd_*`, `vcmd_*`, file operations, `fsys_open`, scroll and tab actions | L2, L1, L0, plus two L4 prompt entry points | `:1950-2413`, `:3725-4838` |
| L4 Input and modes | key decoding, mode state machine, line editor | L3, L2, L1, L0 | `:1755-1835`, `:2415-3695` |
| L5 Lifecycle | config, persistence, traps, help, `fCore`, `fMain` | everything below | `:511-526`, `:4843-5496` |

One upward edge is allowed: L3 commands may call exactly `fprompt_wait` and `fprompt_confirm` from L4. There are nine current call sites that need a prompt: `:3952`, `:4182`, `:4196`, `:4210`, `:4252`, `:4262`, `:4328`, `:4720`, `:4763`.

### 4.2 Rules

- **R1, declaration.** Every global is declared in the state block at the top of its section. Assigned but undeclared is a defect.
- **R2, write ownership.** One section writes each global. The matrix in section 4.3 is the authority. Other sections may read published products: `VAR_TERM_KEY_CURRENT_INPUT`, `REPLY`, and the L2 directory lists.
- **R3, no shadowing.** A `local` may not reuse a state-block name. Bash dynamic scoping means a local in a callee silently captures an ancestor's read. This already happens by accident: `fenv_left_hande_mode` reads `args_value` from `cmd_set` (`:1951`, `:4349`).
- **R4, prompts.** L3 does not call editor internals. It calls `fprompt_wait` or `fprompt_confirm`.

### 4.3 State ownership matrix

| State | Declared at | Target owner | Current violations to document |
|---|---|---|---|
| `VAR_TERM_PRINT_BUFFER`, `VAR_TERM_PRINT_BUFFER_ENABLE` | `:92-93` | L0 | none |
| `VAR_TERM_HEIGHT`, `VAR_TERM_WIDTH`, `VAR_TERM_MAINWIN_*` | `:47-48`, `:62-64` | L1 | none after Phase 2 |
| `VAR_TERM_MSGWIN_BUFFER`, `VAR_TERM_TASKWIN_BUFFER` | `:121`, `:125` | L1 | `flog_msg_debug` writes them |
| `VAR_TERM_DIR_FILE_LIST`, `_INFO_LIST`, `_CNT` | `:85-87` | L2 | `fnormal_mode_handler` `:2663-2664`, `fterminal_tab_load_contex` `:1876-1881` |
| `FM_DIR_PREV_IDX` (was `previous_index`) | undeclared | L2 | `fterminal_read_dir` only |
| `FM_DIR_BACKUP` (was `cur_list`) | undeclared | L2 | `fterminal_read_dir` `:1752` |
| `FM_DIR_SEARCH_ACTIVE` (was `VAR_SEARCH_MODE`) | undeclared | L2 | `fnormal_mode_handler` `:2537`, `:2666-2668`; `fsys_open` `:4481` |
| `VAR_TERM_TAB_LINE_*` | `:70-77` | L2 | tab actions in L3 |
| `VAR_TERM_MARKED_FILE_LIST`, `VAR_TERM_MARK_DIR` | `:130-131` | L2 | mark helpers and mode handlers |
| `VAR_TERM_CONTENT_SCROLL_IDX`, `_START_IDX`, `VAR_TERM_WIN_CURRENT_CURSOR` | `:81-83` | L2 | L1 drawing writes them (deferred, section 9) |
| `VAR_TERM_SELECTION_FILE_LIST`, `VAR_TERM_FILE_PROGRAM` | `:132-133` | L3 | mode handlers set them |
| `VAR_TERM_OPEN_FILE` | `:89` | L3 | `fsys_open` |
| `VAR_TERM_MODE_CURRENT`, `VAR_TERM_VISUAL_START_IDX` | `:167-168` | L4 | `fmode_setup` only |
| `VAR_TERM_KEY_CURRENT_INPUT`, `VAR_TERM_KEY_BUFFER_INPUT` | `:94-95` | L4 | key decoder only |
| `VAR_TERM_CMD_INPUT_BUFFER` | `:142` | L4 | `fselect_copy`/`fselect_remove` read it |
| `VAR_TERM_{CMD,SEARCH,FIND}_HISTORY` | `:138-140` | L4 | editors only |
| `VAR_TERM_CMD_LIST`, `VAR_TERM_SELECT_CMD_LIST`, `VAR_TERM_CMD_HISTORY_MAX` | `:137-154` | L4 | constants |
| `VAR_TERM_FILE_PRE/POST`, `VAR_TERM_MARK_PRE/POST` | `:100-103` | L5 | `fsetup_options` |
| `VAR_TERM_READ_ARGS`, `VAR_TERM_DIR_LS_ARGS`, `VAR_TERM_FILE_ARGS` | `:42-44` | L5 | `fsetup_shell`, `fsetup_env` |
| `VAR_TERM_FLAG_FIND_PREVIOUS`, `VAR_TERM_FLAG_RESET_IDX`, `VAR_TERM_SEARCH_END_EARLY` | `:106-107`, `:171` | L5 | mode handlers and `fsys_open` |
| `HSFM_*` config | `:4-400` | L5 | external contract, frozen |
| `DEF_*` constants | `:25-31`, `:111-113`, `:160-165` | L5 | frozen |
| `FM_ED_*` editor state | new in Phase 4 | L4 | none |
| `FM_DIR_*` model state | new in Phase 3 | L2 | none |

Frozen names that are written to disk and must not be renamed:

- `VAR_TERM_CMD_HISTORY`, `VAR_TERM_SEARCH_HISTORY`, `VAR_TERM_FIND_HISTORY` (`fsave_env` `:4852-4874`);
- `VAR_TERM_TAB_LINE_IDX`, `VAR_TERM_TAB_LINE_LIST_PATH` (`fsave_session` `:4896-4900`);
- `HSFM_COLOR_THEME`, `HSFM_READ_DIR_MODE`, `HSFM_LS_SORTING` (`fsave_env` `:4878-4880`).

The persisted files are sourced as bash (`fload_env` `:4933-4938`, `fload_session` `:4922-4932`), so renaming any of these breaks existing user caches.

### 4.4 Rename map

Renames happen in the phase that rewrites the code, not before.

| Current | New | Phase |
|---|---|---|
| `previous_index` | `FM_DIR_PREV_IDX` | 3 |
| `cur_list` | `FM_DIR_BACKUP` | 3 |
| `VAR_SEARCH_MODE` | `FM_DIR_SEARCH_ACTIVE` | 3 |
| `var_input_buffer` | `FM_ED_BUF` | 4b |
| `var_post_input_buffer` | `FM_ED_POSTBUF` | 4b |
| `var_cmd_prefix` | `FM_ED_PREFIX` | 4b |
| `var_cmd_function` | `FM_ED_FUNC` | 4b |
| `var_cmd_history_idx` | `FM_ED_HISTIDX` | 4b |
| `var_cmd_backup_buffer` | `FM_ED_BACKUP` | 4b |
| `static_var_comp_*`, `comp`, `c` | `FM_ED_COMP_MODE_*`, `FM_ED_COMP_PROMPT_*` | 4b |
| `tmp_command`, `tmp_args` | `FM_ED_CMD`, `FM_ED_ARGS` | 4b |
| `args_value` in `fenv_left_hande_mode` | positional `$1` | 2 |

## 5. Line editor specification (Phase 4)

### 5.1 Behavior table

This table is written from the current code and is the acceptance spec for Phase 4b. "Mode" means `fcommand_mode_handler` (called from `fCore`); "Prompt" means `fcommand_line_interact` (called by commands).

| # | Behavior | Mode path | Prompt path | Phase 4b decision |
|---|---|---|---|---|
| 1 | Find history reachable with arrows | yes `:3008-3014`, `:3039-3045` | no; only search or command `:3456-3470` | Keep per-flavor history selection. Prompt never selects find. |
| 2 | `!command` shell eval | yes `:3205-3207` | no; becomes "command not found" | Preserve: only the command flavor supports `!`. |
| 3 | `image` dispatch | `cmd_image` `:3220-3222` | `cmd_media` for `image` and `preview` `:3603-3605` | Fix: one table, `image` to `cmd_image`, `preview` to `cmd_preview` (K3). |
| 4 | Dispatch family | always `cmd_*` `:3202` | `cmd_*` when mode is normal, else `vcmd_*` `:3588` | Preserve: family is chosen by the ambient mode at submit time. |
| 5 | Wait/confirm arrows walk command history | not applicable | yes `:3464-3469`, `:3488-3493` | Fix: wait and confirm have no history (K8). |
| 6 | Tab at a wait prompt completes select commands | not applicable | yes `:3525-3539` | Fix: wait and confirm have no completion (same class as K8). |
| 7 | Rendering stream | `fterminal_print` on stdout `:3305`, `:2970` | `read -p` on stderr `:3406` | Preserve: each driver owns its rendering. |
| 8 | Early return skips cursor show | `:3148`, `:3159`, `:3166`, `:3178`, `:3183`, `:3189` | always breaks | Preserve per driver. Do not normalize. |
| 9 | `read -t 0` input flush | no `:5335` | yes `:3689` | Preserve: prompt only. |
| 10 | ESC drain | `VAR_TERM_READ_ARGS` `:3266`, empty on bash 3.2, so it blocks | `-t 0.02` `:3409`, invalid on bash 3.2 | Fix: one reader. Use `-t 0.02` on bash 4+, a `-t 0` drain loop on bash 3.2 (K4). |
| 11 | Return code on submit/cancel | `return 0` `:3148-3260` | `break`, then returns 0 | Core returns 0 continue, 1 submit, 2 cancel. Drivers map to today's codes. |
| 12 | Completion lifetime | list survives across sessions; reset only on backspace/type `:3067`, `:3300` | `unset comp c` at exit `:3694` and on type `:3679` | Two named slots, both reset by `fedit_begin` (K1 fixed). The prompt slot is also cleared at exit, as today. |
| 13 | Completion append | array append `:3104`, `:3114`, `:3122` | string append `:3530`, `:3537` | Fix: array append in the one engine (K2). |
| 14 | Search hook per keypress | `cmd_newsearch` `:3307-3311` | `cmd_search` `:3683-3686` | Preserve: the hook is flavor config. |
| 15 | Path completion | yes, first argument only `:3090-3107` | no `:3525-3538` | Preserve: flavor flag. |
| 16 | Ctrl-R inserts selection | yes `:3282-3289` | no | Preserve: command flavor only. |
| 17 | `~` expands to `$HOME` | yes `:3290-3293` | yes `:3669-3672` | Shared core. |
| 18 | Resize during a prompt | editor state is global, so `draw_command_line` sees it `:1193-1194` | editor state is local `:3400-3401`, so redraw paints stale text | Fix: editor state becomes the declared `FM_ED_*` block (K19). |
| 19 | History over max | drops the newest, six copies `:3149-3195`, `:3555-3581` | same | Fix once with `fhist_append` (K9). |
| 20 | Enter on empty input | clears line and redraws `:3186-3189` | clears line `:3572-3574` | Preserve. |

### 5.2 Target API

```bash
fedit_begin(prefix, func, flavor)   # initialize a session; does not reset completion slots
fedit_key(key)                      # pure state transition: 0 continue, 1 submit, 2 cancel
fedit_line()                        # print the current line, used by both drivers
fedit_complete()                    # one completion engine, flavor-aware
fedit_history_up() / _down()        # one implementation for command, search, find
fedit_submit()                      # per-flavor submit and dispatch
fprompt_wait(prompt)                # modal driver, wait flavor
fprompt_confirm(prompt)             # modal driver, confirm flavor
```

Driver A replaces the body of `fcommand_mode_handler`: it calls `fedit_key`, renders with `fterminal_print`, and runs the per-key search hook. Driver B replaces the `while` loop in `fcommand_line_interact`: it keeps `read -p` rendering, the ESC sequencer, and the trailing `read -t 0` flush. The core performs no terminal I/O, so the unit harness can drive it key by key.

## 6. Phase plan

Each phase leaves the script runnable. Pure moves are proven by function-body hashes, not by tests that cannot detect a body edit.

### Phase 0: plan, guard, harness

Steps:

1. Publish this file.
2. Replace the final `fMain $@` (`:5498`) with:
   `[[ "${BASH_SOURCE[0]}" == "$0" ]] && fMain "$@"`
   This keeps execution identical and makes the file sourceable.
3. Create `tests/tools/function_hashes.sh`: print `name sha256` for every function body.
4. Create `tests/unit/`: source the script with a fixed environment; assert function results.
5. Create `tests/smoke/`: tmux sessions with fixed geometry and environment.
6. Create the fixture tree under `$TMPDIR`, with pinned mtimes.

Hermetic environment for every test:

- `HOME` points into the fixture tree;
- `HSFM_FILE_CONFIG=$HOME/.hsfm.sh` and `HSFM_PATH_CACHE=$HOME/.cache/hsfm`;
- `TERM=xterm-256color`, `LC_ALL=C`, fixed `LS_COLORS`;
- 80x24 tmux window, fixed working directory, non-symlinked fixture path.

Without this, the EXIT trap (`:5076` to `fHSFM_exit` `:518-526`) writes the real history and session, and favorite detection at `:284-293` depends on the current directory.

Start with three smoke sessions: startup, navigation, command line. Add sessions only where a phase can fail.

Verify: two runs produce identical output; `bash -n` under bash 3.2; no writes outside the fixture.

Exit: harness exists; per-function hashes baseline recorded.

### Phase 1: physical re-layout

Move whole functions into the six sections in table order. No body edits. Keep the header block and the new source guard.

Verify:

- `bash -n` under bash 3.2;
- every function body hash matches Phase 0;
- 121 function names, no duplicates.

Exit: the file reads top-down in dependency order; behavior untouched.

### Phase 2: state declaration and contained fixes

Steps:

- Declare the globals that survive every phase, grouped under their section banner.
- Localize only temporaries that are written and read in the same function. Do not blanket-`local`: `ls_patterns` (`:5115-5116` to `:898-899`) and `shopt_flags`/`dotglob` (`:1385-1386`) are genuinely shared.
- Fix `fenv_left_hande_mode` to read its argument: `local args_value="$1"` (K6).
- Correct `VAR_TERM_MAINWIN_START_IDX=(0 0)` at `:62` (K13). The value is overwritten at `:497` before the first draw, so normal startup is unchanged.
- Replace `HSFM_DIR_ALIAS` with a bash-3.2-safe lookup (K10). The current guard enables `declare -A` only above bash 4, then assigns string subscripts unconditionally (`:297-302`); on 3.2 and bash 4 both aliases collapse to index 0. Use two parallel arrays and a lookup function, and update the loop in `cmd_cd` (`:4120-4127`) to call it.
- Do not rename editor state here. It is rewritten in Phase 4.

Verify: declaration grep for every matrix row; `bash -n`; smoke for `:set left on` and `cd home`.

Exit: no undeclared state remains on the matrix; the three fixes are recorded in section 7.1.

### Phase 3: directory pipeline

Extract from `fterminal_read_dir` (`:1359-1753`):

- three producers: `fdirsrc_find`, `fdirsrc_ls`, `fdirsrc_ls_sort`;
- one ingest function. Call it as `fdir_ingest << EOF ... EOF`, never `producer | fdir_ingest`, because the pipe runs in a subshell and silently loses the list.
- `FM_DIR_PREV_IDX` and `FM_DIR_BACKUP` are L2 globals. `var_item_index` stays local to the ingest.

Keep NONE, SORT, and FAST_LS as separate loaders. FAST_LS uses `mapfile` (`:1674-1675`) and GNU-only flags (`:1658-1659`), and its line format differs.

Do not deduplicate the OLDPWD blocks. The FAST_LS copy adds a guard and `head -n 1` (`:1696-1698`), so the two are not equivalent. Log as K15.

Verify:

- ingest unit tests on fixtures: plain directory, unreadable subdirectory, symlink, empty directory, filename with a quote;
- per-mode smoke for NONE, SORT, LS_SORT, FIND;
- extracted bodies hash-identical to the originals;
- FAST_LS: code review only. `fsetup_env` forces `LS_SORT` on macOS (`:4973`), and FAST_LS needs GNU `ls` plus `mapfile`, so it cannot run here.

Exit: directory state has one declared owner; the three identical loops are one.

### Phase 4a: editor primitives

Extract behavior-preserving primitives while both drivers still exist:

- `fedit_line` for the repeated buffer expression (`:1194`, `:3143`, `:3308`);
- `fhist_append` and `fhist_get`, initially preserving the drop-newest trim;
- one completion engine with two state slots;
- one ESC sequence reader, behavior unchanged; the bash-3.2 fallback lands in 4b.

Verify: unit-drive each helper; command, search, and prompt smoke.

Exit: both drivers call the same primitives; behavior unchanged.

### Phase 4b: merge the drivers

Implement section 5.2. One core, two drivers, one dispatch table parameterized by ambient mode and flavor.

Verify against the section 5.1 table with scripted sessions for `:`, `/`, `?`, `C`, `F`, wait, confirm, history recall, and resize.

Exit: one implementation of line editing; the intentional changes in section 7.1 are the only behavior differences.

### Phase 5: scroll readability (comment-only)

Do not move the scroll code in this stage. `fterminal_draw_file_line` mutates page state per row (`:935-953`) and is called from eight partial-scroll sites, so lifting it is the highest-risk change for the smallest readability gain.

Instead, add a decision-table comment above the page arithmetic (`:711-764`) and record the update order in this document. A comment change cannot fail a test; confirm `bash -n` only.

Exit: the nine branches are explained without moving them.

### Phase 6: handler and command deduplication

- Extract the identical yank/cut/trash blocks (`:2848-2872` = `:2931-2955`) and the `q`/ESC pair (`:2873-2876` = `:2956-2959`).
- Keep the inline `:=` key defaults verbatim. They assign a default at dispatch time and sometimes differ from the exported value (`:363` versus `:2702`).
- One file-resolution helper for the five `cmd_*` functions (`:3838-3844`, `:3864-3870`, `:3890-3896`, `:3906-3912`, `:3922-3928`). Exclude `fsys_open`: it tests `-e` (`:4473`) while the five test `-f`.
- Unify `cmd_msg` and `cmd_task` (`:4265-4293`).
- Collapse the identical `fselect_remove` branches (`:4761-4766`, K14).

Verify: body hashes for moved blocks; mode-switch smoke.

Exit: no duplicated file-operation block and no duplicated command prologue.

### Phase 7: dead code and close-out

- Remove commented-out blocks and the dead `fgui_tab_create` (`:2245-2272`).
- Update the phase log and bug log in this file.
- Add a short architecture section to `README.md` or `AGENTS.md` pointing here.

Do not delete unreferenced `cmd_*` or `vcmd_compress`. They are reached through `cmd_${name}` and `vcmd_${name}` (`:3230`, `:3613`), so a static reference count is misleading.

Verify: full suite; `bash -n`; manual checklist.

Exit: no commented-out code remains; the plan reflects the result.

## 7. Bug policy

### 7.1 Fixed because duplication or ownership causes them

| ID | Bug | Fix |
|---|---|---|
| K1 | Mode completion list survives across sessions; `fmode_setup` never resets it (`:2440-2450`) | `fedit_begin` resets both completion slots. |
| K2 | Prompt completion appends an array to a string (`:3530`, `:3537`) | One engine, array append. |
| K3 | `image` and `preview` resolve differently in the two editors (`:3220-3222` versus `:3603-3605`) | One dispatch table: `image` to `cmd_image`, `preview` to `cmd_preview`. |
| K4 | Fractional `read -t 0.02` fails on bash 3.2 (`:3409`); the mode path blocks on ESC `:3266` | One reader with a bash 3.2 `-t 0` drain fallback. |
| K6 | `fenv_left_hande_mode` reads `cmd_set`'s local through dynamic scope (`:1951`, `:4349`) | Function takes `$1`. |
| K8 | Wait/confirm prompts walk command history and complete select commands (`:3464-3469`, `:3525-3539`) | Wait and confirm have no history and no completion. |
| K9 | History over max drops the newest entry (six copies) | One `fhist_append`. |
| K10 | `HSFM_DIR_ALIAS` collapses to index 0 on bash 3.2 and bash 4 (`:297-302`) | Parallel arrays plus a lookup function. |
| K13 | `VAR_TERM_MAINWIN_START_IDX=(0,0)` is one element (`:62`) | Two-element declaration. |
| K19 | Prompt editor state is local (`:3400-3401`), so a resize during a prompt repaints from stale globals (`:1193-1194`) | Editor state becomes the declared `FM_ED_*` block, readable by the view. |
| K5 | `cmd_set left` returned failure on success, skipping the redraw and the message (`:4386-4388`) | `if ! fenv_left_hande_mode "${args_value}"`. |
| K7 | `fselect_copy` tested `*` before `d`/`n`, so those arms never matched (`:4738-4744`) | Arms split, `*` last and documented as the duplicate fallback. `d` now applies to the rest of the batch; `n` and an unknown answer ask again for the next file instead of silently switching the batch to duplicate. |
| K11 | `vcmd_compress` compared an array expansion with `-eq` (`:4592`) | `${#VAR_TERM_SELECTION_FILE_LIST[@]} -eq 1`. |
| K20 | `vcmd_compress` named a single-file archive from the first dot in the whole path (`:4595-4598`), so `/tmp/x.dir/a.tar.gz` became `/tmp/x.txz`; a dotfile lost its name entirely | Strip the directory, then the last extension; keep the whole name when the stem is empty. The name is quoted and separated from the command by a space, so the `zip -j` family keeps one argument per word. Found by the K11 test. |
| K12 | Tab context serialized the lists with `\x1e`, which a file name can contain (`:1911-1919`, `:1854-1856`) | The cache is gone; a tab load re-reads the directory and restores the cursor. |
| K15 | The NONE OLDPWD lookup used a regex and could return several line numbers, producing a malformed index | `fdir_prev_index`, shared by the NONE and FAST_LS paths: fixed-string whole-line grep, first hit, no `eval`. |
| K16 | `fInfo` and `fErrControl` were undefined and `--verbose` failed (`:5442`) | Both defined; they write to stderr. |
| K17 | `elif ... || true` made the fallback branch unconditional (`:5454`) | `|| true` removed. |
| K18 | An empty `HSFM_OPENER` passed `command -v`, then `nohup ""` failed (`:4549-4552`) | Non-empty guard before the lookup. |

### 7.2 Logged only

None. Every bug from the first pass is fixed in section 7.1. The remaining
known-unfixed items are in section 9.

## 8. Verification

### 8.1 Per-phase checks

| Phase | Checks |
|---|---|
| 0 | two identical runs; `bash -n`; no writes outside the fixture |
| 1 | `bash -n`; function hashes unchanged; 121 names |
| 2 | declaration grep; `bash -n`; `:set left`, `cd home` smoke |
| 3 | ingest unit tests; four reachable read modes smoke; body hashes |
| 4a | helper units; command/search/prompt smoke |
| 4b | section 5.1 table sessions |
| 5 | `bash -n` only (comment-only change) |
| 6 | body hashes; mode-switch smoke |
| 7 | full suite; `bash -n`; manual checklist |

### 8.2 Oracle

Primary oracle: function-body hashes plus `bash -n` plus headless state assertions. This catches moved or edited bodies without depending on terminal rendering.

Secondary oracle: normalized tmux text captures (`capture-pane -p`, not `-e`) only for Phase 4 and Phase 6, where rendering and key handling are the risk. Colored captures are not a stability target.

The harness must never send ESC in a smoke session until Phase 4b, because the current ESC drain blocks on bash 3.2.

### 8.3 Bash 5 static checklist

No bash 5 binary is available, so review each phase against this list:

- `mapfile` only in FAST_LS (`:1674-1675`), which macOS never selects (`:4973`) and which is documented as untested here;
- `declare -A` is removed by the K10 fix;
- `VAR_TERM_READ_ARGS=(-t 0.05)` stays gated on `BASH_VERSINFO[0] > 3` (`:5056-5057`);
- no new fractional `read -t` outside the Phase 4b shared reader;
- no `${var,,}`, `${var^^}`, `declare -n`, `readarray`, or negative array indices;
- `[[ =~ ]]` patterns remain quoted where the current code quotes them, because bash 3.2 and 5 differ in regex quoting.

The reviewer checks that no phase makes a bash 4+ construct newly required on 3.2.

### 8.4 Manual checklist

Once per phase batch, on a real terminal:

- alt-screen and `stty echo` are restored after `cmd_shell` (`:4059`) and `cmd_editor` (`:3836`);
- `vim` and `less` return to a drawn screen (`cmd_hex` `:3862`, `cmd_config` `:4446`);
- colors render as before;
- resize during idle and during a prompt does not leave artifacts.

## 9. Risks and deferred work

| Risk | Mitigation |
|---|---|
| Extracted ingest loses state in a subshell | Use here-doc input; never pipe into `fdir_ingest`. |
| Editor merge changes key behavior | Section 5.1 table is the spec; write it before code. |
| Dynamic scoping breaks a refactored caller | R3; state-block names are never used as locals. |
| Sparse mark arrays are reindexed by a "tidy" loop | Keep `unset` and sparse indices (`:1279`, `:1349`); `${#arr[@]}` counts set elements. |
| `:=` key defaults are replaced with plain expansion | Keep verbatim; they assign at dispatch (`:2509`, `:2702`). |
| `set -u` is added | Do not add it. The code relies on unset-as-empty throughout. |
| Traps run during a test | Harness sets `HOME` and cache paths before sourcing. |

Deferred to a later stage:

- moving scroll normalization out of L1 (section 5, Phase 5);
- deduplicating the OLDPWD blocks (K15);
- the upstream `w3m` image preview removed from the fork;
- bash 5 runtime testing.

## 10. Phase log

| Phase | Status | Notes |
|---|---|---|
| 0 | done | Source guard added. `tests/tools/function_hashes.sh` prints `name sha256` from `declare -f`; baseline recorded at 121 functions. |
| 1 | done | Six layer sections with banners. Line accounting asserted: same multiset of lines, only banners added. All 121 body hashes unchanged. |
| 2 | done | L2 state declared in the header; `FM_DIR_*` renames happened in Phase 3. K6, K10, K13 fixed. `tests/unit/state_test.sh`. |
| 3 | done | `fdirsrc_find`, `fdirsrc_ls`, `fdirsrc_ls_sort`, `fdir_ingest`; three parse loops became one. FAST_LS left separate. `tests/unit/read_dir_test.sh` diffs six modes against the original, `tests/unit/ingest_test.sh` covers the parse branches. |
| 4a | done | `fedit_line`, `fedit_cursor_offset`, `fhist_append`, `fedit_complete`, `fedit_read_seq`. |
| 4b | done | One core (`fedit_key`/`fedit_submit`/`fedit_cancel`/`fedit_dispatch`) plus two drivers. K1-K4, K8, K9, K19 fixed. `tests/unit/editor_test.sh` and `tests/smoke/keys_test.sh`. |
| 5 | done | Decision-table comment above the page arithmetic. No code moved; body hashes unchanged. |
| 6 | done | `fhandler_file_op`, `fhandler_quit`, `fcmd_file_get`, `fcmd_bottomwin_toggle`; `fselect_remove` prompt collapsed. |
| 7 | done | Dead `fgui_tab_create` and its call removed; commented-out blocks removed; this log updated; `README.md` added. |
| 8 | done | Section 7.1 bugs fixed: K5, K7, K11, K12, K15, K16, K17, K18, plus K20 found while testing K11. `tests/unit/bugs_test.sh` fails on the pre-fix file and passes now. |

### 10.1 Behavior changes shipped

Only section 7.1 bugs changed behavior, plus the consequences recorded here:

- `FM_ED_ACTIVE` is new view-visible state (K19); `fterminal_draw_command_line`
  now paints the live line during any prompt.
- `fprompt_wait` and `fprompt_confirm` replace the direct
  `fcommand_line_interact` calls in L3. The old third argument was unused and is
  gone. A prompt opened from inside a `:` command borrows the one global editor
  state; `fprompt_open` saves and restores it, so the outer session still ends in
  normal mode.
- After a wait prompt opened by a command (`:help`, `:stat`, `:preview`), the
  command row is cleared instead of keeping the submitted text. Cosmetic.
- Directory entries that failed to stat are still appended after the readable
  ones, as before; the ingest defers them.
- A tab switch re-reads the directory instead of restoring a cached list, so a
  file added or removed in another tab shows up. The cursor and scroll indices
  are still restored.
- `vcmd_compress` names a single-file archive from the file's own name instead
  of the directory's, and quotes it.
- `fselect_copy` asks once per file for `n` and for an unknown answer; `d`
  still applies to the rest of the batch.
- `--verbose` prints two diagnostic lines instead of failing.

### 10.2 Verified here

`bash -n`; `function_hashes`; two unit suites for the directory pipeline; one for
state; one for the editor core; one for the section 7.1 bugs; a 14-step tmux
pane diff against
`filemanager.sh` covering startup, cursor move, tab open/switch/close, directory
open, command typing and submit, search, find, escape cancel, and history recall;
and a tmux test for a prompt opened inside a `:` command.

### 10.3 Not verified here

- bash 3.2 runtime: the `-t 0` drain fallback and the parallel-array alias
  lookup are unexercised.
- macOS `LS_SORT` path, and the FAST_LS mode as macOS selects it.
- Image, media and preview commands (external tools absent).
- On-target timing and memory: not applicable to this tool.

## 11. Related documents

- `docs/research/hsfm-upstream-lineage.md`: origin of the script in `dylanaraps/fff`, upstream bash baseline, and why the `hsfm` URL in the source is a rename artifact. Currently untracked.
