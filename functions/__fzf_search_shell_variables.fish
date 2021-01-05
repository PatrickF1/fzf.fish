function __fzf_search_shell_variables --description "Search and inspect shell variables using fzf. Insert the selected variable into the commandline at the cursor."
    # Make sure that fzf uses fish to execute __echo_value_or_print_message, which
    # is an autoloaded fish function so doesn't exist in other shells.
    # Using --local so that it does not clobber SHELL outside of this function.
    set --local --export SHELL (command --search fish)

    # Pipe the names of all shell variables to fzf and attempt to display the value
    # of the selected variable in fzf's preview window.
    # Non-exported variables will not be accessible to the fzf process, in which case
    # __echo_value_or_print_message will print an informative message in lieu of the value.
    # We use the current token to pre-populate fzf's search input. In case the user has typed
    # a $, we remove it so that the current token will more likely match the variable names
    # and we put it back later when replacing the current token with the user's selection.
    set variable_name (
        set --names |
        fzf --preview '__fzf_display_value_or_error {}' \
            --query=(commandline --current-token | string replace '$' '')
    )

    if test $status -eq 0
        # If the user initially typed a $ before using this function
        if string match -q '$*' (commandline --current-token)
            commandline --current-token --replace \$$variable_name
        else
            commandline --current-token --replace $variable_name
        end
    end

    commandline --function repaint
end
