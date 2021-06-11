function _fzf_configure_bindings_help --description "Prints the help message for fzf_configure_bindings."
    echo "\
Usage:
    fzf_configure_bindings [--SEARCHABLE_ENTITY[=KEY_SEQUENCE]...]

Description:
    fzf_configure_bindings installs mnemonic key bindings for fzf.fish's features, each of which
    can be customized through a corresponding option:
        FEATURE            |  MNEMONIC KEY SEQUENCE        |  CORRESPONDING OPTION
        Search directory   |  Ctrl+Alt+F (F for file)      |  --directory
        Search git log     |  Ctrl+Alt+L (L for log)       |  --git_log
        Search git status  |  Ctrl+S     (S for status)    |  --git_status
        Search history     |  Ctrl+H     (H for history)   |  --history
        Search variables   |  Ctrl+V     (V for variable)  |  --variable
    An option with a key sequence value overrides the binding for its feature, while an option
    without a value disables the binding. Features that are not customized retain their default,
    menomonic binding specified above. fish_key_reader can help generate key sequences.
    Key bindings are always installed for both default and insert mode.

    fzf_configure_bindings fails and refuses to install new bindings if passed unknown options.
    However, it does not validate key sequences and installs them as is.

    fzf_configure_bindings erases any bindings it previously installed before installing new ones.
    This means users are free to repeatedly invoke this function in the same fish session to
    experiment with different bindings without having to worry about residual bindings.

    The -h and --help options print this help message.

Examples:
    Install the default, mnemonic bindings
        \$ fzf_configure_bindings
    Install the mnemonic bindings but override git log's binding
        \$ fzf_configure_bindings --git_log=\cg
    Install the mnemonic bindings but leave search history unbound
        \$ fzf_configure_bindings --history
"
end
