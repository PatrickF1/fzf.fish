# helper function for __fzf_search_shell_variables
function __fzf_display_value_or_error --argument-names variable_name --description "Displays either the value of the variable passed in, or an informative message if it is not available."
    if set --query $variable_name
        set -S $variable_name | string replace -r "^\\\$$variable_name(: )?" ""
    else
        set_color red
        echo "$variable_name was not exported to this process so its value cannot be displayed." >&2
        set_color normal
    end
end
