# Always installs bindings for insert mode since for simplicity and b/c it has almost no side-effect
# https://gitter.im/fish-shell/fish-shell?at=60a55915ee77a74d685fa6b1
function fzf_configure_bindings --description "Installs the default key bindings for fzf.fish with user overrides passed as options."
    set options_spec h/help 'directory=?' 'git_log=?' 'git_status=?' 'history=?' 'variables=?'
    argparse --max-args=0 --ignore-unknown $options_spec -- $argv
    if test $status -ne 0
        echo "Invalid option or a positional argument was provided." 1>&2
        _fzf_configure_bindings_help
        return 22
    else if set --query _flag_help
        _fzf_configure_bindings_help
        return
    else
        # plan: store key sequences used as U var, use U var to erase on uninstall
        set key_sequences \e\cf \e\cl \cs \cr \cv
        set --query _flag_directory && set key_sequences[1] "$_flag_directory"
        set --query _flag_git_log && set key_sequences[2] "$_flag_git_log"
        set --query _flag_git_status && set key_sequences[3] "$_flag_git_status"
        set --query _flag_history && set key_sequences[4] "$_flag_history"
        set --query _flag_variables && set key_sequences[5] "$_flag_variables"

        # If fzf bindings already exists, uninstall it first for a clean slate
        if functions --query _fzf_uninstall_bindings
            _fzf_uninstall_bindings
        end

        for mode in default insert
            test -n $key_sequences[1] && bind --mode $mode $key_sequences[1] __fzf_search_current_dir
            test -n $key_sequences[2] && bind --mode $mode $key_sequences[2] __fzf_search_git_log
            test -n $key_sequences[3] && bind --mode $mode $key_sequences[3] __fzf_search_git_status
            test -n $key_sequences[4] && bind --mode $mode $key_sequences[4] __fzf_search_history
            test -n $key_sequences[5] && bind --mode $mode $key_sequences[5] $_fzf_search_vars_command
        end

        function _fzf_uninstall_bindings --inherit-variable key_sequences
            bind --erase -- $key_sequences
            bind --erase --mode insert -- $key_sequences
        end
    end
end
