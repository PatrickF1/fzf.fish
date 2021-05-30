# Expects all key bindings to passed using flags: --function_name=key_sequence
# Supports leaving some fzf search functions unbound
# Supports overriding bindings set by pre-configured keymaps with appended user-specified binding appended
function fzf_install_bindings --description "Install key bindings for fzf.fish's functions using the specified key sequences."
    if test (count $argv) -eq 0
        __fzf_install_bindings_help
        return
    end

    set options_spec h/help directory= git_log= git_status= history= variables=
    argparse --max-args=0 --ignore-unknown $options_spec -- $argv 2>/dev/null
    if test $status -ne 0
        __fzf_install_bindings_help
        return 22
    else if set --query _flag_h
        __fzf_install_bindings_help
        return
    end

    # If another set of bindings already exists, uninstall it first for a clean slate
    if functions --query fzf_uninstall_bindings
        fzf_uninstall_bindings
    end

    bind $_flag_directory __fzf_search_current_dir 2>/dev/null
    bind $_flag_git_log __fzf_search_git_log 2>/dev/null
    bind $_flag_git_status __fzf_search_git_status 2>/dev/null
    bind $_flag_history __fzf_search_history 2>/dev/null
    bind $_flag_variables $__fzf_search_vars_command 2>/dev/null

    # set up the same key bindings for insert mode if using insert mode
    if contains insert (bind --list-modes)
        bind --mode insert $_flag_directory __fzf_search_current_dir 2>/dev/null
        bind --mode insert $_flag_git_log __fzf_search_git_log 2>/dev/null
        bind --mode insert $_flag_git_status __fzf_search_git_status 2>/dev/null
        bind --mode insert $_flag_history __fzf_search_history 2>/dev/null
        bind --mode insert $_flag_variables $__fzf_search_vars_command 2>/dev/null
    end

    function fzf_uninstall_bindings \
        --inherit-variable _flag_directory \
        --inherit-variable _flag_git_log \
        --inherit-variable _flag_git_status \
        --inherit-variable _flag_history \
        --inherit-variable _flag_variables

        bind --erase $_flag_directory $_flag_git_log $_flag_git_status $_flag_history $_flag_variables
        bind --erase --mode insert $_flag_directory $_flag_git_log $_flag_git_status $_flag_history $_flag_variables
    end
end
