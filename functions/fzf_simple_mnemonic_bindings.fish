function fzf_simple_mnemonic_bindings --description "Set up key bindings for are mnemonic and are unlikely to override other key bindings."
    # \e = alt, \c = control
    fzf_install_bindings \e\cf \e\cl \cs \cr \cv
end
