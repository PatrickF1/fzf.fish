# Because of scoping rules, to capture the shell variables exactly as they are, we must read
# them before even executing __fzf_search_shell_variables. We use psub to store the
# variables' info in temporary files and pass in the filenames as arguments.
# # This variable is global so that it can be referenced by fzf_install_bindings and in tests
set --global _fzf_search_vars_command '__fzf_search_shell_variables (set --show | psub) (set --names | psub)'

# Install some safe and memorable key bindings by default
fzf_configure_keymap conflictless_mnemonic

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

# Doesn't erase FZF_DEFAULT_OPTS because too hard to tell if it was set by the user or by this plugin
# Doesn't erase autoloaded __fzf_* functions because they will not be easily accessible once key bindings are erased
function _fzf_uninstall --on-event fzf_uninstall
    _fzf_uninstall_keymap

    set --erase _fzf_search_vars_command
    functions --erase _fzf_uninstall _fzf_migration_message
    functions --erase _fzf_uninstall_keymap fzf_configure_keymap fzf_conflictless_mnemonic_keymap fzf_simple_mnemonic_keymap

    set_color --italics cyan
    echo "fzf.fish uninstalled"
    set_color normal
end

function _fzf_migration_message --on-event fzf_update
    set_color FF8C00 # dark orange
    printf '\n%s\n' 'If you last updated fzf.fish before June 2021, you will need to migrate your key bindings.'
    printf '%s\n\n' 'Check out https://github.com/PatrickF1/fzf.fish/wiki/Migration-guides.'
    set_color normal
end
