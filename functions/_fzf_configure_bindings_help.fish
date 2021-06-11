function _fzf_configure_bindings_help --description "Prints the help message for fzf_configure_bindings."
    echo "\
USAGE:
    fzf_configure_bindings [--ENTITY[=KEY_SEQUENCE]...]

DESCRIPTION
    By default, fzf_configure_bindings installs mnemonic key bindings for fzf.fish's features. Each
    feature's binding can be customized through a corresponding namesake option:
        FEATURE            |  MNEMONIC KEY SEQUENCE        |  CORRESPONDING OPTION
        Search directory   |  Ctrl+Alt+F (F for file)      |  --directory
        Search git log     |  Ctrl+Alt+L (L for log)       |  --git_log
        Search git status  |  Ctrl+S     (S for status)    |  --git_status
        Search history     |  Ctrl+H     (H for history)   |  --history
        Search variables   |  Ctrl+V     (V for variable)  |  --variable
    An option with a key sequence value overrides the binding for its feature, while an option
    without a value disables the binding. Options and their values must be separated by an equal
    sign, not a space. Features that are not customized retain their default menomonic bindings
    specified above. Key bindings are always installed for default and insert modes. Use
    fish_key_reader to determine key sequences.

    fzf_configure_bindings fails and refuses to install bindings if passed unknown options.
    However, it does not validate key sequences.

    fzf_configure_bindings erases any bindings it previously installed before installing new ones.
    This means users may repeatedly invoke it in the same fish session without concern of residual
    bindings or other side effects.

    The -h and --help options print this help message.

EXAMPLES
    Install the default mnemonic bindings
        \$ fzf_configure_bindings
    Install the default bindings but override git log's binding to Ctrl+G
        \$ fzf_configure_bindings --git_log=\cg
    Install the default bindings but leave search history unbound
        \$ fzf_configure_bindings --history
    Alternative style of disabling search history
        \$ fzf_configure_bindings --history=
"
end
