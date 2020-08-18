# helper function for __fzf_search_current_dir
function __fzf_preview_file --description "Prints a preview for the given file based on its file type." --argument-names file_path
    if test -d "$file_path"
        set file_type "d"
    else
        set file_type (ls -o "$file_path" | cut -c 1) #exa is faster than ls and file
    end
    switch $file_type
        case "d"
            # Setting CLICOLOR_FORCE forces colors to be enabled even to a non-terminal output
            CLICOLOR_FORCE=true ls -a "$file_path"
        case "s"
            __fzf_report_file_type "$file_path" "socket"
        case "l" # example: "symbolic link to /path/to/file"
              #no way to directly tell if broken symlink using ls
              if test -e (readlink -f "$file_path")
                  __fzf_report_file_type "$file_path" "symbolic link"
              else
                  __fzf_report_file_type "$file_path" "broken symbolic link"
              end
        case "b" "c" # examples: "character special (23/5)" and "block special (1/7)"
            __fzf_report_file_type "$file_path" "device file"
        case "-"
            bat --style=numbers --color=always "$file_path"
        case "*"
            echo "Unsure how to preview '$file_path', which has file type '$file_type'. Please open an issue at https://github.com/patrickf3139/fzf.fish."
    end
end
