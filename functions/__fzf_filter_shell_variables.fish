# A helper function for __fzf_search_shell_variables
function __fzf_filter_shell_variables --argument-names variable_name set_show_output --description "Filter a list of variable values with a variable name."
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
end
