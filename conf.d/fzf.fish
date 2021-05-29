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
    functions --erase _fzf_uninstall fzf_uninstall_bindings fzf_install_bindings fzf_conflictless_mnemonic_bindings fzf_simple_mnemonic_bindings
    functions --erase (functions --all | string match --entire --regex '^__fzf')

    set_color --italics cyan
    echo "fzf.fish uninstalled"
    set_color normal
end

function _fzf_migration_message --on-event fzf_update
    set_color FF8C00 # dark orange
    printf '\n%s\n' 'If you last updated fzf.fish before June 2021 and use custom key bindings, you may need to migrate them.'
    printf '%s\n\n' 'Check out https://github.com/PatrickF1/fzf.fish/wiki/Migration-guides#v70.'
    set_color normal
end
