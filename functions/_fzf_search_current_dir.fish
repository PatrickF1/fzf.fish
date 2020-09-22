# originally implemented and transposed from https://github.com/patrickf3139/dotfiles/pull/11
function _fzf_search_current_dir -d "Search the current directory using fzf and fd. Insert the selected relative file path into the commandline at the cursor."
    # Make sure that fzf uses fish to execute _fzf_preview_file.
    # See similar comment in _fzf_search_shell_variables.fish.
    set -lx SHELL (command --search fish)
    if set -l filePathSelected (fd --hidden --follow --color=always --exclude=.git 2>/dev/null | fzf --ansi --preview='_fzf_preview_file {}')
        commandline --insert (string escape $filePathSelected)
    end

    commandline --function repaint
end
