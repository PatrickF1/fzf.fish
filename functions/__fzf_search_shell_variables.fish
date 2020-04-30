function __fzf_search_shell_variables --description "Search shell variables using fzf. Insert the selected variable into the commandline at the cursor."
    # list all the shell variables names, preview the value of the selected variable in fzf's preview window
    # if the variable has an empty value, notify the user that its value is empty or cannot be accessed
    # hack borrowed from https://unix.stackexchange.com/a/88682/246672
    set variable_name (
        set --names |
        fzf --height 40% --layout=reverse --preview 'set shell_var_name {}; and \
        set shell_var_value $$shell_var_name ">>> \$$shell_var_name is empty or it was not exported to fzf process so its value cannot be printed <<<"; and \
        echo $shell_var_value[1]'
    )

    if test $status -eq 0
        commandline --replace $variable_name
    end

    commandline --function repaint
end
