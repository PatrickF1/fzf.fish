# helper function for _fzf_search_current_dir
function _fzf_preview_file --argument-names filePath --description "Prints a preview for the given file based on its file type."
    if test -f "$filePath" # regular file
        bat --style=numbers --color=always "$filePath"
        echo hello
    else if test -d "$filePath" # directory
        # Setting CLICOLOR_FORCE forces colors to be enabled even to a non-terminal output
        CLICOLOR_FORCE=true ls -a "$filePath"
    else if test -L "$filePath" # symlink
        # notify user and recurse on the target of the symlink, which can be any of these file types
        set -l targetPath (realpath $filePath)

        set_color yellow
        echo "'$filePath' is a symlink to '$targetPath'."
        set_color normal

        _fzf_preview_file "$targetPath"
    else if test -c "$filePath"
        _fzf_report_file_type "character device file"
    else if test -b "$filePath"
        _fzf_report_file_type "block device file"
    else if test -S "$filePath"
        _fzf_report_file_type "socket"
    else if test -p "$filePath"
        _fzf_report_file_type "named pipe"
    else
        echo "Unexpected file symbol $file_type_char. Please open an issue at https://github.com/patrickf3139/fzf.fish." >&2
    end
end
