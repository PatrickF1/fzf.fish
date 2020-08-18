# helper function for __fzf_search_current_dir
function __fzf_preview_file --description "Prints a preview for the given file based on its file type." --argument-names file_path
    set file_type (file --brief -i "$file_path")
    switch $file_type
        case "directory"
            # Setting CLICOLOR_FORCE forces colors to be enabled even to a non-terminal output
            CLICOLOR_FORCE=true ls -a "$file_path"
        case "socket"
            __fzf_report_file_type "$file_path" "socket"
        case "broken symbolic link*" # example: "broken symbolic link to /path/to/file""
            __fzf_report_file_type "$file_path" "broken symbolic link"
        case "* special *" # examples: "character special (23/5)" and "block special (1/7)"
            __fzf_report_file_type "$file_path" "device file"
        case "regular file"
            bat --style=numbers --color=always "$file_path"
        case "*"
            echo "Unsure how to preview '$file_path', which has file type '$file_type'. Please open an issue at https://github.com/patrickf3139/fzf.fish."
    end
end
