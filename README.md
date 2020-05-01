# fzf_fish_integration
`fisher` plugin to integrate `fzf` into your `fish` workflow. Adds keybindings to use `fzf` to
- obtain the relative path to a file under your current directory (`Ctrl+f`)
- select a command to run from command history (`Ctrl+r`)
- procure a shell variable name (`Ctrl+v`)

## Background
I originally included most of this functionality in [my dotfiles as autoloaded functions](https://github.com/patrickf3139/dotfiles/pull/11). Eventually, I decided it made more sense to keep the logic of complex utilities separate from my dotfiles, which should only be focused on the management of my configuration so moved it into its own repo. I also wanted to make this functionality more widely discoverable and available so made it a plugin.

I want to give credit to Jethro Kuan for some of the ideas implemented in his [fzf plugin](https://github.com/jethrokuan/fzf). You'll notice that his plugin also covers searching for files and searching through command history. Why not just use that plugin then? Well, I wanted something that is simpler and lighter, something easier to maintain and that leaves a small footprint on my shell environment while maintaining most of the functionality. I think I've achieved that here. But for more advanced use cases, Jethro's plugin may suit you better.

## Install
With [fisher](https://github.com/jorgebucaran/fisher)
```
fisher add patrickf3139/fzf_fish_integration
```
With [Oh My Fish](https://github.com/oh-my-fish/oh-my-fish)
```fish
omf install https://github.com/patrickf3139/fzf_fish_integration
```

In addition to this plugin, you will also need to install [fd](https://github.com/sharkdp/fd), a much faster and easier to use alternative to the antiquated `find` command. `fd` is used for the find file functionality.
