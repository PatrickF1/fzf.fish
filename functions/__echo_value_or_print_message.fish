# helper function for search shell variable functionality
function __echo_value_or_print_message --description "Echo the value of the variable passed in or a message that it is not available." --argument-names variable_name
    if set --query $variable_name
        echo $$variable_name
    else
        echo "----- $variable_name was not exported to this process so its value cannot be printed -----"
    end
end