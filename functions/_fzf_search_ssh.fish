function _fzf_search_ssh --description "Search the current directory. Replace the current token with the selected file paths."
    set -f fzf_arguments --multi --ansi
    set -f token (commandline --current-token)
    set -f expanded_token (eval echo -- $token)
    set -f unescaped_exp_token (string unescape -- $expanded_token)

    set --prepend fzf_arguments --prompt="Search ssh> " --query="$unescaped_exp_token" --preview='ssh -G {} 2>/dev/null | grep -w -e host -e user -e hostname -e port'
    set -f ssh_host_selected (__fish_print_ssh 2>/dev/null | _fzf_wrapper $fzf_arguments)

    if test $status -eq 0
        commandline --current-token --replace -- (string escape -- $ssh_host_selected | string join ' ')
    end

    commandline --function repaint
end

function _ssh_include --argument-names ssh_config
    # Relative paths in Include directive use /etc/ssh or ~/.ssh depending on
    # system or user level config. -F will not override this behaviour
    set -l relative_path $HOME/.ssh
    if string match '/etc/ssh/*' -- $ssh_config
        set relative_path /etc/ssh
    end

    function _recursive --no-scope-shadowing
        set -l paths
        for config in $argv
            if test -r "$config" -a -f "$config"
                set paths $paths (
                # Keep only Include lines and remove Include syntax
                string replace -rfi '^\s*Include\s+' '' <$config \
                # Normalize whitespace
                | string trim | string replace -r -a '\s+' ' ')
            end
        end

        set -l new_paths
        for path in $paths
            set -l expanded_path
            # Scope "relative" paths in accordance to ssh path resolution
            if string match -qrv '^[~/]' $path
                set path $relative_path/$path
            end
            # Use `eval` to expand paths (eg ~/.ssh/../test/* to /home/<user>/test/file1 /home/<user>/test/file2),
            # and `set` will prevent "No matches for wildcard" messages
            eval set expanded_path $path
            for path in $expanded_path
                # Skip unusable paths.
                test -r "$path" -a -f "$path"
                or continue
                echo $path
                set new_paths $new_paths $path
            end
        end

        if test -n "$new_paths"
            _recursive $new_paths
        end
    end
    _recursive $ssh_config
end

function __fish_print_ssh
    set -l ssh_config ~/.ssh/config

    # Inherit settings and parameters from `ssh` aliases, if any
    if functions -q ssh
        # Get alias and commandline options.
        set -l ssh_func_tokens (functions ssh | string match '*command ssh *' | string split ' ')
        set -l ssh_command $ssh_func_tokens (commandline -cpo)
        # Extract ssh config path from last -F short option.
        if contains -- -F $ssh_command
            set -l ssh_config_path_is_next 1
            for token in $ssh_command
                if contains -- -F $token
                    set ssh_config_path_is_next 0
                else if test $ssh_config_path_is_next -eq 0
                    set ssh_config (eval "echo $token")
                    set ssh_config_path_is_next 1
                end
            end
        end
    end
    set -l ssh_configs /etc/ssh/ssh_config (_ssh_include /etc/ssh/ssh_config) $ssh_config (_ssh_include $ssh_config)

    for file in $ssh_configs
        if test -r $file
            # Don't read from $file twice. We could use `while read` instead, but that is extremely
            # slow.
            read -alz -d \n contents <$file

            # Print hosts from system wide ssh configuration file
            # Multiple names for a single host can be given separated by spaces, so just split it explicitly (#6698).
            string replace -rfi '^\s*Host\s+(\S.*?)\s*$' '$1' -- $contents | string split " " | string match -rv '[\*\?]'
            # Also extract known_host paths.
            set known_hosts $known_hosts (string replace -rfi '.*KnownHostsFile\s*' '' -- $contents)
        end
    end
end
