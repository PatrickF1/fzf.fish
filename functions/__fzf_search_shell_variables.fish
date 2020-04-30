function __fzf_search_shell_variables --description "Search and inspect shell variables using fzf. Insert the selected variable into the commandline at the cursor."
    # list all the shell variables names, preview the value of the selected variable in fzf's preview window
    # if the variable has an empty value, notify the user that its value is empty or cannot be accessed
    set variable_name (
        set --names |
        fzf --height 40% --layout=reverse --preview '__echo_value_or_print_message {}'
    )

    if test $status -eq 0
        commandline --replace $variable_name
    end

    commandline --function repaint
end
