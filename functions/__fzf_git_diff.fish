function __fzf_git_diff --argument-names file_status file_path --description "Print git diff for the given file based on its status."
    if test $file_status = A || test $file_status = "??"
        git diff --color=always --no-index -- /dev/null $file_path
    else
        git diff --color=always -- $file_path
    end
end
