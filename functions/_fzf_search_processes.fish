function _fzf_search_processes --description "Search all running processes. Replace the current token with the pid of the selected process."
    set fzf_arguments --multi --ansi $fzf_processes_opts
    set token (commandline --current-token)

    set process_selected (
        ps -A -opid,command | \
        _fzf_wrapper --query "$token" \
                     --header-lines=1 \
                     --preview='ps -o pid,user,%cpu,%mem,time,start,command -p {1}' \
                     $fzf_arguments
    )

    if test $status -eq 0
        set pid_selected (string split --no-empty " " $process_selected)[1]
        commandline --current-token --replace -- (string escape -- $pid_selected)
    end

    commandline --function repaint
end
