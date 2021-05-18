function fzf_simple_mnemonic_bindings --description "Install key bindings that are simple and mnemonic but may override existing key bindings."
    # \c = control
    fzf_install_bindings \
        --dir=\cf \
        --git_log=\cl \
        --git_status=\cs \
        --command_history=\cr \
        --shell_vars=\cv \
        $argv
end
