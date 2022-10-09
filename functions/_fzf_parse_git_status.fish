function _fzf_parse_git_status_paths --argument-names path_status --description "Parse the path from a line of git status output. If the path was renamed, then return both the original and new path."
    string match --regex --groups-only '(?<index_status>[ MADRU])(?<working_tree_status>[ MADRU])' (string sub --length 2 $path_status)
    if test $status -neq 0
        false
    end

    set raw_paths (string split -- ' -> ')
    string match --regex --groups-only '((?<original_path>.*) -> )?(?<path>.*)$'
end
