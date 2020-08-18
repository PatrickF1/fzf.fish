# helper function for __fzf_preview_file
function __fzf_report_file_type --description "Explain the file type for a file." --argument-names file_path file_type
    set_color red
    echo "Cannot preview: '$file_path' is a $file_type."
    set_color normal
end
