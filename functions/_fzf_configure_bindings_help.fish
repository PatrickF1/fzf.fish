function _fzf_configure_bindings_help --description "Prints the help message for fzf_configure_bindings."
    echo "\
USAGE:
    fzf_configure_bindings [--FEATURE[=KEY_SEQUENCE]...]

DESCRIPTION
    By default, fzf_configure_bindings installs mnemonic key bindings for fzf.fish's features. Each
    feature's binding can be customized through a corresponding namesake option:
        FEATURE            |  MNEMONIC KEY SEQUENCE        |  CORRESPONDING OPTION
        Search directory   |  Ctrl+Alt+F (F for file)      |  --directory
        Search git log     |  Ctrl+Alt+L (L for log)       |  --git_log
        Search git status  |  Ctrl+Alt+S (S for status)    |  --git_status
        Search history     |  Ctrl+R     (R for reverse)   |  --history
        Search variables   |  Ctrl+V     (V for variable)  |  --variables
        Search processes   |  Ctrl+O     (O for prOcess)   |  --processes
    An option with a key sequence value overrides the binding for its feature, while an option
    without a value disables the binding. A feature that is not customized retains its default
    menomonic binding specified above. Key bindings are installed for default and insert modes.

    In terms of validation, fzf_configure_bindings fails if passed unknown options. Furthermore, it
    expects an equals sign between an option's name and value. However, it does not validate key
    sequences. Rather, consider using fish_key_reader to manually validate them.

    In terms of experimentation, fzf_configure_bindings erases any bindings it previously installed
    before installing new ones so it can be repeatedly executed in the same fish session without
    problem. Once the desired fzf_configure_bindings command has been found, add it to config.fish
    in order to persist the bindings.

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
    An agglomeration of all the options
        \$ fzf_configure_bindings --git_status=\cg --history=\ch --variables --directory --git_log
"
end
