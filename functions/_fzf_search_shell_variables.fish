function _fzf_search_shell_variables -d "Search and inspect shell variables using fzf. Insert the selected variable into the commandline at the cursor."
    # Make sure that fzf uses fish to execute __echo_value_or_print_message, which
    # is an autoloaded fish function so doesn't exist in other shells.
    # Using --local so that it does not clobber SHELL outside of this function.
    set -lx SHELL (command --search fish)

    # Pipe the names of all shell variables to fzf and attempt to display the value
    # of the selected variable in fzf's preview window.
    # Non-exported variables will not be accessible to the fzf process, in which case
    # __echo_value_or_print_message will print an informative message in lieu of the value.
    if set -l variableName (set --names | fzf --preview '_fzf_display_value_or_error {}')
        commandline --insert $variableName
    end

    commandline --function repaint
end
