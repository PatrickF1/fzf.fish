function __fzf_search_shell_variables --description "Search and inspect shell variables using fzf. Insert the selected variable into the commandline at the cursor."
    # Make sure that fzf uses fish to execute __echo_value_or_print_message, which
    # is an autoloaded fish function so doesn't exist in other shells.
    # Using --local so that it does not clobber SHELL outside of this function.
    set --local --export SHELL (which fish)

    # Pipe the names of all shell variables to fzf and attempt to display the value
    # of the selected variable in fzf's preview window.
    # Non-exported variables will not be accessible to the fzf process, in which case
    # __echo_value_or_print_message will print an informative message in lieu of the value.
    set variable_name (
        set --names |
        fzf --preview '__echo_value_or_print_message {}' --preview-window wrap
    )

    if test $status -eq 0
        commandline --insert $variable_name
    end

    commandline --function repaint
end
