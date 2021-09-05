# fzf.fish is only meant to be used in interactive mode. If not in interactive mode, skip the config to speed up shell startup
if not status is-interactive
    exit
end

# Install the default bindings, which are mnemonic and minimally conflict with fish's preset bindings
fzf_configure_bindings

# Doesn't erase autoloaded _fzf_* functions because they are not easily accessible once key bindings are erased
function _fzf_uninstall --on-event fzf_uninstall
    _fzf_uninstall_bindings

    functions --erase _fzf_uninstall _fzf_migration_message _fzf_uninstall_bindings fzf_configure_bindings
    complete --erase fzf_configure_bindings

    set_color cyan
    echo "fzf.fish uninstalled."
    echo "You may need to manually remove fzf_configure_bindings from your config.fish if you were using custom key bindings."
    set_color normal
end

function _fzf_migration_message --on-event fzf_update
    set_color FF8C00 # dark orange
    printf '\n%s\n' 'If you last updated fzf.fish before 2021-06-11, you need to migrate your key bindings.'
    printf '%s\n\n' 'Check out https://github.com/PatrickF1/fzf.fish/wiki/Migration-Guides#v7.'
    set_color normal
end
