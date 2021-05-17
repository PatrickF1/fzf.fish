function fzf_install_bindings --argument-names dir git_log git_status command_history shell_vars --description "Install key bindings for fzf.fish's functions using the specified key sequences."
    # If another set of bindings already exists, uninstall it first for a clean slate
    if functions --query fzf_uninstall_bindings
        fzf_uninstall_bindings
    end

    bind $dir __fzf_search_current_dir
    bind $git_log __fzf_search_git_log
    bind $git_status __fzf_search_git_status
    bind $command_history __fzf_search_history
    bind $shell_vars $__fzf_search_vars_command

    # set up the same key bindings for insert mode if using insert mode
    if contains "$fish_key_bindings" fish_vi_key_bindings fish_hybrid_key_bindings
        bind --mode insert $dir __fzf_search_current_dir
        bind --mode insert $git_log __fzf_search_git_log
        bind --mode insert $git_status __fzf_search_git_status
        bind --mode insert $command_history __fzf_search_history
        bind --mode insert $shell_vars $__fzf_search_vars_command
    end

    # intentionally omitting __ so that the user can easily find it and use it when they
    # are debugging their key bindings
    function fzf_uninstall_bindings
        bind --erase $dir $git_log $git_status $command_history $shell_vars
    end
end
