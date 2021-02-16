<div align="center">

# fzf.fish 🔍🐟

[![latest release badge][]][releases] [![build status badge][]][actions] [![awesome badge][]][awesome fish]

</div>

Augment your [Fish][] command line with mnemonic key bindings to efficiently find what you need using [fzf][].

## Features

Use `fzf.fish` to interactively find and insert into the command line:

### File paths

![file search][]

- **Search input:** recursive listing of current directory's non-hidden files
- **Key binding and mnemonic:** <kbd>Ctrl</kbd>+<kbd>F</kbd> (`F` for file)
- **Preview window:** file with syntax highlighting, directory contents, or file type
- **Remarks**
  - prepends `./` to the selection if only one selection is made and it becomes the only token on the command line, making it easy to execute if an executable, or cd into if a directory (see [cd docs][])
  - if the current token is a directory with a trailing slash (e.g. `functions/<CURSOR>`), then search will be scoped to that directory
  - ignores files that are also ignored by git
  - <kbd>Tab</kbd> to multi-select

### Modified paths

![git status select][]

- **Search input:** the current repository's `git status`
- **Key binding and mnemonic:** <kbd>Ctrl</kbd>+<kbd>Alt</kbd>+<kbd>S</kbd> (`S` for status, `Alt` to prevent overriding `pager-toggle-search`)
- **Remarks:** <kbd>Tab</kbd> to multi-select

### A commit hash

![git log search][]

- **Search input:** the current repository's formatted `git log`
- **Key binding and mnemonic:** <kbd>Ctrl</kbd>+<kbd>Alt</kbd>+<kbd>L</kbd> (`L` for log, `Alt` to prevent overriding clear screen)
- **Preview window:** commit message and diff

### A previously run command

![command history search][]

- **Search input:** the command history from all interactive sessions of Fish
- **Key binding and mnemonic:** <kbd>Ctrl</kbd>+<kbd>R</kbd> (`R` for reverse-i-search)
- **Preview window:** the entire command, wrapped

### A shell variable

![shell variables search][]

- **Search input:** all the variable names of the environment, both local and exported
- **Key binding and mnemonic:** <kbd>Ctrl</kbd>+<kbd>V</kbd> (`V` for variable)
- **Preview window:** the scope info and values of the variable
- **Remarks**
  - `$history` is excluded for technical reasons so use the search command history feature instead to inspect it

_The prompt used in the screencasts was created using [IlanCosman/tide][]._

## Installation

First, make sure you're using [Fish][] `3.1.2` or newer.

```console
$ fish --version
fish, version 3.1.2
```

Next, install with [Fisher][].

> `fzf.fish` can be installed manually or with other plugin managers but only Fisher is officially supported.

```fish
fisher install PatrickF1/fzf.fish
```

Finally, install the following CLI tools:

- [fzf][] - command-line fuzzy finder that powers this plugin
- [fd][] - much faster and friendlier alternative to `find`
- [bat][] - smarter `cat` with syntax highlighting (used to preview files)

For macOS, I recommend installing them using [brew][].

On certain distribution of Linux, you will need to alias `fdfind` to `fd` (see [#93](https://github.com/PatrickF1/fzf.fish/discussions/93)).

## Configuration

### Custom key bindings

If you would like to customize the key bindings, first, prevent the default key bindings from executing by setting `fzf_fish_custom_keybindings` as an [universal variable][]. You can do this with

```fish
set --universal fzf_fish_custom_keybindings
```

Do not try to set `fzf_fish_custom_keybindings` in your `config.fish` because the key binding configuration is sourced first on shell startup and so will not see it.

Next, set your own key bindings by following [conf.d/fzf.fish][] as an example.

### Fzf default options

fzf supports setting default options via the [FZF_DEFAULT_OPTS][] environment variable. If it is set, fzf will implicitly prepend its value to the options passed in on every execution, scripted or interactive.

To make fzf's interface friendlier, `fzf.fish` takes the liberty of setting a sane `FZF_DEFAULT_OPTS` if it is not already set. See [conf.d/fzf.fish][] for more details. This affects fzf even outside of this plugin. If you would like to remove this side effect or just want to customize fzf's default options, then set your own `FZF_DEFAULT_OPTS` universal variable. For example:

```fish
set --universal --export FZF_DEFAULT_OPTS --height 50% --margin 1
```

Alternatively, you can override it in your `config.fish`:

```fish
set --export FZF_DEFAULT_OPTS --height 50% --margin 1
```

### Change the command used to preview folders

The search files feature, by default, uses `ls` to preview the contents of a directory. To integrate with the variety of `ls` replacements available, the command used to preview directories is configurable through the `fzf_preview_dir_cmd` variable. For example, in your `config.fish`, you may put:

```fish
set fzf_preview_dir_cmd exa --all --color=always
```

Do not specify a target path in the command, as `fzf.fish` will [prepend the directory][custom preview command] to preview to the command itself.

### Change the files searched

To pass custom options to `fd` when it is executed to populate the list of files for the search files feature, set the `fzf_fd_opts` variable. For example, to include hidden files but not `.git`, put this in your `config.fish`:

```fish
set fzf_fd_opts --hidden --exclude=.git
```

### Change the key binding or Fzf options for a single command

See the [FAQ][] Wiki page.

## Prior art

If `fzf.fish` is a useful plugin, it is by standing on the shoulder of giants. There are two other fzf integrations for Fish worth regarding: [jethrokuan/fzf][] and fzf's out-of-the-box [Fish extension][]. The [Prior Art][] Wiki page explains how `fzf.fish` compares to and improves on them.

## Troubleshooting & FAQ

Need help? These Wiki pages can guide you:

- [Troubleshooting][troubleshooting]
- [FAQ][faq]

[actions]: https://github.com/PatrickF1/fzf.fish/actions
[awesome badge]: https://awesome.re/mentioned-badge.svg
[awesome fish]: https://git.io/awsm.fish
[bat]: https://github.com/sharkdp/bat
[brew]: https://brew.sh
[build status badge]: https://img.shields.io/github/workflow/status/patrickf1/fzf.fish/CI
[custom preview command]: functions/__fzf_preview_file.fish#L7
[cd docs]: https://fishshell.com/docs/current/cmds/cd.html
[command history search]: images/command_history.gif
[conf.d/fzf.fish]: conf.d/fzf.fish
[faq]: https://github.com/PatrickF1/fzf.fish/wiki/FAQ
[fd]: https://github.com/sharkdp/fd
[file search]: images/directory.gif
[fish]: http://fishshell.com
[fisher]: https://github.com/jorgebucaran/fisher
[fish extension]: https://github.com/junegunn/fzf/blob/master/shell/key-bindings.fish
[fzf_default_opts]: https://github.com/junegunn/fzf#environment-variables
[fzf]: https://github.com/junegunn/fzf
[git log search]: images/git_log.gif
[git status select]: images/git_status.gif
[ilancosman/tide]: https://github.com/IlanCosman/tide
[jethrokuan/fzf]: https://github.com/jethrokuan/fzf
[latest release badge]: https://img.shields.io/github/v/release/patrickf1/fzf.fish
[prior art]: https://github.com/PatrickF1/fzf.fish/wiki/Prior-Art
[releases]: https://github.com/patrickf1/fzf.fish/releases
[shell variables search]: images/shell_variables.gif
[troubleshooting]: https://github.com/PatrickF1/fzf.fish/wiki/Troubleshooting
[universal variable]: https://fishshell.com/docs/current/#more-on-universal-variables
[unix philosophy]: https://en.wikipedia.org/wiki/Unix_philosophy
