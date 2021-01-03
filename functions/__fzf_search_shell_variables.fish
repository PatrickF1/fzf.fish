function __fzf_search_shell_variables --description "Search and inspect shell variables using fzf. Insert the selected variable into the commandline at the cursor."
    # Pipe the names of all shell variables to fzf and attempt to display the value
    # of the selected variable in fzf's preview window.
    # Using string match to filter variables.
    # Using string repalace to simplify output.
    set variable_name (
        set --names |
        fzf --preview "cat "(set --show | psub)" |
                       string match   --regex '^\\\${}(?::|\[).+' |
                       string replace --regex '^\\\${}(?:: (.+)|(\[.+\]): \|(.+)\|)' '\\\$1\\\$2 \\\$3';
                       or set_color red && echo \\\${} was not dumped so its value cannot be displayed. >&2 && set_color normal"
    )

    if test $status -eq 0
        commandline --insert $variable_name
    end

    commandline --function repaint
end
