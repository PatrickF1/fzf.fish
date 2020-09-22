# helper function for _fzf_preview_file
function _fzf_report_file_type -a fileType --no-scope-shadowing -d "Explain the file type for a file."
    set_color red
    echo "Cannot preview '$filePath': it is a $fileType."
    set_color normal
end
