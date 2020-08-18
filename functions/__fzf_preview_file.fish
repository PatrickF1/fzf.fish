# helper function for __fzf_search_current_dir
function __fzf_preview_file --description "Prints a preview for the given file based on its file type." --argument-names file_path
    # -d does not display the contents of named directories, but information about the directories themselves
    # -o gives long format without group id
    # We want long format because it outputs the file type symbol as the very first character of each row
    set file_symbol (ls -o -d "$file_path" | string sub --length 1)

    # For more on file symbols outputted by ls long format, see https://linuxconfig.org/identifying-file-types-in-linux
    # For more on file types, see https://en.wikipedia.org/wiki/Unix_file_types
    switch $file_symbol
        case b c # block and character device file
            __fzf_report_file_type "$file_path" "device file"
        case d
            # Setting CLICOLOR_FORCE forces colors to be enabled even to a non-terminal output
            CLICOLOR_FORCE=true ls -a "$file_path"
        case s # example socket: /tmp/.s.PGSQL.5432
            __fzf_report_file_type "$file_path" "socket"
        case p
            __fzf_report_file_type "$file_path" "named pipe"
        case -
            bat --style=numbers --color=always "$file_path"
        case l
            # handle symlinks by notifying user and recursing on the target of the symlink
            set target_path (realpath $file_path)
            set_color yellow; and echo "'$file_path' is a symlink to '$target_path'"
            __fzf_preview_file "$target_path"
        case "*"
            echo "Unsure how to preview '$file_path', which has file symbol $file_symbol. Please open an issue at https://github.com/patrickf3139/fzf.fish."
    end
end
