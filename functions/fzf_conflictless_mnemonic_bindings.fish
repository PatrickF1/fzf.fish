function fzf_conflictless_mnemonic_bindings --description "Install key bindings that are mnemonic and unlikely to override existing key bindings."
    # \e = alt, \c = control
    fzf_install_bindings \
        --directory=\e\cf \
        --git_log=\e\cl \
        --git_status=\cs \
        --history=\cr \
        --variables=\cv \
        $argv
end
