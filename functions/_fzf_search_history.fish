# originally implemented and transposed from https://github.com/patrickf3139/dotfiles/pull/11
function _fzf_search_history --description "Search command history using fzf. Replace the commandline with the selected command."
    # history merge incorporates history changes from other fish sessions
    history merge
    set command_with_ts (
        # Reference https://devhints.io/strftime to understand strftime format symbols
        history --null --show-time="%m/%e %H:%M:%S | " |
        fzf --read0 --tiebreak=index --query=(commandline)
    )

    if test $status -eq 0
        set command_selected (string split --max 1 " | " $command_with_ts)[2]
        commandline --replace $command_selected
    end

    commandline --function repaint
end
