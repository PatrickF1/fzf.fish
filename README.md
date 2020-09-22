<div align="center">

# fzf.fish

</div>

A plugin that integrates [fzf](https://github.com/junegunn/fzf) into your [fish](http://fishshell.com) workflow. Comes with handy functions—each with its own mnemonic key binding—that use fzf to

> Search and preview files under the **current directory** - `Ctrl+f` (f for file)

![file search](/images/current_dir_files.png)

> Search the current repository's **git status** - `Ctrl+Alt+s` (s for status, Alt to prevent overriding filter tab completion), `⇥` to multi-select

![git status select](/images/git_status.png)

> Search and preview the current repository's **git log** - `Ctrl+Alt+l` (l for log, Alt to prevent overriding clear screen)

![git log](/images/git_log.png)

> Search **command history** - `Ctrl+r` (r for reverse-i-search)

![command history search](/images/command_history.png)

> Search and preview **shell variables** (both local and exported) - `Ctrl+v` (v for variable)

![shell variables search](/images/shell_variables.png)

## Installation

First, make sure you are running fish `3.1.2`.

```fish
> fish --version
fish, version 3.1.2
```

Next, install this plugin with a package manager.

- With [fisher](https://github.com/jorgebucaran/fisher)

  ```fish
  fisher add patrickf3139/fzf.fish
  ```

- Or with [Oh My Fish](https://github.com/oh-my-fish/oh-my-fish)

  ```fish
  omf install https://github.com/patrickf3139/fzf.fish
  ```

Finally, install the following CLI tools:

- [fzf](https://github.com/junegunn/fzf), the command-line fuzzy finder that powers this plugin;
- [fd](https://github.com/sharkdp/fd), a much faster and friendlier alternative to the antiquated `find` command (used for the file search feature); and
- [bat](https://github.com/sharkdp/bat), a smarter `cat` with syntax highlighting (used to preview files).

If you are on Mac, I recommend installing them using [brew](https://brew.sh/).

If you are on Ubuntu, you will need to alias `fdfind` to `fd` (see [#23](https://github.com/patrickf3139/fzf.fish/issues/23)).

## Configuration

### Using custom key bindings

Each function is assigned mnemonic key bindings by default (see screenshots above) in [conf.d/fzf.fish](conf.d/fzf.fish). However, if you would like to customize them, you can prevent the default key bindings from executing by setting `fzf_fish_custom_keybindings` as a [universal variable](https://fishshell.com/docs/current/#more-on-universal-variables). You can do this by running

```fish
set --universal fzf_fish_custom_keybindings
```

Do not try to set `fzf_fish_custom_keybindings` in your `config.fish` because `conf.d/fzf.fish` is sourced first on shell startup and so will not see it. Once it is set, you can set up your own key bindings.

### Fzf default options <br>

fzf supports setting default options via the [FZF_DEFAULT_OPTS](https://github.com/junegunn/fzf#environment-variables) environment variable. If it is set, fzf will implicitly prepend its value to the options passed in on every execution, scripted or interactive.

To make fzf's interface friendlier, `fzf.fish` takes the liberty of setting a sane `FZF_DEFAULT_OPTS` if it is not already set. See [conf.d/fzf.fish](conf.d/fzf.fish) for more details. This affects fzf even outside of this plugin. If you would like to remove this side effect or just want to customize fzf's default options, then set your own `FZF_DEFAULT_OPTS` universal variable. For example:

```fish
set --universal --export FZF_DEFAULT_OPTS --height 50% --margin 1
```

Alternatively, you can override it in your `config.fish` by adding in something like this:

```fish
set --export FZF_DEFAULT_OPTS --height 50% --margin 1
```

## Prior art

### jethrokuan/fzf

[jethrokuan/fzf](https://github.com/jethrokuan/fzf) is another fzf plugin that provides similar features and is prevalent in the fish community (470+ stargazers and 30 contributors, including me). In fact, I borrowed from it some ideas when creating this plugin—thank you Jethro!

So why _another_ fzf plugin? While contributing to `jethrokuan/fzf`, I was discouraged by the complexity and inefficiency of the code that resulted from feature cruft (e.g. it provides multiple ways to action on files (find, cd, and open) rather than relying on the user to action the files themselves using the command line) and poor design decisions (e.g. the Tmux support, implemented using a variable command, would have been better done using an alias). Moreover, Jethro seemed to have lost interest in his plugin (he later confirmed to me that he stopped using fish). Wanting a sharper tool and to give back to the community, I decided to write my own plugin.

After much work, `fzf.fish` now implements most of the same features but is faster, easier to maintain, and more [Unix-y](https://en.wikipedia.org/wiki/Unix_philosophy). I also added new features: using fzf to search git status, git log, and shell variables. However, I chose not to implement Tmux support, because users can easily add support externally themselves; and tab completion, because even `jethrokuan/fzf`'s implementation of it is buggy and difficult to maintain as evidenced by the many [issues reported about it](https://github.com/jethrokuan/fzf/issues?q=is%3Aissue+tab).

**TLDR:** choose `fzf.fish` over [jethrokuan/fzf](https://github.com/jethrokuan/fzf) if you want

- more efficient, faster code
- to run code that is easier to debug in case you encounter issues
- a tool built on [Unix philosophy](https://en.wikipedia.org/wiki/Unix_philosophy)
- a plugin that is more likely to attract future contributors because it is more maintainable
- a plugin that will be more frequently updated by its author (Jethro no longer uses fish)
- functionality for searching git status, git log, and shell variables

and you don't mind

- having to integrate fzf with Tmux yourself, which is easy to do
- not having buggy fzf tab completion

### fzf's out-of-the-box fish extension

Fzf optionally comes with its [own fish extension](https://github.com/junegunn/fzf/blob/master/shell/key-bindings.fish). It is substantial but `fzf.fish` has several advantages over it. `fzf.fish`:

- has features for searching git status, git log, and shell variables
- includes timestamps when searching command history
- colorizes results when searching for files
- shows previews when searching for files
- has configurable key bindings
- [autoloads](https://fishshell.com/docs/current/tutorial.html#autoloading-functions) its functions for faster shell startup
- is easier to read, maintain, and contribute to
- will likely be more frequently updated
