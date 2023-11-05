function _fzf_search_history --description "Search command history. Replace the command line with the selected command."
    # history merge incorporates history changes from other fish sessions
    # it errors out if called in private mode
    if test -z "$fish_private_mode"
        builtin history merge
    end

    if not set --query fzf_history_time_format
        # Reference https://devhints.io/strftime to understand strftime format symbols
        set -f fzf_history_time_format "%m-%d %H:%M:%S"
    end

    # Delinate time from command in history entries using the vertical box drawing char (U+2502).
    # Then, to get raw command from history entries, delete everything up to it. The ? on regex is
    # necessary to make regex non-greedy so it won't match into commands containing the char.
    set -f time_prefix_regex '^.*? │ '
    # Delinate commands throughout pipeline using null rather than newlines because commands can be multi-line
    set -f commands_selected (
        builtin history --null --show-time="$fzf_history_time_format │ " |
        _fzf_wrapper --read0 \
            --print0 \
            --multi \
            --scheme=history \
            --prompt="Search History> " \
            --query=(commandline) \
            --preview="string replace --regex $time_prefix_regex '' {} | fish_indent --ansi" \
            --preview-window="bottom:3:wrap" \
            $fzf_history_opts |
        string split0 |
        # remove timestamps from commands selected
        string replace --regex $time_prefix_regex ''
    )

    if test $status -eq 0
        commandline --replace -- $commands_selected
    end

    commandline --function repaint
end
