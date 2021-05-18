function fzf_conflictless_mnemonic_bindings --description "Set up key bindings that are mnemonic and unlikely to override existing key bindings."
    # \e = alt, \c = control
    fzf_install_bindings \
        --dir=\e\cf \
        --git_log=\e\cl \
        --git_status=\cs \
        --command_history=\cr \
        --shell_vars=\cv \
        $argv
end
