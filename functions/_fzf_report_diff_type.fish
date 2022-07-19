# helper for _fzf_preview_changed_file
function _fzf_report_diff_type --argument-names diff_type --description "Print a distinct colored header."
    set_color --underline yellow
    echo -e === $diff_type ===\n
    set_color normal
end
