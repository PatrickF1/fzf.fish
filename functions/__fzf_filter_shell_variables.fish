function __fzf_filter_shell_variables --argument-names variable_name variable_values --description "Filter a list of variable values with a variable name."
    # The matches must begin with one of the following two conditions:
    # $variable_name: set
    # $variable_name[
    string match --entire --regex "^\\\$$variable_name(?:: set|\[)" <$variable_values |
    # Strip the variable name from the variable info, replacing...
    # $variable_name: set in global scope
    # ...with...
    # set in global scope
    string replace        --regex "^\\\$$variable_name: " '' |
    # Strip the variable name from the variable values, replacing...
    # $variable_name[1]: length=14 value=|variable_value|
    # ...with...
    # [1] variable_value
    string replace        --regex "^\\\$$variable_name(\[.+\]).+\|(.+)\|\$" '\$1 \$2'
end

