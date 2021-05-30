fzf_install_keymap --directory=\co
@test "installs the specified bindings" (bind | grep "\\\co") = "bind \co __fzf_search_current_dir"
