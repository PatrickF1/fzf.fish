# Because of scoping rules, to capture the shell variables exactly as they are, we must read
# them before even executing __fzf_search_shell_variables. We use psub to store the
# variables' info in temporary files and pass in the filenames as arguments.
# # This variable is global so that it can be referenced by fzf_install_bindings and in tests
set --global __fzf_search_vars_command '__fzf_search_shell_variables (set --show | psub) (set --names | psub)'

# Install some safe and memorable key bindings by default
fzf_conflictless_mnemonic_bindings

# If FZF_DEFAULT_OPTS is not set, then set some sane defaults. This also affects fzf outside of this plugin.
# See https://github.com/junegunn/fzf#environment-variables
if not set --query FZF_DEFAULT_OPTS
    # cycle allows jumping between the first and last results, making scrolling faster
    # layout=reverse lists results top to bottom, mimicking the familiar layouts of git log, history, and env
    # border makes clear where the fzf window begins and ends
    # height=90% leaves space to see the current command and some scrollback, maintaining context of work
    # preview-window=wrap wraps long lines in the preview window, making reading easier
    # marker=* makes the multi-select marker more distinguishable from the pointer (since both default to >)
    set --global --export FZF_DEFAULT_OPTS '--cycle --layout=reverse --border --height=90% --preview-window=wrap --marker="*"'
end

function _fzf_uninstall --on-event fzf_uninstall
    # Not going to erase FZF_DEFAULT_OPTS because too hard to tell if it was set by the user or by this plugin
    set --erase __fzf_search_vars_command
    fzf_uninstall_bindings
    functions --erase fzf_uninstall_bindings
    functions --erase _fzf_uninstall
    # Not going to erase autoloaded functions b/c they can only be removed by removing the file
end
