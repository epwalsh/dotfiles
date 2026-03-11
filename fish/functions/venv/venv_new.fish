function venv_new
    argparse 'h/help' 'e/extra=?' -- $argv
    or return

    if set -ql _flag_help
        echo "venv_new [-h/--help] [-e/--extra=extras...]"
        return 0
    end

    set -l uv_flags

    # Extras, default to --all-extras.
    set -ql _flag_extra[1]
    and set uv_flags $uv_flags --extra="$_flag_extra"
    or set uv_flags $uv_flags --all-extras

    # Create and activate a new virtual environment with uv in the current directory if one doesn't already exist.
    if test -d .venv
        log_info "Virtual environment already exists at .venv."
    else
        uv sync $uv_flags || return 1
        log_info "Virtual environment created at .venv."
    end

    venv_activate .venv
end
