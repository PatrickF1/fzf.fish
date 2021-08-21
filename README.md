<div align="center">

# fzf.fish 🔍🐟

[![latest release badge][]](https://github.com/patrickf1/fzf.fish/releases)
[![build status badge][]](https://github.com/patrickf1/fzf.fish/actions)
[![awesome badge][]](https://git.io/awsm.fish)

</div>

Augment your [Fish][] command line with mnemonic key bindings to efficiently find what you need using [fzf][].

## Features

Use `fzf.fish` to interactively find and insert different shell entities into the command line:

### File paths

![gif directory](images/directory.gif)

- **Search input:** recursive listing of current directory's non-hidden files
- **Key binding and mnemonic:** <kbd>Ctrl</kbd>+<kbd>Alt</kbd>+<kbd>F</kbd> (`F` for file)
- **Preview window:** file with syntax highlighting, directory contents, or file type
- **Remarks**
  - appends `/` if the selection is a directory and the only path selected so you can hit <kbd>ENTER</kbd> to [immediately cd into it][cd docs]
  - if the current token is a directory with a trailing slash (e.g. `.config/<CURSOR>`), then that directory is searched instead
  - ignores files that are also ignored by git
  - <kbd>Tab</kbd> to multi-select

### Modified paths

![gif git status](images/git_status.gif)

- **Search input:** the current repository's `git status`
- **Key binding and mnemonic:** <kbd>Ctrl</kbd>+<kbd>Alt</kbd>+<kbd>S</kbd> (`S` for status)
- **Remarks:** <kbd>Tab</kbd> to multi-select

### A commit hash

![gif git log](images/git_log.gif)

- **Search input:** the current repository's formatted `git log`
- **Key binding and mnemonic:** <kbd>Ctrl</kbd>+<kbd>Alt</kbd>+<kbd>L</kbd> (`L` for log)
- **Preview window:** commit message and diff

### A previously run command

![gif command history](images/command_history.gif)

- **Search input:** Fish's command history
- **Key binding and mnemonic:** <kbd>Ctrl</kbd>+<kbd>R</kbd> (`R` for reverse-i-search)
- **Preview window:** the entire command with Fish syntax highlighting

### A shell variable

![gif shell variables](images/shell_variables.gif)

- **Search input:** all the variable names of the environment currently [in scope][var scope]
- **Key binding and mnemonic:** <kbd>Ctrl</kbd>+<kbd>V</kbd> (`V` for variable)
- **Preview window:** the scope info and values of the variable
- **Remarks**
  - `$history` is excluded for technical reasons so use the search command history feature instead to inspect it

_The prompt used in the screencasts was created using [IlanCosman/tide](https://github.com/IlanCosman/tide)._

## Installation

First, install a proper version of these CLI dependencies:

| CLI      | Minimum version required | Description                                    |
| -------- | ------------------------ | ---------------------------------------------- |
| [fish][] | 3.2.0                    | a modern shell                                 |
| [fzf][]  | 0.27.2                   | fuzzy finder that powers this plugin           |
| [fd][]   | 7.5.0                    | faster and more colorful alternative to `find` |
| [bat][]  | 0.16.0                   | smarter `cat` with syntax highlighting         |

The search directory feature uses [fd][] and [bat][] to list and preview files. If you don't plan on using search directory, then you don't need to install them.

Next, install this plugin with [Fisher][].

> `fzf.fish` can be installed manually or with other plugin managers but only Fisher is officially supported.

```fish
fisher install PatrickF1/fzf.fish
```

## Configuration

### Customize key bindings

`fzf.fish` includes a convenient wrapper for configuring its key bindings. It comes with command completions and is thoroughly documented. See

```fish
fzf_configure_bindings --help
```

Once you've found the `fzf_configure_bindings` command that produces the desired bindings, add it to your `config.fish` in order to persist the bindings.

### Always pass some options to fzf

fzf supports setting default options via the [FZF_DEFAULT_OPTS](https://github.com/junegunn/fzf#environment-variables) environment variable. If it is set, fzf implicitly prepends it to the options passed to it on every execution, scripted and interactive.

By default, `fzf.fish` will set a sane `FZF_DEFAULT_OPTS` every time before it executes Fzf. However, If you export your own `FZF_DEFAULT_OPTS` variable, then `fzf.fish` will forgo setting it and yours will be used instead. See [functions/\_fzf_wrapper.fish](functions/_fzf_wrapper.fish) for more details.

### Pass fzf options for a specific feature

The following variables can store custom options that will be passed to fzf by their respective feature:

| Feature                | Variable              |
| ---------------------- | --------------------- |
| Search directory       | `fzf_dir_opts`        |
| Search git status      | `fzf_git_status_opts` |
| Search git log         | `fzf_git_log_opts`    |
| Search command history | `fzf_history_opts`    |
| Search shell variables | `fzf_shell_vars_opts` |

They are always appended last to fzf's argument list. Because fzf uses the option appearing last when options conflict, your custom options can override hardcoded options. Custom fzf options unlocks a variety of possibilities in customizing and augmenting each feature such as:

- add [key bindings](https://www.mankier.com/1/fzf#Key/Event_Bindings) within fzf to operate on the selected line:
  - [open file in Vim](https://github.com/junegunn/fzf/issues/1360)
  - [preview image files](https://gitter.im/junegunn/fzf?at=5947962ef6a78eab48620792)
  - [copy to clipboard](https://betterprogramming.pub/boost-your-command-line-productivity-with-fuzzy-finder-985aa162ba5d)
  - git checkout commit
  - git reset file
- adjust the preview command or window
- [re-populate fzf's input list on demand](https://github.com/junegunn/fzf/issues/1750)
- change the search mode

### Change the command used to preview files

The search directory feature, by default, uses `bat` to preview the contents of files. `bat` is a well-adopted `cat` replacement with syntax highlighting, line numbers, and more. If you would like to change the preview tool (to `cat` to avoid installing a new dependency, or to add custom logic such as binary or image preview), you may set the `fzf_preview_file_cmd` variable. For example, in your `config.fish`, you may put:

```fish
set fzf_preview_file_cmd cat
```

Do not specify a target path in the command, as `fzf.fish` will [prepend the file][custom preview command] to preview to the command itself.

### Change the command used to preview directories

The search directory feature, by default, uses `ls` to preview the contents of directories. To integrate with the variety of `ls` replacements available (e.g. exa, lsd, tree), the command used to preview directories is configurable through the `fzf_preview_dir_cmd` variable. Set `fzf_preview_dir_cmd` in your `config.fish`:

```fish
set fzf_preview_dir_cmd exa --all --color=always
```

As above, do not specify a target path in the command. `fzf.fish` will [prepend the directory][custom preview command] to preview to the command itself.

### Change the files searched

To pass custom options to `fd` when it is executed to populate the list of files for the search directory feature, set the `fzf_fd_opts` variable. For example, to include hidden files but not `.git`, put this in your `config.fish`:

```fish
set fzf_fd_opts --hidden --exclude=.git
```

## Further reading

Find answers to these questions and more in the [project Wiki](https://github.com/PatrickF1/fzf.fish/wiki):

- How does `fzf.fish` [compare](https://github.com/PatrickF1/fzf.fish/wiki/Prior-Art) to other popular fzf plugins for Fish?
- Why isn't this [feature working](https://github.com/PatrickF1/fzf.fish/wiki/Troubleshooting) for me?
- How can I [customize](https://github.com/PatrickF1/fzf.fish/wiki/Cookbook) this feature?
- How can I [contribute](https://github.com/PatrickF1/fzf.fish/wiki/Contributing) to this plugin?

[awesome badge]: https://awesome.re/mentioned-badge.svg
[bat]: https://github.com/sharkdp/bat
[build status badge]: https://img.shields.io/github/workflow/status/patrickf1/fzf.fish/CI
[cd docs]: https://fishshell.com/docs/current/cmds/cd.html
[custom preview command]: functions/_fzf_preview_file.fish#L7
[fd]: https://github.com/sharkdp/fd
[fish]: https://fishshell.com
[fisher]: https://github.com/jorgebucaran/fisher
[fzf]: https://github.com/junegunn/fzf
[latest release badge]: https://img.shields.io/github/v/release/patrickf1/fzf.fish
[universal variable]: https://fishshell.com/docs/current/#more-on-universal-variables
[var scope]: https://fishshell.com/docs/current/#variable-scope
