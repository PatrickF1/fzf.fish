function _fzf_search_processes --description "Search all running processes. Replace the current token with the pid of the selected process."
    # Prefer ps binary over ps alias
    set -f ps_cmd (command -v ps || echo "ps")
    # use all caps to be consistent with ps default format
    # snake_case because ps doesn't seem to allow spaces in the field names
    set -f ps_preview_fmt (string join ',' 'pid' 'ppid=PARENT' 'user' '%cpu' 'rss=RSS_IN_KB' 'start=START_TIME' 'command')
    set -f processes_selected (
        $ps_cmd -A -opid,command | \
        _fzf_wrapper --multi \
                    --prompt="Search Processes> " \
                    --query (commandline --current-token) \
                    --ansi \
                    # first line outputted by ps is a header, so we need to mark it as so
                    --header-lines=1 \
                    # ps uses exit code 1 if the process was not found, in which case show an message explaining so
                    --preview="$ps_cmd -o '$ps_preview_fmt' -p {1} || echo 'Cannot preview {1} because it exited.'" \
                    --preview-window="bottom:4:wrap" \
                    $fzf_processes_opts
    )

    if test $status -eq 0
        for process in $processes_selected
            set -f --append pids_selected (string split --no-empty --field=1 -- " " $process)
        end

        # string join to replace the newlines outputted by string split with spaces
        commandline --current-token --replace -- (string join ' ' $pids_selected)
    end

    commandline --function repaint
end
