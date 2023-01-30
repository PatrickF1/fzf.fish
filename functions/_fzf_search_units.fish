function _fzf_search_units --description "Search all systemd services. Replace the current token with the service name of the selected services"
    if ! command --query systemctl
        echo "Not a systemd machine, can't query systemd units"
        exit 1
    end

    set systemctl_cmd systemctl list-units --all --no-pager --plain --type service $fzf_systemctl_opts

    set units_selected (
        $systemctl_cmd --no-legend | \
        _fzf_wrapper --multi \
                    --prompt="Search Units> " \
                    --query (commandline --current-token) \
		    # systemctl --no-legend provides no header; but with a legend provides
		    # useless statistics at the bottom, with arbitary amounts of lines.
		    # Get the headers by searching again, and only grabbing the header line
                    --header ($systemctl_cmd | head -n1 | string trim -l) \
                    --preview="SYSTEMD_COLORS=1 systemctl status -- {1}" \
                    --preview-window="bottom:15:wrap" \
                    $fzf_units_opts
    )

    if test $status -eq 0
        for unit in $units_selected
            set --append services_selected (string split --no-empty --field=1 -- " " $unit)
        end

        # string join to replace the newlines outputted by string split with spaces
        commandline --current-token --replace -- (string join ' ' $services_selected)
    end

    commandline --function repaint
end
