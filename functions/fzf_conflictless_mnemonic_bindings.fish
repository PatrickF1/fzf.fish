function fzf_conflictless_mnemonic_bindings --description "Set up key bindings for fzf.fish that are mnemonic and unlikely to override existing key bindings."
    # \e = alt, \c = controlZZ
    fzf_install_bindings \e\cf \e\cl \cs \cr \cv
end
