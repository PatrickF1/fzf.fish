# fzf_fish_integration
`fisher` plugin to integrate fzf into fish workflow. Heavily inspired by Jethro Kuan's similar [fzf plugin](https://github.com/jethrokuan/fzf).

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

## Usage
- To obtain the relative path to a file under your current directory, hit `Ctrl+f`.
- To select a command to run from your command history, hit `Ctrl+r`.
