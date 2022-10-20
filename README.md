<div align="center">

# fzf.fish 🔍🐟

[![latest release badge][]](https://github.com/patrickf1/fzf.fish/releases)
[![build status badge][]](https://github.com/patrickf1/fzf.fish/actions)
[![awesome badge][]](https://git.io/awsm.fish)

</div>

Augment your [Fish][] command line with mnemonic key bindings to efficiently find what you need using [fzf][].

## Search commands

Use `fzf.fish` to interactively find and insert file paths, git commit hashes, and other entities into your command line. <kbd>Tab</kbd> to select multiple entries. If you trigger a search while your cursor is on a word, that word will be used to seed the fzf query and will be replaced by your selection. All searches include a preview of the entity hovered over so you can seamlessly decide if it's what you're looking for.

### 📁 Search Directory

![gif directory](../assets/directory.gif)

- **Fzf input:** recursive listing of current directory's non-hidden files
- **Output:** relative paths of selected files
- **Key binding and mnemonic:** <kbd>Ctrl</kbd>+<kbd>Alt</kbd>+<kbd>F</kbd> (`F` for file)
- **Preview window:** file with syntax highlighting, directory contents, or file type
- **Remarks**
  - appends `/` to directories selected so you can hit <kbd>ENTER</kbd> to [immediately cd into it][cd docs] if it is the only token on the command line
  - if the current token is a directory with a trailing slash (e.g. `.config/<CURSOR>`), then that directory is searched instead
  - [ignores files that are also ignored by git](#fd-gi)

### 📝 Search Git Status

![gif git status](../assets/git_status.gif)

- **Fzf input:** the current repository's `git status`
- **Output:** relative paths of selected lines
- **Key binding and mnemonic:** <kbd>Ctrl</kbd>+<kbd>Alt</kbd>+<kbd>S</kbd> (`S` for status)
- **Preview window:** the git diff of the file

### 🪵 Search Git Log

![gif git log](../assets/git_log.gif)

- **Fzf input:** the current repository's formatted `git log`
- **Output:** hashes of selected commits
- **Key binding and mnemonic:** <kbd>Ctrl</kbd>+<kbd>Alt</kbd>+<kbd>L</kbd> (`L` for log)
- **Preview window:** commit message and diff

### 📜 Search Command History

![gif command history](../assets/command_history.gif)

- **Fzf input:** Fish's command history
- **Output:** selected commands
- **Key binding and mnemonic:** <kbd>Ctrl</kbd>+<kbd>R</kbd> (`R` for reverse-i-search)
- **Preview window:** the entire command with Fish syntax highlighting

### 🐚 Search Shell Variables

![gif shell variables](../assets/shell_variables.gif)

- **Fzf input:** all the shell variables currently [in scope][var scope]
- **Output:** selected variables
- **Key binding and mnemonic:** <kbd>Ctrl</kbd>+<kbd>V</kbd> (`V` for variable)
- **Preview window:** the variable's scope info and values
- `$history` is excluded for technical reasons so use [Search Command History](#-search-command-history) instead to inspect it

### 🖥️ Search Processes

![gif processes](../assets/processes.gif)

- **Fzf input:** the pid and command of all running processes, outputted by `ps`
- **Output:** pids of selected processes
- **Key binding and mnemonic:** <kbd>Ctrl</kbd>+<kbd>Alt</kbd>+<kbd>P</kbd> (`P` for process)
- **Preview window:** the CPU usage, memory usage, start time, and other information about the process

## Installation

First, install a proper version of these CLI dependencies:

| CLI      | Minimum version required | Description                                    |
| -------- | ------------------------ | ---------------------------------------------- |
| [fish][] | 3.2.0                    | a modern shell                                 |
| [fzf][]  | 0.27.2                   | fuzzy finder that powers this plugin           |
| [fd][]   | 8.3.0                    | faster and more colorful alternative to `find` |
| [bat][]  | 0.16.0                   | smarter `cat` with syntax highlighting         |

[fd][] and [bat][] only need to be installed if you will use [Search Directory][]. If your package manager [doesn't install them as `fd` and `bat`](https://github.com/PatrickF1/fzf.fish/wiki/Troubleshooting#search-directory-does-not-work) respectively, then you can symlink them to those names.

Next, install this plugin with [Fisher][].

> `fzf.fish` can be installed manually or with other plugin managers but only Fisher is officially supported.

```fish
fisher install PatrickF1/fzf.fish
```

## Configuration

### Customize key bindings

`fzf.fish` includes an ergonomic wrapper for configuring its key bindings. Read [its documentation](/functions/_fzf_configure_bindings_help.fish) with this command:

```fish
fzf_configure_bindings --help
```

Once you've determined the desired `fzf_configure_bindings` command, add it to your `config.fish` in order to persist the bindings.

### Always pass some options to fzf

fzf supports global default options via the [FZF_DEFAULT_OPTS](https://github.com/junegunn/fzf#environment-variables) environment variable. If set, fzf implicitly prepends its value to the options it receives on every execution, scripted and interactive.

`fzf.fish` locally sets [a sane `FZF_DEFAULT_OPTS` whenever it executes fzf](functions/_fzf_wrapper.fish). If you export your own `FZF_DEFAULT_OPTS`, then yours will be used instead.

### Pass fzf options for a specific command

The following variables can store custom options that will be passed to fzf by their respective command:

| Command                | Variable              |
| ---------------------- | --------------------- |
| Search Directory       | `fzf_dir_opts`        |
| Search Git Status      | `fzf_git_status_opts` |
| Search Git Log         | `fzf_git_log_opts`    |
| Search Command History | `fzf_history_opts`    |
| Search Shell Variables | `fzf_shell_vars_opts` |
| Search Processes       | `fzf_processes_opts`  |

They are appended last to fzf's options list. Because fzf uses the last instance of an option if it is specified multiple times, custom options will always take precedence. Custom fzf options unlock a variety of customizations and augmentations such as:

- add [key bindings](https://www.mankier.com/1/fzf#Key/Event_Bindings) within fzf to operate on the selected line:
  - [open file in Vim](https://github.com/junegunn/fzf/issues/1360)
  - [preview image files](https://gitter.im/junegunn/fzf?at=5947962ef6a78eab48620792)
  - git reset file
- adjust the preview command or window
- [re-populate fzf's input list on demand](https://github.com/junegunn/fzf/issues/1750)
- change the [search mode](https://github.com/junegunn/fzf#search-syntax)

Find more ideas and implementation tips in the [Cookbook](https://github.com/PatrickF1/fzf.fish/wiki/Cookbook).

### Change how Search Directory previews directories and regular files

[Search Directory][], by default, calls `ls` to preview directories and `bat` to preview [regular files](https://stackoverflow.com/questions/6858452).

To change the directory preview command (e.g. to use one of the many `ls` replacements such as `exa`), set `fzf_preview_dir_cmd` to the desired command:

```fish
set fzf_preview_dir_cmd exa --all --color=always
```

And to change the file preview command (e.g. to `cat` to avoid having to install `bat`, or to add logic for previewing images), set `fzf_preview_file_cmd` to the desired command:

```fish
set fzf_preview_file_cmd cat
```

Omit the target path for both variables as `fzf.fish` will itself [specify the target to preview](functions/_fzf_preview_file.fish).

### Change what files are listed in Search Directory

To pass custom options to `fd` when it is executed to populate the list of files for [Search Directory][], set them in `fzf_fd_opts`. For example, to include hidden files but not `.git`:

```fish
set fzf_fd_opts --hidden --exclude=.git
```

<a id='fd-gi'></a>By default, `fd` hides files listed in `.gitignore`. You can disable this behavior by adding the `--no-ignore` flag to `fzf_fd_opts`.

## Further reading

Find answers to these questions and more in the [project Wiki](https://github.com/PatrickF1/fzf.fish/wiki):

- How does `fzf.fish` [compare](https://github.com/PatrickF1/fzf.fish/wiki/Prior-Art) to other popular fzf plugins for Fish?
- Why isn't this [command working](https://github.com/PatrickF1/fzf.fish/wiki/Troubleshooting)?
- How can I [customize](https://github.com/PatrickF1/fzf.fish/wiki/Cookbook) this command?
- How can I [contribute](https://github.com/PatrickF1/fzf.fish/wiki/Contributing) to this plugin?

[awesome badge]: https://awesome.re/mentioned-badge.svg
[bat]: https://github.com/sharkdp/bat
[build status badge]: https://img.shields.io/github/workflow/status/patrickf1/fzf.fish/CI
[cd docs]: https://fishshell.com/docs/current/cmds/cd.html
[fd]: https://github.com/sharkdp/fd
[fish]: https://fishshell.com
[fisher]: https://github.com/jorgebucaran/fisher
[fzf]: https://github.com/junegunn/fzf
[latest release badge]: https://img.shields.io/github/v/release/patrickf1/fzf.fish
[search directory]: #-search-directory
[var scope]: https://fishshell.com/docs/current/#variable-scope
