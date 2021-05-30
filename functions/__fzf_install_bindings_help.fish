function __fzf_install_bindings_help
    echo "fzf_install_bindings installs key bindings for fzf.fish."
    echo "Key bindings must be specified as long flags using the format --function=key_sequence."
    echo "Valid function values: dir, git_log, git_status, command_history, shell_var."
    echo "Try fish_key_reader to generate key sequences."
    echo "You do not have to specify key bindings for all functions. However, you must specify at least one key binding."
    echo "Fail if non-flags or unknown flags are provided."
    echo "Use -h or --help to print this help message."
end
