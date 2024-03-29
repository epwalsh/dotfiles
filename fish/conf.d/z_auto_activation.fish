################################################################
# Automatic Python virtual environment activation.
################################################################

if test -d $HOME/miniconda3/bin
    eval $HOME/miniconda3/bin/conda "shell.fish" "hook" $argv | source
    set -gx DEFAULT_VIRTUAL_ENV base
else
    set -gx DEFAULT_VIRTUAL_ENV base
end

if not set -q VENV_ACTIVATOR
    if type -q vf
        set -g VENV_ACTIVATOR vf
    else if type -q conda
        set -g VENV_ACTIVATOR conda
    end
end

if not set -q VENV_ACTIVATION_FILE
    set -g VENV_ACTIVATION_FILE .venv
end

function __venv_activate
    $VENV_ACTIVATOR activate $argv[1] &> /dev/null
    set -g current_virtual_env $argv[1]
    if not set -q VIRTUAL_ENV
        set -g VIRTUAL_ENV (dirname (dirname (which python)))
    end
end

if begin; set -q VENV_ACTIVATOR; and not set -q current_virtual_env; and set -q DEFAULT_VIRTUAL_ENV; end
    __venv_activate $DEFAULT_VIRTUAL_ENV
end

function __venv_support_auto_activate --on-variable PWD
    if status --is-command-substitution
        return
    end

    if not set -q VENV_ACTIVATOR
        return
    end

    # find an auto-activation file
    set -l activation_root $PWD
    set -l new_virtualenv_name ""
    while test $activation_root != ""
        if test -f "$activation_root/$VENV_ACTIVATION_FILE"
            set new_virtualenv_name (command cat "$activation_root/$VENV_ACTIVATION_FILE")
            break
        end
        # this strips the last path component from the path.
        set activation_root (echo $activation_root | sed 's|/[^/]*$||')
    end

    if test $new_virtualenv_name != ""
        # if the virtualenv in the file is different, switch to it
        if begin; not set -q current_virtual_env; or test $new_virtualenv_name != (basename $current_virtual_env); end
            __venv_activate $new_virtualenv_name
        end
    else if begin; not set -q current_virtual_env; and set -q DEFAULT_VIRTUAL_ENV; end
        __venv_activate $DEFAULT_VIRTUAL_ENV
    end
end

#automatically activate if started in a directory with a virtualenv in it
__venv_support_auto_activate
