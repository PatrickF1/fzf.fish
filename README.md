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
[Jethro Kuan](https://www.jethro.dev) created another [fzf plugin](https://github.com/jethrokuan/fzf) that provides a very similar feature set has become very well established in the fish community (it currently has 466 stars and received contributions from 30 people, including me). In fact, I borrowed a few concepts and even snippets of code from it in creating the initial draft of this plugin. Thank you, Jethro, for your plugin and all of your other important contributions to the fish community!

If there already exists a mature fzf plugin, why did I create another one? While attempting to introduce a new feature into Jethro's plugin, I was appalled by the complexity and inefficiency of the code that resulted from feature cruft (e.g. Tmux support) and poor design decisions (e.g. providing multiple ways to action on files rather than relying on the user to simply to in `cd` or `vim` to choose what they want to do to the file). As someone wants to use only the sharpest tools, I decided to port over the main features into my own plugin. After much work, I am proud to say that this plugin implements most of the same functionality while being much easier to maintain, leaves a smaller footprint, and overall more [Unix-y](https://en.wikipedia.org/wiki/Unix_philosophy). In addition of the original functionality, I've added two more pieces of functionality: using fzf to search git log and shell variables.

However, two features not currently covered are Tmux integration and tab completion, so advanced users relying on them may want to stick with Jethro's plugin.

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
