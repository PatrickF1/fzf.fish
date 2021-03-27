# helper function for __fzf_search_shell_variables
function __fzf_extract_var_info --argument-names variable_name set_show_output --description "Extract and reformat lines pertaining to \$variable_name from \$set_show_output."
    # Extract only the lines about the variable, all of which begin with
    # $variable_name: or $variable_name[
    string match --regex "^\\\$$variable_name(?::|\[).*" <$set_show_output |

        # Strip the variable name from the scope info, replacing...
        #   $variable_name: set in global scope
        # ...with...
        #   set in global scope
        string replace --regex "^\\\$$variable_name: " '' |

        # From the lines of values, keep only the index and value, replacing...
        #   $variable_name[1]: |value|
        # ...with...
        #   [1] value
        string replace --regex "^\\\$$variable_name(\[\d+\]): \|(.+)\|" '\$1 \$2'
end
