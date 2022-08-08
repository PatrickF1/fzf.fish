function _fzf_search_history --description "Search command history. Replace the command line with the selected command."
    # history merge incorporates history changes from other fish sessions
    # it errors out if called in private mode
    if test -z "$fish_private_mode"
        builtin history merge
    end

    set commands_with_ts (
        # Delinate commands using null rather than newlines because commands can be multi-line
        # Reference https://devhints.io/strftime to understand strftime format symbols
        builtin history --null --show-time="%m-%d %H:%M:%S │ " |
        _fzf_wrapper --read0 \
            --print0 \
            --multi \
            --tiebreak=index \
            --query=(commandline) \
            # preview current command using fish_ident in a window at the bottom 3 lines tall
            --preview="echo -- {4..} | fish_indent --ansi" \
            --preview-window="bottom:3:wrap" \
            $fzf_history_opts |
        string split0
    )

    if test $status -eq 0
        set commands_selected
        # remove timestamps from commands before putting them into command line
        for c in $commands_with_ts
            set --append commands_selected (string split --max 1 " │ " $c)[2]
        end
        commandline --replace -- $commands_selected
    end

    commandline --function repaint
end
