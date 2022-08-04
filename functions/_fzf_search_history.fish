function _fzf_search_history --description "Search command history. Replace the command line with the selected command."
    # history merge incorporates history changes from other fish sessions
    # it errors out if called in private mode
    if test -z "$fish_private_mode"
        builtin history merge
    end

    set commands_with_ts (
        # Reference https://devhints.io/strftime to understand strftime format symbols
        builtin history --null --show-time="%m-%d %H:%M:%S │ " |
        _fzf_wrapper --read0 \
            --tiebreak=index \
            --query=(commandline) \
            # preview current command using fish_ident in a window at the bottom 3 lines tall
            --preview="echo -- {4..} | fish_indent --ansi" \
            --preview-window="bottom:3:wrap" \
            $fzf_history_opts |
        string collect
    )

    if test $status -eq 0
        set commands_selected # empty list to loop over selected commands, in case multiple
        for c in (string split \n $commands_with_ts)
            if string match -r --quiet '(\d\d-\d\d \d\d:\d\d:\d\d)' $c
                set --append commands_selected (string split --max 1 " │ " $c)[2]
            else
                set --append commands_selected $c
            end
        end
        commandline --replace -- $commands_selected
    end

    commandline --function repaint
end
