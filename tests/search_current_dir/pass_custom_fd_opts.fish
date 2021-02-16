set fd_captured_args "overwrite me"
function fd
    set fd_captured_args $argv
end
mock commandline \* ""
mock fzf \* ""
set fzf_fd_opts --hidden --exclude=.git
__fzf_search_current_dir

@test "correctly passes fzf_fd_opts when executing fd" -n (string match --entire -- "$fzf_fd_opts" "$fd_captured_args")