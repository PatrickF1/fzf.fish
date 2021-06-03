# uses no-scope-shadowing to directly modify the variables in the scope of fzf_configure_keymap
# returns 1 if options are invalid, and 2 if printing help
function _fzf_configure_keymap_parse_opts --no-scope-shadowing --description "Parse the key binding options for fzf_configure_keymap into the proper variables."
    set options_spec h/help 'directory=?' 'git_log=?' 'git_status=?' 'history=?' 'variables=?'
    argparse --max-args=0 --ignore-unknown $options_spec -- $argv

    if test $status -ne 0
        return 1
    else if set --query _flag_h
        return 2
    else
        if set --query _flag_directory
            set directory $_flag_directory
        end
        if set --query _flag_git_log
            set git_log $_flag_git_log
        end
        if set --query _flag_git_status
            set git_status $_flag_git_status
        end
        if set --query _flag_history
            set history_ $_flag_history
        end
        if set --query _flag_variables
            set variables $_flag_variables
        end
    end
end
