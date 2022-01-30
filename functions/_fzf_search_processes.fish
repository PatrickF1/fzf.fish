function _fzf_search_processes --description "Search all running processes. Replace the current token with the pid of the selected process."
    set token (commandline --current-token)

    set processes_selected (
        ps -A -opid,command | \
        _fzf_wrapper --multi \
                     --query "$token" \
                     --ansi \
                     --header-lines=1 \
                     --preview='ps -o pid,user,ppid,%cpu,rss,time,start,command -p {1}' \
                     $fzf_processes_opts
    )

    if test $status -eq 0
        for process in $processes_selected
            set --append pids_selected (string split --no-empty -- " " $process)[1]
        end

        commandline --current-token --replace -- $pids_selected
    end

    commandline --function repaint
end
