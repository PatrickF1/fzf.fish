# originally implemented and transposed from https://github.com/patrickf3139/dotfiles/pull/11
function _fzf_search_history -d "Search command history using fzf. Replace the commandline with the selected command."
    # history merge incorporates history changes from other fish sessions
    history merge

    # Reference https://devhints.io/strftime to understand strftime format symbols
    if set -l commandWithTs (history --show-time="%m/%e %H:%M:%S | " | fzf --tiebreak=index --query=(commandline))
        set -l commandSelected (string split --max 1 " | " $commandWithTs)[2]
        commandline --replace $commandSelected
    end

    commandline --function repaint
end
