set nooverride PATH PWD

if not set -q ENV_VAR_FILE
    set -g ENV_VAR_FILE .env
end

function __unset_env_vars
    if set -q CURRENT_ENV_VAR_FILE
        echo "Unsetting env vars from $CURRENT_ENV_VAR_FILE"
        for line in (cat "$CURRENT_ENV_VAR_FILE" | grep -v '^#' | grep -v '^\s*$')
            set item (string split -m 1 '=' $line)
            set --erase $item[1]
            echo " ❯ unset $item[1]"
        end

        set --erase CURRENT_ENV_VAR_FILE
    end
end

function __env_var_auto_set --on-variable PWD
    # find an auto-activation file
    set -l activation_root $PWD
    set -l env_var_file_found 0
    while test $activation_root != ""
        set -l ENV_VAR_FILE_PATH "$activation_root/$ENV_VAR_FILE"
        if test -f "$ENV_VAR_FILE_PATH"
            set env_var_file_found 1

            if set -q CURRENT_ENV_VAR_FILE
                if [ "$CURRENT_ENV_VAR_FILE" = "$ENV_VAR_FILE_PATH" ]
                    # already loaded this file, nothing to do
                    break
                else
                    # unset variables from the current (previously read) env var file.
                    __unset_env_vars
                end
            end

            set -gx CURRENT_ENV_VAR_FILE "$ENV_VAR_FILE_PATH"

            # read and set variables from file
            echo "Setting env vars from $ENV_VAR_FILE_PATH"
            for line in (cat "$ENV_VAR_FILE_PATH" | grep -v '^#' | grep -v '^\s*$')
                set item (string split -m 1 '=' $line)
                set -gx $item[1] $item[2]
                echo " ❯ set $item[1]"
            end
            break
        end
        # this strips the last path component from the path.
        set activation_root (echo $activation_root | sed 's|/[^/]*$||')
    end

    if test $env_var_file_found -eq 0
        # if we didn't find a new env var file unset the last ones
        __unset_env_vars
    end
end


__env_var_auto_set
