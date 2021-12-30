function _fzf_search_pids --description "Search pid for all running commands"
    set fzf_arguments --multi --ansi $fzf_pids_opts
    set token (commandline --current-token)
    # expand any variables or leading tilde (~) in the token
    #set expanded_token (eval echo -- $token)

    set pid_selected (ps -A -opid,command | _fzf_wrapper | awk '{print $1}')

    if test $status -eq 0
        commandline --current-token --replace -- (string escape -- $pid_selected)
    end

    commandline --function repaint
end
