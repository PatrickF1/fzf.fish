# helper function for __fzf_search_shell_variables
function __fzf_extract_var_info --argument-names variable_name set_show_output --description "Extract and reformat lines pertaining to \$variable_name from \$set_show_output."
    # Extract only the lines about the variable, all of which begin with either
    # $variable_name: ...or... $variable_name[
    string match --regex "^\\\$$variable_name(?::|\[).*" <$set_show_output |

        # Strip the variable name prefix, including ": " for scope info lines
        string replace --regex "^\\\$$variable_name(?:: )?" '' |

        # Distill the lines of values, replacing...
        #   [1]: |value|
        # ...with...
        #   [1] value
        string replace --regex ": \|(.*)\|" ' \$1'
end
