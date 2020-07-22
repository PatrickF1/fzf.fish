# Set up some default keybindings if user has not chosen to customize them
if not set --query fzf_fish_custom_keybindings
    # \cf is ctrl+f, etc.
    bind \cf '__fzf_search_current_dir'
    bind \cl '__fzf_search_git_log'
    bind \cr '__fzf_search_history'
    bind \cv '__fzf_search_shell_variables'
end

# fzf automatically looks for the FZF_DEFAULT_OPTS environment variable and if it is set, its value
# is automatically passed into every invocation of fzf.
# See https://github.com/junegunn/fzf#environment-variables
# If FZF_DEFAULT_OPTS is not set, then set some sane defaults. This also affects fzf outside this plugin.
if not set --query FZF_DEFAULT_OPTS
    set -g FZF_DEFAULT_OPTS '--cycle --reverse --border --height 75%'
end
