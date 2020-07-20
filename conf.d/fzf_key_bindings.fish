if not set -q FZF_FISH_CUSTOM_KEYBINDINGS
    # \cf is ctrl+f, etc.
    bind \cf '__fzf_search_current_dir'
    bind \cl '__fzf_search_git_log'
    bind \cr '__fzf_search_history'
    bind \cv '__fzf_search_shell_variables'
end
