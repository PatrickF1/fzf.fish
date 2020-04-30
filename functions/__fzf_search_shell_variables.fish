function __fzf_search_shell_variables --description "Search shell variables using fzf. Insert the selected variable into the commandline at the cursor."
    set variable_and_value (set | fzf --height 40%)

    if test $status -eq 0
        commandline --replace $variable_and_value[1] # insert only the variable name and exclude the value
    end

    commandline --function repaint
end
