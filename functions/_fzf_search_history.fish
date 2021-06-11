function _fzf_search_history --description "Search command history. Replace the command line with the selected command."
    # history merge incorporates history changes from other fish sessions
    builtin history merge

    # Make sure that fzf uses fish so we can run fish_indent.
    # See similar comment in _fzf_search_variables.fish.
    set --local --export SHELL (command --search fish)

    set command_with_ts (
        # Reference https://devhints.io/strftime to understand strftime format symbols
        builtin history --null --show-time="%m-%d %H:%M:%S │ " |
        fzf --read0 \
            --tiebreak=index \
            --query=(commandline) \
            # preview current command using fish_ident in a window at the bottom 3 lines tall
            --preview="echo -- {4..} | fish_indent --ansi" \
            --preview-window="bottom:3:wrap" \
            $fzf_history_opts |
        string collect
    )

    if test $status -eq 0
        set command_selected (string split --max 1 " │ " $command_with_ts)[2]
        commandline --replace -- $command_selected
    end

    commandline --function repaint
end
