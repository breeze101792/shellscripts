# HS-Shell-Tools: A Personal Shell Enhancement Toolkit

## 1. Overview

This project is a comprehensive collection of shell scripts for Bash and Zsh, designed to streamline development workflows, enhance terminal productivity, and provide a rich set of command-line utilities. It features a customizable prompt, advanced aliases, powerful navigation tools, an extensive Git toolkit, and various helper functions for development and system administration.

## 2. Features

*   **Enhanced Shell Experience**:
    *   Customizable, colorful, and informative prompts for both Bash and Zsh.
    *   Git integration in the prompt to show current branch and status.
    *   VI mode enabled by default for both shells with cursor shape indicators.
    *   Improved command-line completion and history settings.

*   **Powerful Navigation**:
    *   `xcd`: An enhanced `cd` command with shortcuts for frequently used directories (projects, downloads, work, etc.).
    *   `fcd`: A "fuzzy" `cd` to quickly navigate to a directory by name within the current path.
    *   `groot` / `proot`: Instantly jump to the root directory of the current Git or Repo project.
    *   `renter`: Go up one directory level from the current path.

*   **Extensive Git Toolkit**:
    *   `gstatus`: A concise `git status -uno`.
    *   `glog`: Pre-formatted, colorful git log views.
    *   `ginfo`: Displays detailed information about the current git repository (remote, branch, URL).
    *   `gpush`: A helper for pushing to Gerrit, with easy support for topics and drafts.
    *   `gforall`: Run a git command in all git repositories found under the current directory.
    *   `gfiles`: List or tar files changed between two commits.

*   **Development Utilities**:
    *   `erun`: An enhanced command runner that logs output, measures execution time, and can automatically analyze failures.
    *   `mbuild`: A wrapper for build commands that colorizes compiler output, highlighting errors and warnings.
    *   `banlys`: A build log analyzer to quickly find and display errors from a log file.
    *   `session` / `zession`: A powerful tmux/zellij session manager to easily create, attach, and manage named sessions.
    *   `pyvenv`: A wrapper to create, activate, and manage Python virtual environments with ease.
    *   `pvim` / `pvinit`: A suite of tools to set up a Vim-based IDE environment for a project, generating tags and cscope databases.

*   **File & System Utilities**:
    *   `clip`: A multi-buffer command-line clipboard. Store and retrieve text or file paths across multiple slots.
    *   `srm`: A safer `rm` command that blocks deletion of critical system directories and provides a trash-like feature.
    *   `bkfile`: Quickly back up a file or directory by renaming it with a timestamp and an index.
    *   `purify`: Cleans up text streams or filenames by removing special characters and ANSI color codes.
    *   `sysinfo`: Displays a clean, comprehensive summary of system hardware and software information.
    *   `ai`: A command-line interface for interacting with a local Ollama AI model.
    *   `wifi`: A command-line utility to scan, connect to, and manage Wi-Fi networks.

## 3. Installation

1.  **Clone the repository** to a location of your choice, for example, `~/.shellscripts`.
    ```sh
    git clone <repository_url> ~/.shellscripts
    ```

2.  **Source the main script** in your shell's configuration file.
    *   For **Bash**, add the following line to your `~/.bashrc`:
        ```sh
        source ~/.shellscripts/source.sh
        ```
    *   For **Zsh**, add the following line to your `~/.zshrc`:
        ```sh
        source ~/.shellscripts/source.sh
        ```

3.  Restart your shell or run `source ~/.bashrc` / `source ~/.zshrc` to apply the changes.

## 4. Configuration

You can customize the behavior of the scripts by creating a `~/.hsconfig.sh` file. This file is sourced before the default configurations, allowing you to override them.

Here are some common variables you can set:

*   `HS_CONFIG_ADVANCED_PROMOTE`: Set to `n` to disable the detailed, multi-line prompt.
*   `HS_CONFIG_CHANGE_DIR`: Set to `n` to prevent the shell from automatically changing to the last working directory on startup.
*   `HS_CONFIG_SAFE_COMMAND_REPLACEMENT`: Set to `y` to alias `rm` to the safer `srm` function.
*   `HS_VAR_VIM`: Set your preferred Vim executable (e.g., `nvim`).

**Example `~/.hsconfig.sh`:**

```sh
#!/bin/sh
# Disable the advanced prompt for a simpler look
export HS_CONFIG_ADVANCED_PROMOTE=n

# Enable the safe rm alias
export HS_CONFIG_SAFE_COMMAND_REPLACEMENT=y

# Set Neovim as the default editor
export HS_VAR_VIM="nvim"
```

## 5. Key Functions Quick Reference

*   `reload` / `refresh`: Reloads the entire shell environment.
*   `xcd [shortcut]`: Change directory. Try `xcd -h` for a list of shortcuts.
*   `clip -s [content]`: Set content to the clipboard.
*   `clip -g`: Get content from the clipboard.
*   `clip -l`: List all clipboard buffers.
*   `session [name]`: Create or attach to a tmux session named `[name]`.
*   `erun [command]`: Execute a command with logging and timing.
*   `mbuild [build_command]`: Run a build command with colored output.
*   `banlys [logfile]`: Analyze a build log for errors.
*   `ginfo`: Get info about the current Git repository.
*   `sysinfo`: Show system information.


Of course. Based on the files you've provided, here is a plain text README that summarizes the project.

# HS Shell Scripts Environment

## Overview

This project is a comprehensive collection of shell scripts designed to create a powerful, personalized, and productive command-line environment. It is modular, customizable, and supports both `bash` and `zsh`.

The environment provides a rich set of aliases, helper functions, and advanced tools that streamline daily workflows for developers, system administrators, and power users.

## Features

*   **Modular Core:** Separate configurations for `bash` and `zsh`, with a shared core function library.
*   **Customizable Prompt:** An advanced prompt that displays Git status, command success/failure, current time, and user/host information.
*   **Extensive Aliases:** A large set of predefined aliases for common commands like `ls`, `grep`, `git`, and more.
*   **Rich Function Library:** Dozens of helper functions for file/directory navigation, text processing, system interaction, and safe command execution.
*   **Developer Tools:** A suite of tools tailored for development, including:
    *   Git helpers for common operations (`ginfo`, `gpush`, `glog`).
    *   Build wrappers (`mbuild`) and log analyzers (`banlys`).
    *   Vim project management (`pvim`, `pvinit`) with ctags/cscope integration.
    *   Python virtual environment management (`pyvenv`).
*   **Session Management:** Powerful wrappers (`session`, `zession`) for `tmux` and `zellij` to easily manage named sessions.
*   **Safe Commands:** A safe replacement for `rm` (`srm`) that prevents accidental deletion of critical system directories and includes a trash feature.
*   **Configuration:** Easily configured through environment variables and a user-specific `~/.hsconfig.sh` file.

## Installation

To use this environment, source the `source.sh` script from your shell's startup file (`~/.bashrc` for bash or `~/.zshrc` for zsh).

Example:
```sh
# Add this line to your .bashrc or .zshrc
source /path/to/shellscripts/source.sh
```

## Configuration

You can customize the environment by creating a `~/.hsconfig.sh` file to override default settings.

Key configuration variables (found in `shell/enviroment/config.sh`):
*   `HS_CONFIG_ADVANCED_PROMOTE`: (y/n) Enable or disable the advanced, multi-line prompt.
*   `HS_CONFIG_SAFE_COMMAND_REPLACEMENT`: (y/n) If 'y', the `rm` command is aliased to the safer `srm` function.
*   `HS_CONFIG_CHANGE_DIR`: (y/n) If 'y', the shell will automatically `cd` to the last working directory on startup.
*   `HS_PATH_*`: A set of variables (`HS_PATH_DOWNLOAD`, `HS_PATH_PROJ`, etc.) that define shortcuts for the `xcd` command.

## Key Functions & Commands

This environment includes many functions. Here are some of the most notable ones:

### Navigation
*   `xcd [shortcut]`: An enhanced `cd` command with shortcuts for frequently used directories (e.g., `xcd proj`, `xcd dl`, `xcd hs`).
*   `groot`, `froot`, `droot`: Finds the root directory of a project based on the presence of a `.git` or `.repo` folder.
*   `fcd [name]`: Fuzzy-searches for a directory with the given name in subdirectories and `cd`s into it.

### File Management
*   `clip`: A powerful, multi-buffer clipboard for the command line. Use `clip -s "text"` to save and `clip -g` to get. Supports up to 6 buffers (`clip -b 1 ...`).
*   `srm`: A safe `rm` wrapper that blocks dangerous operations (e.g., `rm /`) and supports moving files to a trash directory instead of deleting them.
*   `bkfile [file]`: Creates a timestamped backup of a file or directory.
*   `purify [filename]`: Cleans up a filename by removing special characters and spaces.
*   `compressor` / `extract`: Easy-to-use wrappers for `tar` and other archiving tools.

### Development
*   `erun [command]`: An enhanced command runner that logs output, measures execution time, and can analyze failures with `banlys`.
*   `mbuild [build_command]`: A wrapper for build commands that colorizes compiler output, highlighting errors and warnings.
*   `banlys [logfile]`: A build analyzer that parses log files to find and summarize errors.
*   `ginfo`: Displays a summary of the current Git repository's remote, branch, and common commands.
*   `pvim`: A launcher for Vim that automatically configures the environment for the current project (tags, cscope, etc.).
*   `pyvenv`: A simple wrapper for creating and activating Python virtual environments.

### System & Tools
*   `session` / `zession`: Create, attach, list, and manage `tmux` or `zellij` sessions with simple names.
*   `sysinfo`: Displays a clean summary of system hardware and software information.
*   `ai [prompt]`: A command-line interface for interacting with a local AI model via Ollama.
*   `tstamp`: Prints a standard timestamp (`YYYYMMDD_HHMMSS`).
