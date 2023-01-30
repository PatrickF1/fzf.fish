function _fzf_configure_bindings_help --description "Prints the help message for fzf_configure_bindings."
    echo "\
USAGE:
    fzf_configure_bindings [--COMMAND=[KEY_SEQUENCE]...]

DESCRIPTION
    fzf_configure_bindings installs key bindings for fzf.fish's commands and erases any bindings it
    previously installed. It installs bindings for both default and insert modes. fzf.fish executes
    it without options on fish startup to install the out-of-the-box key bindings.

    By default, commands are bound to a mnemonic key sequence, shown below. Each command's binding
    can be configured using a namesake corresponding option:
        COMMAND            |  DEFAULT KEY SEQUENCE         |  CORRESPONDING OPTION
        Search Directory   |  Ctrl+Alt+F (F for file)      |  --directory
        Search Git Log     |  Ctrl+Alt+L (L for log)       |  --git_log
        Search Git Status  |  Ctrl+Alt+S (S for status)    |  --git_status
        Search History     |  Ctrl+R     (R for reverse)   |  --history
        Search Processes   |  Ctrl+Alt+P (P for process)   |  --processes
        Search Variables   |  Ctrl+V     (V for variable)  |  --variables
        Search Units       |  Ctrl+Alt+U (U for units)     |  --units
    Override a command's binding by specifying its corresponding option with the desired key
    sequence. Disable a command's binding by specifying its corresponding option with no value.

    Because fzf_configure_bindings erases bindings it previously installed, it can be cleanly
    executed multiple times. Once the desired fzf_configure_bindings command has been found, add it
    to your config.fish in order to persist the customized bindings.

    In terms of validation, fzf_configure_bindings fails if passed unknown options. It expects an
    equals sign between an option's name and value. However, it does not validate key sequences.

    Pass -h or --help to print this help message and exit.

EXAMPLES
    Default bindings but bind Search Directory to Ctrl+F and Search Variables to Ctrl+Alt+V
        \$ fzf_configure_bindings --directory=\cf --variables=\e\cv
    Default bindings but disable Search History
        \$ fzf_configure_bindings --history=
    An agglomeration of different options
        \$ fzf_configure_bindings --git_status=\cg --history=\ch --variables= --processes=

SEE Also
    To learn more about fish key bindings, see bind(1) and fish_key_reader(1).
"
end
