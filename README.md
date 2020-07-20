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
[Jethro Kuan](https://www.jethro.dev) created another [fzf plugin](https://github.com/jethrokuan/fzf) that provides a similar feature set and is quote popular in the fish community (it currently has 466 stars and received contributions from 30 people, including me). In fact, I borrowed some ideas and snippets of code from it when creating this plugin&mdash;thank you so much, Jethro!

However, while attempting to introduce a new feature into Jethro's plugin, I was appalled by the complexity and inefficiency of the code that resulted from feature cruft (e.g., it provides multiple ways to action on files via find, cd, or open rather than relying on the user to execute the desired command via the command line) and poor design decisions (e.g., its built-in Tmux support would have been better supported through an alias). In addition, Jethro seemed to have lost interest his plugin (he later confirmed to me that he stopped using fish). As someone who wants to use only the sharpest tools and give back to the fish community, I decided to port over the main features into my own plugin. After much work, `fzf-fish-integration` now implements most of the same functionality while having a smaller footprint, being easier to maintain, and being overall more [Unix-y](https://en.wikipedia.org/wiki/Unix_philosophy). Additionally, it contains two pieces of functionality not found in Jethro's: using fzf to search git log and browse shell variables.

However, two features not currently covered are Tmux integration and tab completion, so advanced users relying on them may want to stick with Jethro's plugin.

tl;dr choose `fzf-fish-integration` over [Jethro's plugin](https://github.com/jethrokuan/fzf) if you want
- more efficient, slightly faster code
- to run code that is easier to understand and debug if you encounter issues
- a plugin that is more likely to attract future open source contributions because it is more maintainable
- a plugin that is much more maintained (Jethro is no longer active in the fish community)
- fzf integration for searching git log
- fzf integration for browsing shell variables

and you don't mind
- having to integrate with Tmux yourself
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
- [fd](https://github.com/sharkdp/fd), a much faster and friendlier alternative to the antiquated `find` command and is used for the find file functionality.

If you are on Mac, I recommend installing these two CLI tools using [brew](https://brew.sh/).
