function fzf_install_bindings --argument-names dir git_log git_status command_history shell_vars --description "Install key bindings for fzf.fish's functions using the specified key sequences."
    set -l options_spec dir= git_log= git_status= command_history= shell_vars=
    argparse --max-args=0 $options_spec -- $argv
    or return

    # If another set of bindings already exists, uninstall it first for a clean slate
    if functions --query fzf_uninstall_bindings
        fzf_uninstall_bindings
    end

    bind $_flag_dir __fzf_search_current_dir

    bind $_flag_git_log __fzf_search_git_log
    bind $_flag_git_status __fzf_search_git_status
    bind $_flag_command_history __fzf_search_history
    bind $_flag_shell_vars $__fzf_search_vars_command

    # set up the same key bindings for insert mode if using insert mode
    if contains "$fish_key_bindings" fish_vi_key_bindings fish_hybrid_key_bindings
        bind --mode insert $_flag_dir __fzf_search_current_dir
        bind --mode insert $_flag_git_log __fzf_search_git_log
        bind --mode insert $_flag_git_status __fzf_search_git_status
        bind --mode insert $_flag_command_history __fzf_search_history
        bind --mode insert $_flag_shell_vars $__fzf_search_vars_command
    end

    # intentionally omitting __ so that the user can easily find it and use it when they
    # are debugging their key bindings
    # function fzf_uninstall_bindings \
    #     --inherit-variable _flag_dir \
    #     --inherit-variable _flag_git_log \
    #     --inherit-variable _flag_git_status \
    #     --inherit-variable _flag_command_history \
    #     --inherit-variable _flag_shell_vars

    #     bind --erase $_flag_dir $_flag_git_log $_flag_git_status $_flag_command_history $_flag_shell_vars
    # end
end
