set actual (_fzf_preview_file . | string split " ")
@test "displays dir contents without showing .." -z (string match ".." $actual)
