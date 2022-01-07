function _fzf_search_processes --description "Search pid for all running commands"
    set fzf_arguments --multi --ansi $fzf_processes_opts
    set token (commandline --current-token)
    # expand any variables or leading tilde (~) in the token
    #set expanded_token (eval echo -- $token)

    set pid_selected (
        ps -A -opid,command | \
        _fzf_wrapper --query $token  \
                     --header-lines=1 \
                     --preview='ps -o pid,user,%cpu,time,rss,command -p {1} | awk \'NR>1 {if ($5 > 1048576) {$5=sprintf("%.02fG", $5/1024/1024);} else {$5=sprintf("%.02fM",$5/1024);}}{for(i=1;i<=5;i++){printf("%s|", $i); $i=""}; $0=$0; print; }\' | column -s"|" -t' \
                     $fzf_arguments | \
        awk '{print $1}'
    )

    if test $status -eq 0
        commandline --current-token --replace -- (string escape -- $pid_selected)
    end

    commandline --function repaint
end
