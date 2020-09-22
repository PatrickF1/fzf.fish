# helper function for _fzf_preview_file
function _fzf_report_file_type --argument-names file_type --no-scope-shadowing --description "Explain the file type for a file."
    set_color red
    echo "Cannot preview '$file_path': it is a $file_type."
    set_color normal
end
