function __fzf_search_shell_variables --description "Search and inspect shell variables using fzf. Insert the selected variable into the commandline at the cursor."
    # Make sure that fzf uses fish to execute __echo_value_or_print_message, which
    # is an autoloaded fish function so doesn't exist in other shells.
    # Using --local so that it does not clobber SHELL outside of this function.
    set --local --export SHELL (command --search fish)

    # Pipe the names of all shell variables to fzf and attempt to display the value
    # of the selected variable in fzf's preview window.
    # Using string match to filter variables.
    # Using string repalace to simplify output.
    set variable_name (
        set --names |
        fzf --preview "cat "(set --show | psub)" | \
                       string match   --regex '^\\\${}(?::|\[).+' | \
                       string replace --regex '^\\\${}(?:: (.+)|(\[.+\]): \|(.+)\|)' '\\\$1\\\$2 \\\$3'"
    )

    if test $status -eq 0
        commandline --insert $variable_name
    end

    commandline --function repaint
end
