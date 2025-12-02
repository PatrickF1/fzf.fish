# helper function for _fzf_search_grep
function _fzf_preview_grep --description "Preview a grep result with the matched line highlighted."
    set -l file $argv[1]
    set -l line $argv[2]

    set -l start (math "max(1, $line - 10)")
    bat --style=numbers --color=always --highlight-line=$line --line-range=$start: $file
end
