set --export diff_working_called 0
set --export diff_staged_called 0
function git
    if test $argv[1] != diff
        echo "$argv[1] is unsupported" >&2
        exit 1
    else if contains -- --staged $argv
        set diff_staged_called 1
    else
        set diff_working_called 1
    end
end

_fzf_preview_changed_file "R  file1 -> file2" >/dev/null
@test "only calls git diff staged for renamed files" $diff_working_called -eq 0 -a $diff_staged_called -eq 1
