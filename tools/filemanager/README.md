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

| Section | Owns |
|---|---|
| L0 Driver | stdout and escape emission, print buffer, terminal modes, rectangle drawing |
| L1 View | geometry, every `draw_*`, message and status output |
| L2 Workspace | directory list, tabs, marks, cursor and scroll numbers, file getters |
| L3 Commands | `cmd_*`, `vcmd_*`, file operations, `fsys_open`, scroll and tab actions |
| L4 Input and modes | key decoding, mode state machine, line editor |
| L5 Lifecycle | config, persistence, traps, help, `fCore`, `fMain` |

State rules: every global is declared in the config block at the top; one
section writes each one; a `local` never reuses a state name, because bash scopes
dynamically.

The line editor is one core (`fedit_*`) with two drivers: `fcommand_mode_handler`
for the `:`, `/` and `?` modes, and `fcommand_line_interact` for prompts.
Commands reach it only through `fprompt_wait` and `fprompt_confirm`.

## Tests

```sh
tests/tools/function_hashes.sh filemanager_llm.sh   # name sha256 per function
tests/unit/state_test.sh                            # declared state and the K6/K10/K13 fixes
tests/unit/read_dir_test.sh                         # directory model vs filemanager.sh
tests/unit/ingest_test.sh                           # one parse line at a time
tests/unit/editor_test.sh                           # editor core, key by key
tests/smoke/keys_test.sh                            # tmux pane diff vs filemanager.sh
tests/smoke/nested_prompt_test.sh                   # a prompt inside a : command
```

`read_dir_test.sh` and `keys_test.sh` take the baseline path as their second
argument, defaulting to `filemanager.sh`.
