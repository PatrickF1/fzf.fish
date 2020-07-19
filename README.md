# fzf_fish_integration
`fisher` plugin to integrate `fzf` into your `fish` workflow. Comes with handy shortcuts for quickly executing common `fzf` use cases:
| Functionality | Keybinding | Example |
|---------------|------------|---------|
| Search for a file in current directory | `Ctrl+f` (f for file) | <img alt="file search" src="./images/File Search.png"> |
| Search for a commit in git log | `Ctrl+l` (l for log) | <img alt="git log search" src="./images/Git Log Search.png"> |
| Search for a command to re-run | `Ctrl+r` (r for reverse-i-search) | <img alt="command history search" src="./images/Command History Search.png"> |
| Search for a shell variable name | `Ctrl+v` (v for variable) | <img alt="file search" src="./images/Shell Variables Search.png">

## Background
I originally included some of this functionality in [my dotfiles as autoloaded functions](https://github.com/patrickf3139/dotfiles/pull/11). Eventually, I decided it made more sense to keep the logic of complex utilities separate from my dotfiles, which should only be focused on the management of my configuration, so moved it into its own repo. I also wanted to make this functionality more widely discoverable and available so made it a plugin.

I want to give credit to Jethro Kuan for some of the ideas implemented in his [fzf plugin](https://github.com/jethrokuan/fzf). You'll notice that his plugin also covers searching for files and searching through command history with fzf. Why reinvent the wheel, then? Well, I wanted something that is simpler and lighter, something easier to maintain and that leaves a small footprint on my shell environment while maintaining most of the functionality. I think I've achieved that here--and more. Since porting over the functionality of Jethro's plugin, I've added two more pieces of fzf functionality: searching git log and searching shell variables. Therefore, I think in most cases, this plugin makes more sense.

## Install
With [fisher](https://github.com/jorgebucaran/fisher)
```
fisher add patrickf3139/fzf_fish_integration
```

With [Oh My Fish](https://github.com/oh-my-fish/oh-my-fish)
```fish
omf install https://github.com/patrickf3139/fzf_fish_integration
```

In addition to this plugin, you will also need to install
- [fzf](https://github.com/junegunn/fzf), the command-line fuzzy finder that powers this plugin; and
- [fd](https://github.com/sharkdp/fd), a much faster and friendlier alternative to the antiquated `find` command and is used for the find file functionality.

If you are on Mac, I recommend installing these two CLI tools using [brew](https://brew.sh/).
