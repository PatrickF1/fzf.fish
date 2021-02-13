function __fzf_preview_changed_file
    set git_status (string sub --length 2 $argv[1])

    # path has been renamed and looks like "R LICENSE -> LICENSE.md"
    # extract the renamed path
    if test (string sub --length 1 $git_status) = 'R'
        set path (string split -- "-> " $argv[2])[-1]
    else
        set path $argv[2]
    end

    switch $status
        # Untracked filed
        case '\?\?'
            bat $path
        # Deleted files, show the file content in previous commit
        case '?D' 'D?'
            git show HEAD:$path
        # Other files, show the diff compared to last commit (unstaged & staged changes)
        case '*'
            git diff --color HEAD $path
    end
end
