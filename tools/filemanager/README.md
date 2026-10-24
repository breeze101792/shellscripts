# filemanager

A terminal file manager written as one bash script, derived from
`dylanaraps/fff`.

| File | Purpose |
|---|---|
| `filemanager.sh` | The shipped script. The `filmanager` and `cfm` aliases run it. |
| `filemanager_llm.sh` | Refactored implementation. Same behavior, six-layer layout. |
| `REFACTOR.md` | The refactor plan, phase log, and the known-bug list. |
| `hsfm_template.sh` | Config template copied by `filemanager.sh -s`. |
| `tests/` | Hash oracle, unit tests and tmux pane-diff smoke test. |

## Layout of `filemanager_llm.sh`

Read top down; each section may call the ones below it.

| Section | Prefix | Owns |
|---|---|---|
| L0 Driver | `fout_*` | stdout and escape emission, print buffer, terminal modes, rectangle drawing |
| L1 View | `fview_*` | geometry, every `draw_*`, message and status output |
| L2 Workspace | `fdir_*` | directory list, tabs, marks, cursor and scroll numbers, file getters |
| L3 Commands | `cmd_*`, `fcmd_*`, `ftab_*`, `fnav_*` | commands, file operations, scroll and tab actions |
| L4 Input and modes | `fin_*`, `fedit_*` | key decoding, mode state machine, line editor |
| L5 Lifecycle | `fapp_*` | config, persistence, traps, help, entry points |

State rules: the header declares constants first, then external
configuration, then internal state. `HSFM_*` is configuration a user's
`~/.hsfm.sh` sets, so those names are a contract. `DEF_*` is constant. `FM_*` is
internal, one group per owner: `FM_VIEW_*`, `FM_DIR_*`, `FM_INPUT_*`, `FM_ED_*`,
`FM_CMD_*`, `FM_ENV_*`. One section writes each variable, and a `local` never
reuses a state name, because bash scopes dynamically.

## Global state

Every top-level variable carries one of three prefixes.

| Prefix | Meaning | May be renamed |
|---|---|---|
| `HSFM_*` | External configuration. A user's `~/.hsfm.sh` sets these. | No, the names are a contract |
| `DEF_*` | Constants, read-only after load. | No |
| `FM_*` | Internal state, one owner per group. | Yes, inside the group |

Internal state, by owner:

| Group | Holds | Owner |
|---|---|---|
| `FM_VIEW_*` | window geometry, print buffer, display formats | L1 |
| `FM_DIR_*` | file list, cursor, scroll, marks, tab indices, previous index | L2 |
| `FM_CMD_*` | selection list, file program, open file | L3 |
| `FM_INPUT_*` | key, key buffer, mode, visual start | L4 |
| `FM_ED_*` | line editor buffers, history cursor, completion slots | L4 |
| `FM_ENV_*` | per-platform `file` and `ls` arguments | L5 |
| `FM_*` | running, debug, left-hand mode, alias tables, cache paths | L5 |

Five names keep an older `VAR_TERM_*` spelling because the cache files are
sourced as bash, so the name is the on-disk format: `VAR_TERM_CMD_HISTORY`,
`VAR_TERM_SEARCH_HISTORY`, `VAR_TERM_FIND_HISTORY`, `VAR_TERM_TAB_LINE_IDX`,
`VAR_TERM_TAB_LINE_LIST_PATH`. The same applies to `HSFM_COLOR_THEME`,
`HSFM_READ_DIR_MODE`, `HSFM_LS_SORTING`, `HSFM_PATH_CACHE` and
`HSFM_FILE_CONFIG`. Renaming one silently drops a user's history or session.
`REFACTOR.md` section 4.3 is the full list.

Families that differ only by data have one helper and thin wrappers:
`fcmd_page` (full-screen commands), `fcmd_spawn_viewer` (`image`, `media`),
`fcmd_create` (`mkdir`, `touch`), `fdirsrc_ls` (sorted or not),
`fview_draw_bottomwin` (message and task windows),
`fview_draw_actionwin` (mini and check windows), `ftab_insert`,
`ftab_switch`, `ftab_swap`, `fnav_scroll_edge_visual`.

The line editor is one core (`fedit_*`) with two drivers: `fin_mode_command`
for the `:`, `/` and `?` modes, and `fin_prompt` for prompts.
Commands reach it only through `fprompt_wait` and `fprompt_confirm`.

## Tests

```sh
tests/tools/function_hashes.sh filemanager_llm.sh   # name sha256 per function
tests/unit/state_test.sh                            # declared state and the K6/K10/K13 fixes
tests/unit/read_dir_test.sh                         # directory model vs filemanager.sh
tests/unit/ingest_test.sh                           # one parse line at a time
tests/unit/editor_test.sh                           # editor core, key by key
tests/unit/bugs_test.sh                             # the bugs REFACTOR.md section 7.1 lists
tests/unit/merge_test.sh                            # the generic helpers
tests/unit/functions_test.sh                        # one case per function, all 162
tests/smoke/keys_test.sh                            # tmux pane diff vs filemanager.sh
tests/smoke/nested_prompt_test.sh                   # a prompt inside a : command
```

`read_dir_test.sh` and `keys_test.sh` take the baseline path as their second
argument, defaulting to `filemanager.sh`.
