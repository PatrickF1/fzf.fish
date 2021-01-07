function __fzf_search_shell_variables --argument-names variable_file --description "Search and inspect shell variables using fzf. Insert the selected variable into the commandline at the cursor."
    # Make sure that fzf uses fish to execute the preview function, which uses
    # fish's built-in string function which doesn't exist in other shells.
    # Using --local so that it does not clobber SHELL outside of this function.
    set --local --export SHELL (command --search fish)

    # Pipe the names of all shell variables to fzf and display the value of the selected
    # variable in fzf's preview window.
    # We use the current token to pre-populate fzf's query. If the current token begins
    # with a $, we remove it from the query so that it will better match the variable names
    # and we put it back later when replacing the current token with the user's selection.
    set variable_name (
        string collect $argv[2..-1] |
        fzf --preview "string match   --regex '^\\\${}(?::|\[).+' <$variable_file |
                       string replace --regex '^\\\${}(?:: (.+)|(\[.+\]): \|(.+)\|)' '\\\$1\\\$2 \\\$3'" \
            --query=(commandline --current-token | string replace '$' '')
    )

    if test $status -eq 0
        # If the current token begins with a $, do not overwrite the $ when 
        # replacing the current token with the selected variable.
        if string match --quiet '$*' (commandline --current-token)
            commandline --current-token --replace \$$variable_name
        else
            commandline --current-token --replace $variable_name
        end
    end

    commandline --function repaint
end
