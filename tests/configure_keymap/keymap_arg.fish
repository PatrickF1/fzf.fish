# append _ to history b/c history is a special variable
function keymap_installed_successfully -a directory git_log git_status history_ variables
    begin
        bind $directory | string match --entire __fzf_search_current_dir &&
            bind $git_log | string match --entire __fzf_search_git_log &&
            bind $git_status | string match --entire __fzf_search_git_status &&
            bind $history_ | string match --entire __fzf_search_history &&
            bind $variables | string match --entire "$_fzf_search_vars_command"
    end >/dev/null
end

# success cases
fzf_configure_keymap conflictless_mnemonic && keymap_installed_successfully \e\cf \e\cl \cs \cr \cv
@test "conflictless_mnemonic installs successfully" $status -eq 0

fzf_configure_keymap simple_mnemonic && keymap_installed_successfully \cf \cl \cs \cr \cv
@test "simple_mnemonic installs successfully" $status -eq 0

fzf_configure_keymap simple_conflictless && keymap_installed_successfully \co \cl \cg \er \ex
@test "simple_conflictless installs successfully" $status -eq 0

fzf_configure_keymap blank
@test "blank installs no key bindings" -z (bind --user | string match --entire __fzf_)

# failure cases
fzf_configure_keymap --directory=\co blank &>/dev/null
@test "fails if the first arugment is not a keymap" $status -ne 0

fzf_configure_keymap blank simple_mnemonic &>/dev/null
@test "fails if there are two keymaps specified" $status -ne 0

fzf_configure_keymap typo &>/dev/null
@test "fails if given an invalid keymap" $status -ne 0
