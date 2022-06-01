# set up mocks needed for all the test cases
mock commandline \* ""
mock commandline "--current-token --replace --" "echo \$argv"
function fd
    if test "$argv" = --version
        echo fd 8.3.2
    end
end

mock fzf \* "echo -e conf.d\nfunctions"
set result (_fzf_search_directory)
@test "doesn't append / if more than one path selected" "$result" = "conf.d functions"

set non_dir_path README.md
mock fzf \* "echo $non_dir_path"
set result (_fzf_search_directory)
@test "doesn't append / if path is not a directory" "$result" = $non_dir_path

set dir_path conf.d
mock fzf \* "echo $dir_path"
set result (_fzf_search_directory)
@test "appends / if exactly one selection and it is a directory" "$result" = $dir_path/
