# fzf-fish-integration
A plugin that integrates `fzf` into your `fish` workflow. Creates handy functions&mdash;each with its own mnemonic keybinding&mdash;that use fzf to

> Search for a **file or folder** in the current directory - `Ctrl+f` (f for file)
<img alt="file search" src="./images/File Search.png">

> Search for a **commit** in the current git repository's log - `Ctrl+l` (l for log)
<img alt="git log search" src="./images/Git Log Search.png">

> Search for a **command** from command history - `Ctrl+r` (r for reverse-i-search)
<img alt="command history search" src="./images/Command History Search.png">

> Search for a **shell variable** (both local and exported) - `Ctrl+v` (v for variable)
<img alt="shell variables search" src="./images/Shell Variables Search.png">

## Prior Art
[@jethrokuan](https://github.com/jethrokuan) created another [fzf plugin](https://github.com/jethrokuan/fzf) that provides similar features and is popular in the fish community (it currently has 466 stars and has 30 contributors, including me). In fact, I borrowed some ideas and snippets of code from it when first creating this plugin&mdash;thank you so much, Jethro!

So why did I create an alternative fzf plugin? While attempting to contribute a patch to Jethro's plugin, I was appalled by the complexity and inefficiency of the code that resulted from feature cruft (e.g., it provides multiple ways to action on files (find, cd, and open) rather than relying on the user to action the files themselves using the command line) and poor design decisions (e.g., the Tmux support implemented using a variable command would have been better done using an alias). In addition, Jethro seemed to have lost interest in his plugin (he later confirmed to me that he stopped using fish). Wanting a sharper tool and to give back to the community, I decided to write my own plugin. After much work, `fzf-fish-integration` now implements most of the same features but is faster, easier to maintain, and more [Unix-y](https://en.wikipedia.org/wiki/Unix_philosophy). It also includes two new features: using fzf to search git log and to browse shell variables.
However, two features not included are Tmux support and tab completion.

**TLDR:** choose `fzf-fish-integration` over [jethrokuan/fzf](https://github.com/jethrokuan/fzf) if you want
- more efficient, faster code
- to run code that is easier to understand and debug if you encounter issues
- a tool built on [Unix philosophy](https://en.wikipedia.org/wiki/Unix_philosophy)
- a plugin that is more likely to attract future contributors because it is more maintainable
- a plugin that is more maintained (Jethro no longer uses fish)
- fzf integration for searching git log
- fzf integration for browsing shell variables

and you don't mind
- having to integrate fzf with Tmux yourself
- not having fzf integration with tab completion

## Installation
With [fisher](https://github.com/jorgebucaran/fisher)
```
fisher add patrickf3139/fzf-fish-integration
```

With [Oh My Fish](https://github.com/oh-my-fish/oh-my-fish)
```fish
omf install https://github.com/patrickf3139/fzf-fish-integration
```

In addition to this plugin, you will also need to install
- [fzf](https://github.com/junegunn/fzf), the command-line fuzzy finder that powers this plugin; and
- [fd](https://github.com/sharkdp/fd), a much faster and friendlier alternative to the antiquated `find` command and is used for the find file feature.

If you are on Mac, I recommend installing these two CLI tools using [brew](https://brew.sh/).
