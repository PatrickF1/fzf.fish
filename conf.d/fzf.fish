# Set up the default, mnemonic keybindings unless the user has chosen to customize them
if not set --query fzf_fish_custom_keybindings
    # \cf is ctrl+f, etc.
    bind \cf '__fzf_search_current_dir'
    bind \cl '__fzf_search_git_log'
    bind \cr '__fzf_search_history'
    bind \cv '__fzf_search_shell_variables'
end

# If FZF_DEFAULT_OPTS is not set, then set some sane defaults. This also affects fzf outside of this plugin.
# See https://github.com/junegunn/fzf#environment-variables
if not set --query FZF_DEFAULT_OPTS
    set --export FZF_DEFAULT_OPTS '--cycle --layout=reverse --border --height 75%'
end
