function keymap_installed_successfully
    test (bind --user | string match --entire __fzf_ | count) -eq 10
end
fzf_configure_keymap simple_mnemonic && keymap_installed_successfully
@test "simple_mnemonic installs successfully" $status -eq 0

fzf_configure_keymap conflictless_mnemonic && keymap_installed_successfully
@test "conflictless_mnemonic installs successfully" $status -eq 0

fzf_configure_keymap simple_conflictless && keymap_installed_successfully
@test "simple_conflictless installs successfully" $status -eq 0

fzf_configure_keymap --directory=\co blank >/dev/null
@test "fails if the first arugment is not a keymap" $status -ne 0

fzf_configure_keymap blank simple_mnemonic &>/dev/null
@test "fails if there are two keymaps specified" $status -ne 0

fzf_configure_keymap typo >/dev/null
@test "fails if given an invalid keymap" $status -ne 0
