function __fzf_search_shell_variables --argument-names variable_names variable_values --description "Search and inspect shell variables using fzf. Insert the selected variable into the commandline at the cursor."
    if test -z "$variable_names"
        set_color red
        printf "\nThe signature of __fzf_search_shell_variables was changed in https://github.com/PatrickF1/fzf.fish/pull/71.\nPlease see the latest conf.d/fzf.fish and update your key bindings.\n\n"
        set_color normal

        commandline --function repaint
        return
    end

    # Make sure that fzf uses fish to execute the preview function, which uses
    # fish's built-in string function which doesn't exist in other shells.
    # Using --local so that it does not clobber SHELL outside of this function.
    set --local --export SHELL (command --search fish)

    # Exclude the history variable name from being piped into fzf because it's not included in
    # $variable_file (the output of set --show). It's also not worth showing anyway as
    # __fzf_search_history is a much better way to examine history.
    # We use the current token to pre-populate fzf's query. If the current token begins
    # with a $, we remove it from the query so that it will better match the variable names
    # and we put it back later when replacing the current token with the user's selection.
    set variable_name (
        string match --invert history <$variable_names |
        fzf --preview "__fzf_filter_shell_variables {} $variable_values" \
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
