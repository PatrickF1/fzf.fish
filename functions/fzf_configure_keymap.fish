# Supports overriding keymaps with appended user-specified bindings
# Always installs bindings for insert mode since for simplicity and b/c it has almost no side-effect
# https://gitter.im/fish-shell/fish-shell?at=60a55915ee77a74d685fa6b1
function fzf_configure_keymap --argument-names keymap --description "Change the key bindings for fzf.fish to the specified key sequences."
    set --local directory
    set --local git_log
    set --local git_status
    set --local history_ # append _ because history is a special variable
    set --local variables
    switch $keymap
        case conflictless_mnemonic
            set directory \e\cf
            set git_log \e\cl
            set git_status \cs
            set history_ \cr
            set variables \cv
        case simple_mnemonic
            set directory \cf
            set git_log \cl
            set git_status \cs
            set history_ \cr
            set variables \cv
        case simple_conflictless
            set directory \co
            set git_log \cl
            set git_status \cg
            set history_ \er
            set variables \ex
        case blank
        case '*'
            _fzf_configure_keymap_help
            return 22
    end

    _fzf_configure_keymap_parse_opts $argv[2..]
    if test $status -eq 1
        _fzf_configure_keymap_help
        return 22
    else if test $status -eq 2
        _fzf_configure_keymap_help
        return
    end

    # If another keymap already exists, uninstall it first for a clean slate
    if functions --query _fzf_uninstall_keymap
        _fzf_uninstall_keymap
    end

    # When no key sequence is provided to bind, it gives an error.
    # Since this is expected for partial keymnaps, we ignore the stderr from these bind commands.
    for mode in default insert
        bind --mode $mode $directory __fzf_search_current_dir
        bind --mode $mode $git_log __fzf_search_git_log
        bind --mode $mode $git_status __fzf_search_git_status
        bind --mode $mode $history_ __fzf_search_history
        bind --mode $mode $variables $_fzf_search_vars_command
    end 2>/dev/null

    function _fzf_uninstall_keymap \
        --inherit-variable directory \
        --inherit-variable git_log \
        --inherit-variable git_status \
        --inherit-variable history_ \
        --inherit-variable variables

        bind --erase -- $directory $git_log $git_status $history_ $variables
        bind --erase --mode insert -- $directory $git_log $git_status $history_ $variables
    end
end
