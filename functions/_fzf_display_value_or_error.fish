# helper function for _fzf_search_shell_variables
function _fzf_display_value_or_error -a varName -d "Displays either the value of the variable passed in, or an informative message if it is not available."
    if set --query $varName
        echo $$varName
    else
        set_color red
        echo "$varName was not exported to this process so its value cannot be displayed." >&2
        set_color normal
    end
end
