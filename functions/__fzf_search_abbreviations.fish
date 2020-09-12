function __fzf_search_abbreviations --description "Search and inspect abbreviations using fzf.
Insert the commands youre interested in into the commandline at the cursor."
    # Make sure that fzf uses fish to execute __echo_value_or_print_message, which
    # is an autoloaded fish function so doesn't exist in other shells.
    # Using --local so that it does not clobber SHELL outside of this function.
    set --local --export SHELL (which fish)

    # Pipe the names of all abreviations in your .config to fzf and attempt to display the value
    # of the selected abbr in fzf's preview window.
    set abbreviations (
           # this pipes the output of any file whose name matches with abbr inside of a dot config
           # folder for fish into bat  
           cat (fd abbr ~/.config/fish/) |
           fzf --preview '__fzf_display_value_or_error {}'
    )
    if test $status -eq 0
        commandline --insert $abbreviations
    end

    commandline --function repaint
end
