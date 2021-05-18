fzf_install_bindings \e\cp \e\cp \e\cp \e\cp \e\cp \e\cp
fzf_simple_mnemonic_bindings
# now that a new set of bindings is installed, check for vestiges of the previous bindings, fzf_simple_mnemonic_bindings
@test "new bindings should erase previous bindings" -z (bind | grep "\e\cp")
