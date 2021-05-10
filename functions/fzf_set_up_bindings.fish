function fzf_set_up_bindings -a dir git_log git_status command_history shell_vars -d "Set up key bindings for all of fzf.fish's functions using the specific key sequences."
    # Because of scoping rules, to capture the shell variables exactly as they are, we must read
    # them before even executing __fzf_search_shell_variables. We use psub to store the
    # variables' info in temporary files and pass in the filenames as arguments.
    set --local fzf_search_vars_cmd '__fzf_search_shell_variables (set --show | psub) (set --names | psub)'

    bind $dir __fzf_search_dir
    bind $git_log __fzf_search_git_log
    bind $git_status __fzf_search_git_status
    bind $command_history __fzf_search_history
    bind $shell_vars $fzf_search_vars_cmd

    # set up the same key bindings for insert mode if using insert mode
    if contains "$fish_key_bindings" fish_vi_key_bindings fish_hybrid_key_bindings
        bind --mode insert $dir __fzf_search_current_dir
        bind --mode insert $git_log __fzf_search_git_log
        bind --mode insert $git_status __fzf_search_git_status
        bind --mode insert $command_history __fzf_search_history
        bind --mode insert $shell_vars $fzf_search_vars_cmd
    end
end
