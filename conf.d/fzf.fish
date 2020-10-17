# Set up the default, mnemonic key bindings unless the user has chosen to customize them
if not set --query fzf_fish_custom_keybindings
    # \cf is Ctrl+f
    bind \cf '__fzf_search_current_dir'
    bind \cr '__fzf_search_history'
    bind \cv '__fzf_search_shell_variables'
    # The following two key binding use Alt as an additional modifier key to avoid conflicts
    bind \e\cl '__fzf_search_git_log'
    bind \e\cs '__fzf_search_git_status'

    # set up the same key bindings for insert mode if using fish_vi_key_bindings
    if test "$fish_key_bindings" = 'fish_vi_key_bindings'
        bind --mode insert \cf '__fzf_search_current_dir'
        bind --mode insert \cr '__fzf_search_history'
        bind --mode insert \cv '__fzf_search_shell_variables'
        bind --mode insert \e\cl '__fzf_search_git_log'
        bind --mode insert \e\cs '__fzf_search_git_status'
    end
end

# If FZF_DEFAULT_OPTS is not set, then set some sane defaults. This also affects fzf outside of this plugin.
# See https://github.com/junegunn/fzf#environment-variables
if not set --query FZF_DEFAULT_OPTS
    # cycle allows jumping between the top and bottom most results, making scrolling easier
    # reverse layout lists results from top to bottom, which is more familiar as it mimicks the layout of git log, history, and env
    # border makes clear where the fzf window ends
    # height 90% leaves space to see the command line and some terminal scrollback, maintaining context of work
    # preview-window wrap wraps long lines in the preview window, making reading easier
    set --export FZF_DEFAULT_OPTS '--cycle --layout=reverse --border --height 90% --preview-window=wrap'
end
