function __fzf_search_shell_variables --description "Search shell variables using fzf. Insert the selected variable into the commandline at the cursor."
    set variable_name (
        set --names |
        fzf --height 40% --preview 'set shell_variable_name {}; echo $$shell_variable_name'
    )

    if test $status -eq 0
        commandline --replace $variable[1]
    end

    commandline --function repaint
end
