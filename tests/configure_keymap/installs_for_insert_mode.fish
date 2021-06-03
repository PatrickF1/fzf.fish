# fzf_configure_keymap conflictless_mnemonic already invocked fzf.fish was sourced on shell startup
bind --mode insert \e\cf >/dev/null && bind --mode insert \cv >/dev/null
@test "installs insert mode bindings" $status -eq 0
