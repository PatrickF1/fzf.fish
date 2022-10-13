function _fzf_configure_bindings_help --description "Prints the help message for fzf_configure_bindings."
    echo "\
USAGE:
    fzf_configure_bindings [--FEATURE[=KEY_SEQUENCE]...]

DESCRIPTION
    fzf_configure_bindings installs key bindings for fzf.fish's features and erases any bindings it
    previously installed. It installs bindings for both default and insert modes.

    On execution, fzf_configure_bindings binds each feature to its default mnemonic key sequence
    shown below. If a feature's default binding is undesirable, it can be configured using its
    namesake corresponding option:
        FEATURE            |  DEFAULT KEY SEQUENCE         |  CORRESPONDING OPTION
        Search directory   |  Ctrl+Alt+F (F for file)      |  --directory
        Search git log     |  Ctrl+Alt+L (L for log)       |  --git_log
        Search git status  |  Ctrl+Alt+S (S for status)    |  --git_status
        Search history     |  Ctrl+R     (R for reverse)   |  --history
        Search variables   |  Ctrl+V     (V for variable)  |  --variables
        Search processes   |  Ctrl+Alt+P (P for process)   |  --processes
    Override a feature's binding by specifying its corresponding option with the desired key
    sequence. Disable a feature's binding by specifying its corresponding option with no value.

    Because fzf_configure_bindings erases bindings it previously installed before installing new
    ones, it can be cleanly executed multiple times. Once the desired fzf_configure_bindings command
    has been found, add it to config.fish in order to persist the bindings.

    In terms of validation, fzf_configure_bindings fails if passed unknown options. It expects an
    equals sign between an option's name and value. However, it does not validate key sequences.

    The -h and --help options print this help message.

EXAMPLES
    Install the default mnemonic bindings
        \$ fzf_configure_bindings
    Default bindings but override search directory to Ctrl+F and search variables to Ctrl+Alt+V
        \$ fzf_configure_bindings --directory=\cf --variables=\e\cv
    Default bindings but disable search history
        \$ fzf_configure_bindings --history=
    An agglomeration of different options
        \$ fzf_configure_bindings --git_status=\cg --history=\ch --variables= --processes=

SEE MORE
    To learn more about fish key bindings, see bind and fish_key_reader.
"
end
