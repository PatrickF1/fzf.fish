# External limitations:
# - fish-shell/fish-shell#9577: folders ending in '=' break fish's internal path completion
#   (It thinks that it has to complete from / because `a_folder=/` looks like an argument to fish.
# - fish cannot give reliable context information on completions. Knowing whether a completion
#   is a file or argument can only be determined via a heuristic.
# - Completion is slow. Not because this script is slow but because fish's `complete` command
#   can take several seconds even for just 100 entries. Just run `time complete --escape --do-complete l`
#   to see for yourself.
set --global _fzf_search_completions_min_description_offset 14
function _fzf_search_completions --description "Shell completion using fzf"
    # Produce a list of completions from which to choose
    # and do nothing if there is nothing to select from
    set -f completions (complete --do-complete)

    set -l fzf_output (
			string join0 -- $completions \
			| _fzf_wrapper \
				--read0 \
				--print0 \
				--ansi \
				--multi \
				--tiebreak=begin \
				--query=$common_prefix \
				--print-query \
				$fzf_complete_description_opts \
			| string split0)

    switch $pipestatus[2]
        case 0
            # If something was selected, discard the current query
            set results $fzf_output[2..-1]
        case 1
            # User accepted without selecting anything, thus we will
            # use just the current query
            set results $fzf_output[1]
        case '*'
            # Fzf failed, do nothing.
            commandline -f repaint
            return
    end

    # Strip anything after last \t (the descriptions)
    for i in (seq (count $results))
        set results[$i] (string split --fields 1 --max 1 --right \t -- $results[$i])
    end
end

set -l prefix ""
set -l suffix " "
# By default we want to append a space to completed options.
# While this is always true when competing multiple things, there
# are some cases in which we don't want to add a space:
if test (count $results) -eq 1
    # When a completion ends in a / we usually want to keep adding to that completion.
    # This may be because it is a directory (or link to a directory), or just
    # an option that takes a category/name tuple like `emerge app-shells/fish`.
    # Also, completions like ~something are directories.
    #
    # In a similar manner, completions ending in = are usually part of an argument
    # that expects a parameter (like --color= or dd if=). The same logic applies here.
    set -l first_char (string sub -l 1 -- $results[1])
    set -l last_char (string sub -s -1 -- $results[1])
    if test $last_char = =; or test $last_char = /
        set suffix ""
    else if string match --regex --quiet -- '^~[^/]*$' $results[1]
        set suffix /
    end
end

if not contains -- -- (commandline -co)
    # If a path is being completed and it starts with --, we add -- to terminate argument interpreting.
    # Technically not always correct (the program may not accept --), but the alternative is worse
    # and this will make the user notice it.
    for r in $results
        test - = (string sub -l 1 -- $r); and test -e $r; and set prefix "-- "; and break
    end
end

# If each_prefix is set, we need to apply it to each result
# before replacing the token
if test -n $each_prefix
    set -l new_tokens
    for r in $results
        set -a new_tokens $each_prefix$r
    end
    commandline -t -- "$prefix$new_tokens$suffix"
else
    commandline -t -- "$prefix$results$suffix"
end

commandline -f repaint
end
