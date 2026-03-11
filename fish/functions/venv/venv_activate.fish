function venv_activate
    # Activate a virtual environment
    argparse --min-args=0 --max-args=1 'h/help' -- $argv
    or return

    if set -ql _flag_help
        echo "venv_activate [-h/--help] [VENV]"
        return 0
    end

    # Default to .venv if no argument is provided
    set -l venv_path
    if test (count $argv) -eq 0
        set venv_path .venv
    else
        set venv_path $argv[-1]
        echo $venv_path
    end

    if not test -d $venv_path
        log_error "Virtual environment not found at $venv_path"
        return 1
    end

    source $venv_path/bin/activate.fish &> /dev/null || return 1
    log_info "Virtual environment activated from $venv_path"

    set -gx current_virtual_env "$venv_path"

    # Sometimes the prompt gets eff-ed up when activating a virtual environment, so we reset it here.
    starship init fish | source
end
