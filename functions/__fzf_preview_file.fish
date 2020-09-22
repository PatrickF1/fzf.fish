# helper function for __fzf_search_current_dir
function __fzf_preview_file --description "Prints a preview for the given file based on its file type." --argument-names file_path
    if test -f "$file_path" # regular file
        bat --style=numbers --color=always "$file_path"
        echo hello
    else if test -d "$file_path" # directory
        CLICOLOR_FORCE=true ls -a "$file_path"
    else if test -L "$file_path" # symlink
        # notify user and recurse on the target of the symlink, which can be any of these file types
        set -l target_path (realpath $file_path)

        set_color yellow
        echo "'$file_path' is a symlink to '$target_path'."
        set_color normal

        __fzf_preview_file "$target_path"
    else if test -c "$file_path"
        __fzf_report_file_type "$file_path" "character device file"
    else if test -b "$file_path"
        __fzf_report_file_type "$file_path" "block device file"
    else if test -S "$file_path"
        __fzf_report_file_type "$file_path" "socket"
    else if test -p "$file_path"
        __fzf_report_file_type "$file_path" "named pipe"
    else
        echo "Unexpected file symbol $file_type_char. Please open an issue at https://github.com/patrickf3139/fzf.fish." >&2
    end
end
