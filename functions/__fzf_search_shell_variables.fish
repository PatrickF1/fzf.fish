function __fzf_search_shell_variables --description "Search and inspect shell variables using fzf. Insert the selected variable into the commandline at the cursor."
    # Pipe the names of all shell variables to fzf.
    # Attempt to display the value of the selected variable in fzf's preview window.
    # Non-exported variables will not be accessible to the fzf process, in which case
    # __echo_value_or_print_message will print an informative message in lieu of the value.
    set variable_name (
        set --names |
        fzf --height 70% --layout=reverse --preview '__echo_value_or_print_message {}'
    )

    if test $status -eq 0
        commandline --insert $variable_name
    end

    commandline --function repaint
end
