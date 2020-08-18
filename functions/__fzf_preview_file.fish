# helper function for __fzf_search_current_dir
function __fzf_preview_file --description "Prints a preview for the given file based on its file type." --argument-names file_path
    # -o gives long format without group id
    # -d does not display the contents of named directories, but information about the directories themselves
    # We want long format because it outputs the file type symbol as the very first character of each row
    # See https://linuxconfig.org/identifying-file-types-in-linux
    set file_symbol (ls -o -d "$file_path" | string sub --length 1)
    switch $file_symbol
        case b c # block and character device file
            __fzf_report_file_type "$file_path" "device file"
        case d
            # Setting CLICOLOR_FORCE forces colors to be enabled even to a non-terminal output
            CLICOLOR_FORCE=true ls -a "$file_path"
        case s
            __fzf_report_file_type "$file_path" "socket"
        case p # named pipe
            __fzf_report_file_type "$file_path" TODO
        case - l # TODO: test l for directories
            bat --style=numbers --color=always "$file_path"
        case "*"
            echo "Unsure how to preview '$file_path', which has file symbol $file_symbol. Please open an issue at https://github.com/patrickf3139/fzf.fish."
    end
end
