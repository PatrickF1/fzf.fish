# originally implemented and transposed from https://github.com/patrickf3139/dotfiles/pull/11
function __fzf_search_history --description "Search command history using fzf. Replace the commandline with the selected command."
    history merge
    set command_selected (
        history --null |
        fzf --read0 --tiebreak=index --height 40% --query=(commandline)
    )

    if test $status -eq 0
        commandline --replace $command_selected
    end

    commandline --function repaint
end
