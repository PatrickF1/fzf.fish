<div align="center">

# fzf.fish 🔍🐟

[![latest release badge][]][releases] [![fish version badge][]](#installation) [![awesome badge][]][awesome fish]

</div>

Augment your [Fish][] command line with mnemonic key bindings to efficiently find what you need using [fzf][].

## Features

Use `fzf.fish` to interactively find and insert into the command line:

### File paths

![file search][]

- **Search input:** recursive listing of current directory's files
- **Key binding and mnemonic:** <kbd>Ctrl</kbd>+<kbd>F</kbd> (`F` for file)
- **Preview window:** file with syntax highlighting, directory contents, or file type
- **Remarks**
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

### A shell variable

![shell variables search][]

- **Search input:** all the variable names of the environment, both local and exported
- **Key binding and mnemonic:** <kbd>Ctrl</kbd>+<kbd>V</kbd> (`V` for variable)
- **Preview window:** the value of the variable if it was exported

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

On certain distribution of Linux, you will need to alias `fdfind` to `fd` (see [#23][]).

## Configuration

### Using custom key bindings

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

## Prior art

### Jethrokuan/fzf

[jethrokuan/fzf][] is another fzf plugin that provides similar features and is prevalent in the fish community (470+ stargazers and 30 contributors, including me). In fact, I referenced it when creating this plugin—thank you Jethro!

So why _another_ fzf plugin? While contributing to `jethrokuan/fzf`, I was discouraged by the complexity and inefficiency of the code that resulted from feature cruft (e.g. it provides multiple overlapping ways to action on files: find, cd, and open) and poor design decisions (e.g. Tmux support was implemented using a variable command). Moreover, Jethro has lost interest in his plugin (he later confirmed to me that he stopped using fish). Wanting a sharper tool and to give back to the community, I decided to write my own plugin.

After much work, `fzf.fish` now implements most of the same features but is faster, easier to maintain, and more [Unix-y][unix philosophy]. I also added new features: using fzf to search git status, git log, and shell variables. However, I chose not to implement Tmux support, because users can easily add support externally themselves; and tab completion, because even `jethrokuan/fzf`'s implementation of it is buggy as evidenced by the many [issues reported about it][].

**TLDR:** choose `fzf.fish` over [jethrokuan/fzf][] if you want

- faster, more efficient, code
- code that is easier to debug if you encounter issues
- a tool built on [Unix philosophy][]
- a plugin that is more likely to attract future contributors because it is more maintainable
- a plugin that will be more frequently updated by its author (Jethro no longer uses fish)
- features for searching git status, git log, and shell variables

and you don't mind

- having to integrate fzf with Tmux yourself, which is easy to do
- not having buggy fzf tab completion

### Fzf's out-of-the-box Fish extension

Fzf optionally comes with its own [Fish extension][]. It is substantial but `fzf.fish` has these advantages over it:

- features for searching git status, git log, and shell variables
- timestamps when searching command history
- colorized results when searching for files
- previews when searching for files
- configurable key bindings
- [autoloaded][autoloads] functions for faster shell startup
- easier to read, maintain, and contribute to
- better maintained

## Troubleshooting

### Key bindings do not work

- Execute `bind` and check if there are bindings overriding the bindings starting with `__fzf_`.
- Ensure [jethrokuan/fzf][] and the [Fish extension][] that ships with fzf are uninstalled.
- Ensure you're using Fish 3.1.2 or newer.
- In your terminal's settings, map Option to Meta (see [#54]).

### File search feature does not work

- If you are on certain distribution of Linux, you will need to alias `fdfind` to `fd` (see [#23][]).
- `fd`, by default, ignores files also ignored by git. Check your local and global `.gitignore` files to see if the files not showing up have been ignored.

[#23]: https://github.com/patrickf1/fzf.fish/issues/23
[#54]: https://github.com/PatrickF1/fzf.fish/issues/54
[autoloads]: https://fishshell.com/docs/current/tutorial.html#autoloading-functions
[awesome badge]: https://awesome.re/mentioned-badge.svg
[awesome fish]: https://git.io/awsm.fish
[bat]: https://github.com/sharkdp/bat
[brew]: https://brew.sh
[command history search]: images/command_history.gif
[conf.d/fzf.fish]: conf.d/fzf.fish
[fd]: https://github.com/sharkdp/fd
[file search]: images/directory.gif
[Fish extension]: https://github.com/junegunn/fzf/blob/master/shell/key-bindings.fish
[fish version badge]: https://img.shields.io/badge/fish-v3.1.2%2B-green
[Fish]: http://fishshell.com
[Fisher]: https://github.com/jorgebucaran/fisher
[fzf_default_opts]: https://github.com/junegunn/fzf#environment-variables
[fzf]: https://github.com/junegunn/fzf
[git log search]: images/git_log.gif
[git status select]: images/git_status.gif
[ilancosman/tide]: https://github.com/IlanCosman/tide
[issues reported about it]: https://github.com/jethrokuan/fzf/issues?q=is%3Aissue+tab
[jethrokuan/fzf]: https://github.com/jethrokuan/fzf
[latest release badge]: https://img.shields.io/github/v/release/patrickf1/fzf.fish
[releases]: https://github.com/patrickf1/fzf.fish/releases
[shell variables search]: images/shell_variables.gif
[universal variable]: https://fishshell.com/docs/current/#more-on-universal-variables
[unix philosophy]: https://en.wikipedia.org/wiki/Unix_philosophy
