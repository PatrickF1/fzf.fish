# Supports overriding keymaps with appended user-specified bindings
# Always installs bindings for insert mode since for simplicity and b/c it has almost no side-effect
# https://gitter.im/fish-shell/fish-shell?at=60a55915ee77a74d685fa6b1
function fzf_configure_keymap --argument-names keymap_or_help --description "Change the key bindings for fzf.fish to the specified key sequences."
    set --local directory
    set --local git_log
    set --local git_status
    set --local history_ # append _ because history is a special variable
    set --local variables
    switch $keymap_or_help
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
        case -h --help
            _fzf_configure_keymap_help
            return
        case '*'
            echo "Invalid or missing keymap argument." 1>&2
            _fzf_configure_keymap_help
            return 22
    end

    set options_spec 'directory=?' 'git_log=?' 'git_status=?' 'history=?' 'variables=?'
    argparse --max-args=0 --ignore-unknown $options_spec -- $argv[2..] 2>/dev/null #argv[1] is the keymap
    if test $status -ne 0
        echo "Invalid option or more than one argument provided." 1>&2
        _fzf_configure_keymap_help
        return 22
    else
        set --query _flag_directory && set directory $_flag_directory
        set --query _flag_git_log && set git_log $_flag_git_log
        set --query _flag_git_status && set git_status $_flag_git_status
        set --query _flag_history && set history_ $_flag_history
        set --query _flag_variables && set variables $_flag_variables
    end

    # If another keymap already exists, uninstall it first for a clean slate
    if functions --query _fzf_uninstall_keymap
        _fzf_uninstall_keymap
    end

    # When no key sequence is provided to bind, it gives an error.
    # Since this is expected for partial keymnaps, we ignore the stderr from these bind commands.
    for mode in default insert
        test -n $directory && bind --mode $mode $directory __fzf_search_current_dir
        test -n $git_log && bind --mode $mode $git_log __fzf_search_git_log
        test -n $git_status && bind --mode $mode $git_status __fzf_search_git_status
        test -n $history_ && bind --mode $mode $history_ __fzf_search_history
        test -n $variables && bind --mode $mode $variables $_fzf_search_vars_command
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
