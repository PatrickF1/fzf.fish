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
I want to give credit to Jethro Kuan for some of the ideas implemented in his [fzf plugin](https://github.com/jethrokuan/fzf). You'll notice that his plugin also covers using fzf to search the current directory and through command history. Why reinvent the wheel, then? Well, I wanted something with most of the same functionality but is also simpler, easier to maintain, and leaves a smaller footprint. I think I've achieved that here--and more. Since porting over some of the functionality of Jethro's plugin, I've added two more pieces of functionality: using fzf to search git log and shell variables. However, for more advanced use cases, Jethro's plugin may still make more sense.

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
