function _fzf_search_grep --description "Live grep search using ripgrep and fzf. Replace the current token with the selected file paths."
    # Directly use rg binary to avoid issues with aliases.
    set -f rg_cmd (command -v rg || echo "rg")

    set -f token (commandline --current-token)

    # unescape token because it's already quoted
    set -f unescaped_token (string unescape -- $token)

    set -f fzf_arguments --ansi --multi $fzf_grep_opts
    set --prepend fzf_arguments \
        --disabled \
        --query="$unescaped_token" \
        --prompt="Grep> " \
        --delimiter=":" \
        --preview='_fzf_preview_grep {1} {2}' \
        --preview-window='right:60%:+{2}-10' \
        --bind="start:reload:$rg_cmd --color=always --line-number --column --smart-case -- {q}" \
        --bind="change:reload:sleep 0.1; $rg_cmd --color=always --line-number --column --smart-case -- {q}" \
        --bind='ctrl-o:execute($EDITOR {1} +{2})'

    set -f selected_lines (_fzf_wrapper $fzf_arguments)

    if test $status -eq 0
        # Extract file:line pairs from selection
        set -f file_line_pairs
        for line in $selected_lines
            set -l file (string split --fields=1 : -- $line)
            set -l lineno (string split --fields=2 : -- $line)
            set --append file_line_pairs "$file:$lineno"
        end
        commandline --current-token --replace -- (string join ' ' $file_line_pairs)
    end

    commandline --function repaint
end
