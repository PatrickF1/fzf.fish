function _fzf_configure_bindings_help --description "Prints the help message for fzf_configure_bindings."
    echo "\
USAGE:
    fzf_configure_bindings [--FEATURE[=KEY_SEQUENCE]...]

DESCRIPTION
    By default, fzf_configure_bindings installs mnemonic key bindings for fzf.fish's features. Each
    feature's binding can be configured through a corresponding namesake option:
        FEATURE            |  MNEMONIC KEY SEQUENCE        |  CORRESPONDING OPTION
        Search directory   |  Ctrl+Alt+F (F for file)      |  --directory
        Search git log     |  Ctrl+Alt+L (L for log)       |  --git_log
        Search git status  |  Ctrl+Alt+S (S for status)    |  --git_status
        Search history     |  Ctrl+R     (R for reverse)   |  --history
        Search variables   |  Ctrl+V     (V for variable)  |  --variables
        Search processes   |  Ctrl+Alt+P (P for process)   |  --processes
    Override a feature's binding by setting its corresponding option to the desired key sequence.
    Disable a feature's binding by setting its corresponding option to an empty value. A feature
    that is not configured retains its default menomonic binding specified above.
    fzf_configure_bindings will erase all bindings it previously installed before installing
    new ones so is safe to execute repeatedly in the same fish session. It installs bindings for
    both default and insert modes.

    In terms of validation, fzf_configure_bindings fails if passed unknown options. Furthermore, it
    expects an equals sign between an option's name and value. However, it does not validate key
    sequences. Rather, consider using fish_key_reader to manually validate them.

    Once the desired fzf_configure_bindings command has been found, add it to config.fish
    in order to persist the bindings.

    The -h and --help options print this help message.

EXAMPLES
    Install the default mnemonic bindings
        \$ fzf_configure_bindings
    Default bindings but override search directory to Ctrl+F and search variables to Ctrl+Alt+V
        \$ fzf_configure_bindings --directory=\cf --variables=\e\cv
    Default bindings with search history unbound
        \$ fzf_configure_bindings --history
    Alternative style of disabling search history
        \$ fzf_configure_bindings --history=
    An agglomeration of many options
        \$ fzf_configure_bindings --git_status=\cg --history=\ch --variables --processes
"
end
