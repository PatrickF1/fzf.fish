fzf_install_keymap --directory=\e\cp
fzf_simple_mnemonic_keymap
@test "new keymap should completely overwrite previous keymap" -z (bind | grep "\e\cp")
