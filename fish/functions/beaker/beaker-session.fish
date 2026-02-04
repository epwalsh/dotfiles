function beaker-session
    argparse --max-args=0 'h/help' 'c/cluster=?' -- $argv
    or return

    if set -ql _flag_help
        echo "beaker-session [-h/--help] [-c/--cluster=CLUSTER]"
        return 0
    end

    # Set cluster to --cluster option or default to 'ai2/phobos'.
    set -l cluster ai2/phobos
    set -ql _flag_cluster[1]
    and set cluster $_flag_cluster[-1]

    set -l author $(beaker account whoami --format=json | jq -r '.[].name')
    or return

    # Check if we already have a session on that cluster, and attach to it if so.
    set -l session $(beaker session list --author="$author" --cluster="$cluster" --format=json | jq -r '.[].id' | head -n 1)

    if test -n "$session"
        echo "Using existing session: $session"
    else
        # Create a new session.
        beaker session create --detach --bare --cluster="$cluster" --mount "src=weka,ref=oe-training-default,dst=/weka/oe-training-default"
        or return

        # Get session ID.
        set session $(beaker session list --author="$author" --cluster="$cluster" --format=json | jq -r '.[].id' | head -n 1)
        if test -n "$session"
            echo "Created new session: $session"
        else
            echo "Error: Failed to create a new session."
            return 1
        end
    end

    # Get the node hostname.
    set -l node $(beaker session get "$session" --format=json | jq -r '.[].session.envVars[] | select(.name == "BEAKER_NODE_HOSTNAME") | .value')
    or return

    if test -z "$node"
        echo "Error: Could not determine node hostname for session $session"
        return 1
    end

    # Mosh into the node and attach to the session.
    mosh "$author@$node" -- beaker session attach "$session"
end
