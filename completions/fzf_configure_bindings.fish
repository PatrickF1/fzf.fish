complete fzf_configure_bindings --no-files
complete fzf_configure_bindings --long help --short h --description "Print help" --condition "not __fish_seen_argument --help -h"
complete fzf_configure_bindings --long directory --description "Change the key binding for searching directory" --condition "not __fish_seen_argument --directory"
complete fzf_configure_bindings --long git_log --description "Change the key binding for searching git log" --condition "not __fish_seen_argument --git_log"
complete fzf_configure_bindings --long git_status --description "Change the key binding for searching git status" --condition "not __fish_seen_argument --git_status"
complete fzf_configure_bindings --long history --description "Change the key binding for searching history" --condition "not __fish_seen_argument --history"
complete fzf_configure_bindings --long processes --description "Change the key binding for searching processes" --condition "not __fish_seen_argument --processes"
complete fzf_configure_bindings --long variables --description "Change the key binding for searching variables" --condition "not __fish_seen_argument --variables"
