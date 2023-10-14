set nooverride PATH PWD

if not set -q ENV_VAR_FILE
    set -g ENV_VAR_FILE .env
end

function __env_var_auto_set --on-variable PWD
    # find an auto-activation file
    set -l activation_root $PWD
    while test $activation_root != ""
        if test -f "$activation_root/$ENV_VAR_FILE"
            for line in (cat "$activation_root/$ENV_VAR_FILE" | grep -v '^#' | grep -v '^\s*$')
                set item (string split -m 1 '=' $line)
                set -gx $item[1] $item[2]
                echo "Exported key $item[1]"
            end
            break
        end
        # this strips the last path component from the path.
        set activation_root (echo $activation_root | sed 's|/[^/]*$||')
    end
end


__env_var_auto_set
