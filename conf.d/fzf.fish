# Set up the default, mnemonic keybindings unless the user has chosen to customize them
if not set --query fzf_fish_custom_keybindings
    # \cf is ctrl+f, etc.
    bind \cf '__fzf_search_current_dir'
    bind \cl '__fzf_search_git_log'
    bind \cr '__fzf_search_history'
    bind \cv '__fzf_search_shell_variables'

    # set up the same keybindings for insert mode if using fish_vi_key_bindings
    if [ $fish_key_bindings = 'fish_vi_key_bindings' ]
        bind --mode insert \cf '__fzf_search_current_dir'
        bind --mode insert \cl '__fzf_search_git_log'
        bind --mode insert \cr '__fzf_search_history'
        bind --mode insert \cv '__fzf_search_shell_variables'
    end
end

# If FZF_DEFAULT_OPTS is not set, then set some sane defaults. This also affects fzf outside of this plugin.
# See https://github.com/junegunn/fzf#environment-variables
if not set --query FZF_DEFAULT_OPTS
    # cycle makes scrolling easier
    # reverse layout is more familiar as it mimicks the layout of git log, history, and env
    # border makes clear where the fzf window ends
    # height 75% allows you to view what you were doing and stay in context of your work
    set --export FZF_DEFAULT_OPTS '--cycle --layout=reverse --border --height 75%'
end
