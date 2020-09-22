# helper function for _fzf_preview_file
function _fzf_report_file_type --argument-names fileType --no-scope-shadowing --description "Explain the file type for a file."
    set_color red
    echo "Cannot preview '$file_path': it is a $fileType."
    set_color normal
end
