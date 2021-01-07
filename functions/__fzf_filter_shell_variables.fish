function __fzf_filter_shell_variables --argument-names variable_name variable_values
    string match --entire --regex "^\\\$$variable_name(?:: set|\[)" <$variable_values |
    string replace        --regex "^\\\$$variable_name: " '' |
    string replace        --regex "^\\\$$variable_name(\[.+\]).+\|(.+)\|\$" '\$1 \$2'
end

