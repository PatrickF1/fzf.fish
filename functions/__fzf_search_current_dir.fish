function __fzf_search_current_dir --description "Search the current directory using fzf and fd. Insert the selected filenames into the commandline at the cursor."
    set files_selected (
        fd --hidden --follow --color=always --exclude=.git 2> /dev/null |
        fzf --multi --ansi
    )

    if test $status -eq 0
        commandline --insert (echo $files_selected | xargs) # doesn't string escape so won't work with weird filenames
        commandline --insert " "
    end

    commandline --function repaint
end
