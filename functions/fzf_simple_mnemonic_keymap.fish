function fzf_simple_mnemonic_bindings --description "Install key bindings that are simple and mnemonic but may override existing key bindings."
    # \c = control
    fzf_install_keymap \
        --directory=\cf \
        --git_log=\cl \
        --git_status=\cs \
        --history=\cr \
        --variables=\cv \
        $argv
end
