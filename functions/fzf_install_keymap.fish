# Supports overriding bindings set by pre-configured keymaps with appended user-specified bindings
# Always installs bindings for insert mode since for simplicity and b/c it has almost no side-effect
# https://gitter.im/fish-shell/fish-shell?at=60a55915ee77a74d685fa6b1
function fzf_install_keymap --description "Install a set of key bindings for fzf.fish's functions using the specified key sequences."
    if test (count $argv) -eq 0
        _fzf_install_keymap_help
        return
    end

    set options_spec h/help directory= git_log= git_status= history= variables=
    argparse --max-args=0 --ignore-unknown $options_spec -- $argv 2>/dev/null
    if test $status -ne 0
        _fzf_install_keymap_help
        return 22
    else if set --query _flag_h
        _fzf_install_keymap_help
        return
    end

    # If another keymap already exists, uninstall it first for a clean slate
    if functions --query _fzf_uninstall_keymap
        _fzf_uninstall_keymap
    end

    # When no key sequence is provided to bind, it gives an error.
    # Since this is expected for partial keymnaps, we ignore the stderr from these bind commands.
    for mode in default insert
        bind --mode $mode $_flag_directory __fzf_search_current_dir
        bind --mode $mode $_flag_git_log __fzf_search_git_log
        bind --mode $mode $_flag_git_status __fzf_search_git_status
        bind --mode $mode $_flag_history __fzf_search_history
        bind --mode $mode $_flag_variables $_fzf_search_vars_command
    end 2>/dev/null

    function _fzf_uninstall_keymap \
        --inherit-variable _flag_directory \
        --inherit-variable _flag_git_log \
        --inherit-variable _flag_git_status \
        --inherit-variable _flag_history \
        --inherit-variable _flag_variables

        bind --erase $_flag_directory $_flag_git_log $_flag_git_status $_flag_history $_flag_variables
        bind --erase --mode insert $_flag_directory $_flag_git_log $_flag_git_status $_flag_history $_flag_variables
    end
end
