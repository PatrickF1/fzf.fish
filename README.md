<div align="center">

# fzf.fish 🔍🐟

[![latest release badge][]](https://github.com/patrickf1/fzf.fish/releases)
[![build status badge][]](https://github.com/patrickf1/fzf.fish/actions)
[![awesome badge][]](https://git.io/awsm.fish)

</div>

Augment your [Fish][] command line with mnemonic key bindings to efficiently find what you need using [fzf][].

https://user-images.githubusercontent.com/1967248/197308919-51d04602-2d5f-46aa-a96e-6cf1617e3067.mov

## Search commands

Use `fzf.fish` to interactively find and insert file paths, git commit hashes, and other entities into your command line. <kbd>Tab</kbd> to select multiple entries. If you trigger a search while your cursor is on a word, that word will be used to seed the fzf query and will be replaced by your selection. All searches include a preview of the entity hovered over to help you find what you're looking for.

### 📁 Search Directory

![Search Directory example](../assets/directory.png)

- **Fzf input:** recursive listing of current directory's non-hidden files
- **Output:** relative paths of selected files
- **Key binding and mnemonic:** <kbd>Ctrl</kbd>+<kbd>Alt</kbd>+<kbd>F</kbd> (`F` for file)
- **Preview window:** file with syntax highlighting, directory contents, or file type
- **Remarks**
  - directories are inserted with a trailing `/`, so if you select exactly one directory, you can immediately hit <kbd>ENTER</kbd> to [cd into it][cd docs]
  - if the current token is a directory with a trailing slash (e.g. `.config/<CURSOR>`), then that directory is searched instead
  - [ignores files that are also ignored by git](#fd-gi)

### 🪵 Search Git Log

![Search Git Log example](../assets/git_log.png)

- **Fzf input:** the current repository's formatted `git log`
- **Output:** hashes of selected commits
- **Key binding and mnemonic:** <kbd>Ctrl</kbd>+<kbd>Alt</kbd>+<kbd>L</kbd> (`L` for log)
- **Preview window:** commit message and diff

### 📝 Search Git Status

![Search Git Status example](../assets/git_status.png)

- **Fzf input:** the current repository's `git status`
- **Output:** relative paths of selected lines
- **Key binding and mnemonic:** <kbd>Ctrl</kbd>+<kbd>Alt</kbd>+<kbd>S</kbd> (`S` for status)
- **Preview window:** the git diff of the file

### 📜 Search History

![Search History example](../assets/history.png)

- **Fzf input:** Fish's command history
- **Output:** selected commands
- **Key binding and mnemonic:** <kbd>Ctrl</kbd>+<kbd>R</kbd> (`R` for reverse-i-search)
- **Preview window:** the entire command with Fish syntax highlighting

### 🖥️ Search Processes

![Search Processes example](../assets/processes.png)

- **Fzf input:** the pid and command of all running processes, outputted by `ps`
- **Output:** pids of selected processes
- **Key binding and mnemonic:** <kbd>Ctrl</kbd>+<kbd>Alt</kbd>+<kbd>P</kbd> (`P` for process)
- **Preview window:** the CPU usage, memory usage, start time, and other information about the process

### 💲 Search Variables

![Search Variables example](../assets/variables.png)

- **Fzf input:** all the shell variables currently [in scope][var scope]
- **Output:** selected shell variables
- **Key binding and mnemonic:** <kbd>Ctrl</kbd>+<kbd>V</kbd> (`V` for variable)
- **Preview window:** the variable's scope info and values
- `$history` is excluded for technical reasons so use [Search History](#-search-history) instead to inspect it

## Installation

First, install a proper version of these CLI dependencies:

| CLI      | Minimum version required | Description                             |
| -------- | ------------------------ | --------------------------------------- |
| [fish][] | 3.4.0                    | a modern shell                          |
| [fzf][]  | 0.33.0                   | fuzzy finder that powers this plugin    |
| [fd][]   | 8.5.0                    | faster, colorized alternative to `find` |
| [bat][]  | 0.16.0                   | smarter `cat` with syntax highlighting  |

[fd][] and [bat][] only need to be installed if you will use [Search Directory][].

Next, because `fzf.fish` is incompatible with other fzf plugins, [check for and remove these two common alternatives](https://github.com/PatrickF1/fzf.fish/wiki/Uninstalling-other-fzf-plugins).

Finally, install this plugin with [Fisher][].

> `fzf.fish` can be installed manually or with other plugin managers but only Fisher is officially supported.

```fish
fisher install PatrickF1/fzf.fish
```

## Configuration

### Customize key bindings

`fzf.fish` includes an ergonomic function for configuring its key bindings. Read [its documentation](/functions/_fzf_configure_bindings_help.fish):

```fish
fzf_configure_bindings --help
```

Call `fzf_configure_bindings` in your `config.fish` in order to persist your custom bindings.

### Change fzf options for all commands

fzf supports global default options via the [FZF_DEFAULT_OPTS or FZF_DEFAULT_OPTS_FILE](https://github.com/junegunn/fzf#environment-variables) environment variables.

`fzf.fish` sets [a sane `FZF_DEFAULT_OPTS` whenever it executes fzf](functions/_fzf_wrapper.fish) unless you export your own `FZF_DEFAULT_OPTS` or `FZF_DEFAULT_OPTS_FILE`.

### Change fzf options for a specific command

Each command's fzf options can be configured via a variable:

| Command           | Variable              |
| ----------------- | --------------------- |
| Search Directory  | `fzf_directory_opts`  |
| Search Git Log    | `fzf_git_log_opts`    |
| Search Git Status | `fzf_git_status_opts` |
| Search History    | `fzf_history_opts`    |
| Search Processes  | `fzf_processes_opts`  |
| Search Variables  | `fzf_variables_opts`  |

The value of each variable is appended last to fzf's options list. Because fzf uses the last instance of an option if it is specified multiple times, custom options take precedence. Custom fzf options unlock a variety of augmentations:

- add [fzf key bindings](https://www.mankier.com/1/fzf#Key/Event_Bindings) to [open files in Vim](https://github.com/PatrickF1/fzf.fish/pull/273)
- adjust the preview command or window
- [re-populate fzf's input list on demand](https://github.com/junegunn/fzf/issues/1750)
- change the [search mode](https://github.com/junegunn/fzf#search-syntax)

Find more ideas and tips in the [Cookbook](https://github.com/PatrickF1/fzf.fish/wiki/Cookbook).

### Change how Search Directory previews directories and regular files

[Search Directory][], by default, executes `ls` to preview directories and `bat` to preview [regular files](https://stackoverflow.com/questions/6858452).

To use your own directory preview command, set it in `fzf_preview_dir_cmd`:

```fish
set fzf_preview_dir_cmd eza --all --color=always
```

And to use your own file preview command, set it in `fzf_preview_file_cmd`:

```fish
set fzf_preview_file_cmd cat -n
```

Omit the target path for both variables as `fzf.fish` will itself [specify the argument to preview](functions/_fzf_preview_file.fish).

### Change what files are listed by Search Directory

To pass custom options to `fd` when [Search Directory][] executes it to populate the list of files, set them in `fzf_fd_opts`:

```fish
set fzf_fd_opts --hidden --max-depth 5
```

<a id='fd-gi'></a>By default, `fd` hides files listed in `.gitignore`. You can disable this behavior by adding the `--no-ignore` flag to `fzf_fd_opts`.

### Change Search Git Log's commit formatting

[Search Git Log][] executes `git log --format` to format the list of commits. To use your own [commit log format](https://git-scm.com/docs/git-log#Documentation/git-log.txt-emnem), set it in `fzf_git_log_format`. For example, this shows the hash and subject for each commit:

```fish
set fzf_git_log_format "%H %s"
```

The format must be one line per commit and the hash must be the first field, or else Search Git Log will fail to determine which commits you selected.

### Integrate with a diff highlighter

To pipe the git diff previews from [Search Git Log][] and [Search Git Status][] through a highlighter tool (e.g. [delta](https://github.com/dandavison/delta) or [diff-so-fancy](https://github.com/so-fancy/diff-so-fancy)), set a command invoking the highlighter in `fzf_diff_highlighter`. It should not pipe its output to a pager:

```fish
# width=20 so delta decorations don't wrap around small fzf preview pane
set fzf_diff_highlighter delta --paging=never --width=20
# Or, if using DFS
set fzf_diff_highlighter diff-so-fancy
```

### Change Search History's date time format

[Search History][] shows the date time each command was executed. To change how its formatted, set your [strftime format string](https://devhints.io/strftime) in `fzf_history_time_format`. For example, this shows the date time as DD-MM-YY:

```fish
set fzf_history_time_format %d-%m-%y
```

Do not to include the vertical box-drawing character `│` (not to be confused with the pipe character `|`) as it is relied on to delineate the date time from the command.

## Further reading

Find answers to these questions and more in the [project Wiki](https://github.com/PatrickF1/fzf.fish/wiki):

- How does `fzf.fish` [compare](https://github.com/PatrickF1/fzf.fish/wiki/Prior-Art) to other popular fzf plugins for Fish?
- Why isn't this [command working](https://github.com/PatrickF1/fzf.fish/wiki/Troubleshooting)?
- How can I [customize](https://github.com/PatrickF1/fzf.fish/wiki/Cookbook) this command?
- How can I [contribute](https://github.com/PatrickF1/fzf.fish/wiki/Contributing) to this plugin?

[awesome badge]: https://awesome.re/mentioned-badge.svg
[bat]: https://github.com/sharkdp/bat
[build status badge]: https://img.shields.io/github/actions/workflow/status/PatrickF1/fzf.fish/continuous_integration.yml?branch=main
[cd docs]: https://fishshell.com/docs/current/cmds/cd.html
[fd]: https://github.com/sharkdp/fd
[fish]: https://fishshell.com
[fisher]: https://github.com/jorgebucaran/fisher
[fzf]: https://github.com/junegunn/fzf
[latest release badge]: https://img.shields.io/github/v/release/patrickf1/fzf.fish
[search directory]: #-search-directory
[search git log]: #-search-git-log
[search git status]: #-search-git-status
[search history]: #-search-history
[var scope]: https://fishshell.com/docs/current/#variable-scope
