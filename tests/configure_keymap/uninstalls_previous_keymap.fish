# current keymap, before the below line is executed, is conflictless_mnemonic
fzf_configure_keymap conflictless_mnemonic --directory=\eR --git_log=\eL
@test "new keymap should completely overwrite previous keymap" (bind \e\cf 2>\dev\null; or bind \e\cl 2>/dev/null) $status -ne 0
fzf_configure_keymap blank
@test "new keymap should completely overwrite previous keymap's custom bindings" (bind \eR 2>\dev\null; or bind \eL 2>/dev/null) $status -ne 0
