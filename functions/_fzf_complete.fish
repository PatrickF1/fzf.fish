# External limitations:
# - fish-shell/fish-shell#9577: folders ending in '=' break fish's internal path completion
#   (It thinks that it has to complete from / because `a_folder=/` looks like an argument to fish.
# - fish cannot give reliable context information on completions. Knowing whether a completion
#   is a file or argument can only be determined via a heuristic.
set --global _fzf_complete_min_description_offset 14
function _fzf_complete --description "Shell completion using fzf"
	# Produce a list of completions from which to choose
	# and do nothing if there is nothing to select from
	set -l cmd (commandline -co) (commandline -t)
	set -l completions (complete --escape --do-complete "$cmd")
	test (count $completions) -eq 0; and return

	set -l results
	set -l first_completion (printf "%s" $completions[1] | cut -f1 --zero-terminated | string split0)

	# A prefix that will be prepended before each selected completion
	set -l each_prefix ""

	# Only skip fzf if there is a single completion and it starts with the expected completion prefix.
	# Otherwise, the completion originates from a match in the description which the user might
	# want to review first (e.g. man ima<TAB> might match `feh`, an image viewer)
	if test (count $completions) -eq 1; and test (string sub -l (string length -- (commandline -ct)) -- $first_completion) = (commandline -ct)
		# If there is only one option then we don't need fzf
		# Everytime we need to cut, we need zero termination to
		# avoid newlines from being interpreted later.
		set results $first_completion
	else
		# We preprocess the whole list to prevent spawning a slow cut process for each completion.
		# From here on, make sure to use -- and zero termination everywhere to prevent introducing
		# new edge-cases where characters are interpreted wrongly
		set -l actual_completions (string join0 -- $completions | cut -f1 --zero-terminated | string split0)
		set -l descriptions (string join0 -- $completions | cut -f2- --zero-terminated | string split0)

		# Find the common prefix of all completions. Yes this seems to be a hard
		# thing to do in fish if it should be fast. No external process may be
		# spawned as this is too slow. So fish internals it is :/
		set -l common_prefix $completions[1]
		set -l common_prefix_length (string length -- $common_prefix)
		for comp in $actual_completions[2..]
			if test (string sub -l $common_prefix_length -- $comp) != $common_prefix
				set -l new_common_prefix_length 0
				set -l try_common_prefix_length (math min $common_prefix_length,(string length -- $comp))
				# Binary search for new common prefix
				set -l step $try_common_prefix_length
				while test $step != 0
					set step (math --scale 0 $step / 2)
					# Adjust range to the left or right depending on whether the current new prefix matches
					set -l xs (string sub -l $try_common_prefix_length -- $comp $common_prefix)
					set -l op (test $xs[1] = $xs[2]; and printf "+"; and set new_common_prefix_length $try_common_prefix_length; or printf "-")
					set try_common_prefix_length (math --scale 0 $try_common_prefix_length $op (math max 1,$step))
				end
				set common_prefix_length $new_common_prefix_length
				set common_prefix (string sub -l $new_common_prefix_length -- $common_prefix)
				# Stop if there is no common prefix
				test $common_prefix_length = 0; and break
			end
		end

		# If the common prefix includes a / we are completing a file path.
		# Strip the prefix until the last / completely and later re-add it on the replaced token
		set -l path_prefix (string match --regex --groups-only -- '^(.*/)[^/]*$' $common_prefix)
		if test $status = 0
			set -l path_prefix_length (string length -- $path_prefix)
			set -l new_start (math 1 + $path_prefix_length)
			for i in (seq (count $completions))
				set completions[$i] (string sub -s $new_start -- $completions[$i])
				set actual_completions[$i] (string sub -s $new_start -- $actual_completions[$i])
			end

			# We have a path-like prefix and will therefore strip this common prefix from all
			# completions to un-clutter the menu.
			set each_prefix (string sub -l $path_prefix_length -- $common_prefix)
			set common_prefix_length (math $common_prefix_length - $path_prefix_length)
			set common_prefix (string sub -s $new_start -- $common_prefix)
		end

		# Detect whether descriptions are present and the length of each completion.
		set -l has_descriptions false
		set -l longest_completion $_fzf_complete_min_description_offset
		for i in (seq (count $completions))
			if string match --quiet -- "*"\t"*" $completions[$i]
				set has_descriptions true

				# Here we additionally remember the longest completion to align the descriptions in fzf later
				set longest_completion (math max $longest_completion,(string length -- $actual_completions[$i]))
				set completions[$i] $actual_completions[$i]\t(set_color -i yellow)$descriptions[$i](set_color normal)
			end
		end

		# FIXME Would technically work, but not sure it's worth the effort to match the descriptions
		# after filtering.
		# Remove tokens from the completion list that are already present on the current commandline.
		#set -l all_tokens (commandline -o)
		#set -l current_token_index (math 1 + (count (commandline -co)))
		#set --erase all_tokens[$current_token_index]
		#set -l remaining (comm --zero-terminated -23 (string join0 -- $actual_completions | psub) (string join0 -- $all_tokens | sort | psub) | string split0)

		# TODO pressing / in a completion should add the completion and immediately start a new completion
		test $has_descriptions = true; and set -l fzf_complete_description_opts \
			--tabstop=(math 2 + $longest_completion)
		set -l fzf_output (
			string join0 -- $completions \
			| _fzf_wrapper \
				--read0 \
				--print0 \
				--ansi \
				--multi \
				--bind=tab:down,btab:up,change:top,ctrl-space:toggle \
				--tiebreak=begin \
				--query=$common_prefix \
				--print-query \
				$fzf_complete_description_opts \
				$fzf_complete_opts \
			| cut -f1 --zero-terminated \
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
			set suffix "/"
		end
	end

	if not contains -- "--" (commandline -co)
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
		echo $each_prefix
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
