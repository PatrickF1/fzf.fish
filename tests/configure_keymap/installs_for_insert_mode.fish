# fzf_conflictless_mnemonic_keymap already when fzf.fish was sourced on shell startup
bind --mode insert \e\cf && bind --mode insert \cv >/dev/null
@test "installs insert mode bindings" $status -eq 0
