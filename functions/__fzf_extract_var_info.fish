# A helper function for __fzf_search_shell_variables
function __fzf_extract_var_info --argument-names variable_name set_show_output --description "Extract the info for one variable from the output of set --show and simplify it."
    # Extract only the lines that begin with...
    # $variable_name: set
    # ...or...
    # $variable_name[
    string match --entire --regex "^\\\$$variable_name(?:: set|\[)" <$set_show_output |

    # Strip the variable name from the variable info, replacing...
    # $variable_name: set in global scope
    # ...with...
    # set in global scope
    string replace --regex "^\\\$$variable_name: " '' |

    # From the lines of values, keep only the index and value, replacing...
    # $variable_name[1]: length=14 value=|variable_value|
    # ...with...
    # [1] variable_value
    string replace --regex "^\\\$$variable_name(\[.+\]).+\|(.+)\|\$" '\$1 \$2'

    # Final output example for $PATH:
    # set in global scope, unexported, with 5 elements
    # [1] /Users/patrickf/.config/fish/functions
    # [2] /usr/local/Cellar/fish/3.1.2/etc/fish/functions
    # [3] /usr/local/Cellar/fish/3.1.2/share/fish/vendor_functions.d
    # [4] /usr/local/share/fish/vendor_functions.d
    # [5] /usr/local/Cellar/fish/3.1.2/share/fish/functions
end
