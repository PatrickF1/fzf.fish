function __fzf_search_shell_variables --description "Search shell variables using fzf. Insert the selected variable into the commandline at the cursor."
    # list all the shell variables names, preview the value of the selected variable in fzf's preview window
    set variable_name (
        set --names |
        fzf --height 40% --layout=reverse --preview 'set shell_variable_name {}; and echo $$shell_variable_name'
    )

    if test $status -eq 0
        commandline --replace $variable_name
    end

    commandline --function repaint
end
