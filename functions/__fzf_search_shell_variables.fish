# This function expects the following two arguments:
# argument 1 = output of (set --show | psub), i.e. a file with the scope info and values of all variables
# argument 2 = output of (set --names | psub), i.e. a file with all variable names
function __fzf_search_shell_variables --argument-names set_show_output set_names_output --description "Search and preview shell variables. Replace the current token with the selected variable."
    if test -z "$set_names_output"
        printf '%s\n' '__fzf_search_shell_variables requires 2 arguments.' >&2

        commandline --function repaint
        return 22 # 22 means invalid argument in POSIX
    end

    # Make sure that fzf uses fish to execute __fzf_extract_var_info, which
    # is an autoloaded fish function so doesn't exist in other shells.
    # Use --local so that it does not clobber SHELL outside of this function.
    set --local --export SHELL (command --search fish)

    # Exclude the history variable from being piped into fzf because
    # 1. it's not included in $set_names_output
    # 2. it tends to be a very large value => increases computation time
    # 3.__fzf_search_history is a much better way to examine history anyway
    set all_variable_names (string match --invert history <$set_names_output)

    set current_token (commandline --current-token)
    # Use the current token to pre-populate fzf's query. If the current token begins
    # with a $, remove it from the query so that it will better match the variable names
    set cleaned_curr_token (string replace -- '$' '' $current_token)

    set variable_names_selected (
        printf '%s\n' $all_variable_names |
        fzf --preview "__fzf_extract_var_info {} $set_show_output" \
            --multi \
            --query=$cleaned_curr_token \
            $fzf_shell_vars_opts
    )

    if test $status -eq 0
        # If the current token begins with a $, do not overwrite the $ when
        # replacing the current token with the selected variable.
        # Uses brace expansion to prepend $ to each variable name.
        commandline --current-token --replace (
            if string match --quiet -- '$*' $current_token
                string join " " \${$variable_names_selected}
            else
                string join " " $variable_names_selected
            end
        )
    end

    commandline --function repaint
end
