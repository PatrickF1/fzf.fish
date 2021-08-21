set --global --export SHELL /bin/sh
# don't set FZF_DEFAULT_OPTS so it will set one
_fzf_wrapper unknownoption 2>/dev/null # pass unknown options so fzf immediately exits
@test "doesn't clobber SHELL" "$SHELL" = /bin/sh
@test "doesn't clobber FZF_DEFAULT_OPTS" (set --query FZF_DEFAULT_OPTS) $status -eq 1
