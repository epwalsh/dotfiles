################################################################
# Automatic Python virtual environment activation.
################################################################

set -gx DEFAULT_VIRTUAL_ENV "$HOME/dotfiles/.venv"

function __venv_activate
    if test -d $argv[1]
        # If the virtual env is a directory, activate it directly.
        source $argv[1]/bin/activate.fish &> /dev/null || return 1
        echo "Activated virtual environment at $argv[1]"
    else
        log_error "Virtual environment $argv[1] not found."
        return 1
    end

    set -gx current_virtual_env $argv[1]

    # Sometimes the prompt gets eff-ed up when activating a virtual environment, so we reset it here.
    starship init fish | source
end

function __venv_support_auto_activate --on-variable PWD
    if status --is-command-substitution
        return
    end

    # Find an auto-activation file
    set -l activation_root $PWD
    set -l new_virtualenv_name ""
    while test $activation_root != ""
        if test -d "$activation_root/.venv"
            set new_virtualenv_name "$activation_root/.venv"
            break
        end
        # Strip the last path component from the path
        set activation_root (echo $activation_root | sed 's|/[^/]*$||')
    end

    if test $new_virtualenv_name != ""; 
        if begin; not set -q current_virtual_env; or test $new_virtualenv_name != $current_virtual_env; end
            # Deactivate the current virtual environment if there is one
            if set -q current_virtual_env
                if test -f $current_virtual_env/bin/deactivate.fish
                    source $current_virtual_env/bin/deactivate.fish &> /dev/null
                    and echo "Deactivated virtual environment $current_virtual_env"
                end
            end

            # Activate the new one
            __venv_activate $new_virtualenv_name
        end
    else if begin; not set -q current_virtual_env; and set -q DEFAULT_VIRTUAL_ENV; end
        __venv_activate $DEFAULT_VIRTUAL_ENV
    end
end

# Automatically activate if started in a directory with a virtual env in it
__venv_support_auto_activate
