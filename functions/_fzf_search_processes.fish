function _fzf_search_processes --description "Search all running processes. Replace the current token with the pid of the selected process."
    set processes_selected (
        ps -A -opid,command | \
        _fzf_wrapper --multi \
                     --query (commandline --current-token) \
                     --ansi \
                     # first line outputted by ps is "PID COMMAND", so we need to mark that as the header
                     --header-lines=1 \
                     --preview='ps -o pid,user,ppid,%cpu,rss,time,start,command -p {1}' \
                     $fzf_processes_opts
    )

    if test $status -eq 0
        for process in $processes_selected
            set --append pids_selected (string split --no-empty --field=1 -- " " $process)
        end

        # string join to replace the newlines outputted by string split with spaces
        commandline --current-token --replace -- (string join ' ' $pids_selected)
    end

    commandline --function repaint
end
