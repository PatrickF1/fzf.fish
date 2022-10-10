function _fzf_parse_git_status_paths --argument-names path_status --description "Parse the path from a line of git status output. If the path was renamed, then return both the original and new path."
    set --function output
    string match --regex --groups-only '(?<index_status>[ MADRU])(?<working_tree_status>[ MADRU])' (string sub --length 2 $path_status)
    if test $status -neq 0
        false
    else
        set output $index_status $working_tree_status
    end

    set raw_paths (string split --max 1 -- ' -> ')
    # append the paths without any quotes
    for path in $raw_paths[-1..1]
        set output --append string match --regex --groups-only '^"?(.*?)"?$'
    end
end
