# helper function for __fzf_search_shell_variables
function __fzf_display_value_or_error --argument-names variable_name variable_file --description "Displays either the value of the variable passed in, or an informative message if it is not available."
    set matches (cat $variable_file | string match --regex "^\\\$$variable_name(?::|\[).+")

    if test -n "$matches"
        string replace --regex "^\\\$$variable_name(?:: (.+)|(\[.+\]): \|(.+)\|)" '\$1\$2 \$3' $matches
    else
        set_color red
        echo "$variable_name was not dumped so its value cannot be displayed." >&2
        set_color normal
    end
end
