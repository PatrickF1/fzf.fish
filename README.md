<div align="center">

# fzf.fish 🔍🐟
![latest release badge][]
![fish version badge][]
![license badge][]

</div>

A plugin that integrates [fzf][] into your [fish][] workflow. Comes with handy functions—each with its own mnemonic key binding—that use fzf to speed up common tasks.

## Features

Use `fzf.fish` to find and output:

### A `file`

![file search][]

- Search input: the tree of files in the current directory
- Key binding: `Ctrl+f`
- Mnemonic: f for file
- Preview window: file with syntax highlighting, directory contents, or file type

### Modified `paths`

![git status select][]

- Search input: the current repository's `git status`
- Key binding: `Ctrl+Alt+s`
- Mnemonic: s for status, Alt to prevent overriding `pager-toggle-search`
- Use `Tab` to multi-select

### A `commit` hash

![git log search][]

- Search input: the current repository's formatted `git log`
- Key binding: `Ctrl+Alt+l`
- Mnemonic: l for log, Alt to prevent overriding clear screen
- Preview window: commit message and diff

### A previously run `command`

![command history search][]

- Search input: the command history from all interactive sessions of `fish`
- Key binding: `Ctrl+r`
- Mnemonic: r for reverse-i-search

### A `shell variable`

![shell variables search][]

- Search input: all the variable names of the environment, both local and exported
- Key binding: `Ctrl+v`
- Mnemonic: v for variable
- Preview window: the value of the variable if it was exported

_The prompt used in the above screencasts was created using [IlanCosman/tide][]._

## Installation

First, ensure your fish version is >= 3.1.2.

```fish
> fish --version
fish, version 3.1.2
```

Next, install this plugin with a package manager.

- With [fisher][]

  ```fish
  fisher add patrickf3139/fzf.fish
  ```

- Or with [Oh My Fish][]

  ```fish
  omf install https://github.com/patrickf3139/fzf.fish
  ```

Finally, install the following CLI tools:

- [fzf][], the command-line fuzzy finder that powers this plugin;
- [fd][], a much faster and friendlier alternative to the antiquated `find` command (used for the file search feature); and
- [bat][], a smarter `cat` with syntax highlighting (used to preview files).

If you are on Mac, I recommend installing them using [brew][].

If you are on certain distribution of Linux, you will need to alias `fdfind` to `fd` (see [#23][]).

## Configuration

### Using custom key bindings

Each function is assigned mnemonic key bindings by default (see screencasts above) in [conf.d/fzf.fish][]. However, if you would like to customize them, you can prevent the default key bindings from executing by setting `fzf_fish_custom_keybindings` as a [universal variable][]. You can do this by running

```fish
set --universal fzf_fish_custom_keybindings
```

Do not try to set `fzf_fish_custom_keybindings` in your `config.fish` because `conf.d/fzf.fish` is sourced first on shell startup and so will not see it. Once it is set, you can set up your own key bindings.

### Fzf default options

fzf supports setting default options via the [FZF_DEFAULT_OPTS][] environment variable. If it is set, fzf will implicitly prepend its value to the options passed in on every execution, scripted or interactive.

To make fzf's interface friendlier, `fzf.fish` takes the liberty of setting a sane `FZF_DEFAULT_OPTS` if it is not already set. See [conf.d/fzf.fish][] for more details. This affects fzf even outside of this plugin. If you would like to remove this side effect or just want to customize fzf's default options, then set your own `FZF_DEFAULT_OPTS` universal variable. For example:

```fish
set --universal --export FZF_DEFAULT_OPTS --height 50% --margin 1
```

Alternatively, you can override it in your `config.fish` by adding in something like this:

```fish
set --export FZF_DEFAULT_OPTS --height 50% --margin 1
```

## Prior art

### jethrokuan/fzf

[jethrokuan/fzf][] is another fzf plugin that provides similar features and is prevalent in the fish community (470+ stargazers and 30 contributors, including me). In fact, I borrowed from it some ideas when creating this plugin—thank you Jethro!

So why _another_ fzf plugin? While contributing to `jethrokuan/fzf`, I was discouraged by the complexity and inefficiency of the code that resulted from feature cruft (e.g. it provides multiple ways to action on files (find, cd, and open) rather than relying on the user to action the files themselves using the command line) and poor design decisions (e.g. the Tmux support, implemented using a variable command, would have been better done using an alias). Moreover, Jethro seemed to have lost interest in his plugin (he later confirmed to me that he stopped using fish). Wanting a sharper tool and to give back to the community, I decided to write my own plugin.

After much work, `fzf.fish` now implements most of the same features but is faster, easier to maintain, and more [Unix-y][unix philosophy]. I also added new features: using fzf to search git status, git log, and shell variables. However, I chose not to implement Tmux support, because users can easily add support externally themselves; and tab completion, because even `jethrokuan/fzf`'s implementation of it is buggy and difficult to maintain as evidenced by the many [issues reported about it][].

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

### fzf's out-of-the-box fish extension

Fzf optionally comes with its own [fish extension][]. It is substantial but `fzf.fish` has several advantages over it. `fzf.fish`:

- has features for searching git status, git log, and shell variables
- includes timestamps when searching command history
- colorizes results when searching for files
- shows previews when searching for files
- has configurable key bindings
- [autoloads][] its functions for faster shell startup
- is easier to read, maintain, and contribute to
- will likely be more frequently updated

## Troubleshooting

### Key bindings do not work

- Execute `bind` and check if there are bindings overriding the bindings starting with `__fzf_`.
- Ensure [jethrokuan/fzf][] and the [fish extension][] that ships with fzf are uninstalled.
- Ensure your fish version is >= 3.1.2.

### File search feature does not work

- If you are on certain distribution of Linux, you will need to alias `fdfind` to `fd` (see [#23][]).
- `fd`, by default, ignores files matching from your `.gitignore`. Check your local and global `.gitignore` files to see if the files not showing up have been ignored there.


[#23]: https://github.com/patrickf3139/fzf.fish/issues/23
[autoloads]: https://fishshell.com/docs/current/tutorial.html#autoloading-functions
[bat]: https://github.com/sharkdp/bat
[brew]: https://brew.sh/
[command history search]: images/command_history.gif
[conf.d/fzf.fish]: conf.d/fzf.fish
[fd]: https://github.com/sharkdp/fd
[file search]: images/directory.gif
[fish extension]: https://github.com/junegunn/fzf/blob/master/shell/key-bindings.fish
[fish]: http://fishshell.com
[fish version badge]: https://img.shields.io/badge/fish-3.1.2%2B-blue
[fisher]: https://github.com/jorgebucaran/fisher
[fzf_default_opts]: https://github.com/junegunn/fzf#environment-variables
[fzf]: https://github.com/junegunn/fzf
[git log search]: images/git_log.gif
[git status select]: images/git_status.gif
[issues reported about it]: https://github.com/jethrokuan/fzf/issues?q=is%3Aissue+tab
[IlanCosman/tide]: https://github.com/IlanCosman/tide
[jethrokuan/fzf]: https://github.com/jethrokuan/fzf
[latest release badge]: https://img.shields.io/github/v/release/patrickf3139/fzf.fish
[license badge]: https://img.shields.io/github/license/patrickf3139/fzf.fish
[oh my fish]: https://github.com/oh-my-fish/oh-my-fish
[shell variables search]: images/shell_variables.gif
[universal variable]: https://fishshell.com/docs/current/#more-on-universal-variables
[unix philosophy]: https://en.wikipedia.org/wiki/Unix_philosophy
