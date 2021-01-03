function __fzf_search_shell_variables --description "Search and inspect shell variables using fzf. Insert the selected variable into the commandline at the cursor."
    # Pipe the names of all shell variables to fzf and attempt to display the value
    # of the selected variable in fzf's preview window.
    # Non-dumped variables will not be accessible to the fzf process, in which case
    # __fzf_display_value_or_error will print an informative message in lieu of the value.
    # Make sure that fzf uses fish to execute __fzf_display_value_or_error, which
    # is an autoloaded fish function so doesn't exist in other shells.
    set variable_name (
        set --names |
        SHELL=$__fish_bin_dir/fish fzf --preview '__fzf_display_value_or_error {} '(set --show | psub)
    )

    if test $status -eq 0
        commandline --insert $variable_name
    end

    commandline --function repaint
end
