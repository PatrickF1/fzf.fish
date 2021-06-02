fzf_install_keymap --directory=\e\cp
fzf_simple_mnemonic_keymap
@test "new keymap should completely overwrite previous keymap" (bind \e\cp 2>/dev/null) $status -ne 0
