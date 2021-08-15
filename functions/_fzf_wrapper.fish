function _fzf_wrapper --description "Prepares some environment variables before invoking fzf."
    # Make sure fzf uses fish to execute preview functions, some of which
    # are autoloaded so don't exist in other shells.
    # Use --local so that it doesn't clobber SHELL outside of this function.
    set --local --export SHELL (command --search fish)

    fzf $argv
end
