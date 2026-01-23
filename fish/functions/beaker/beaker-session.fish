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

    # Check if we already have a session on that cluster, and attach to it if so.
    set -l author $(beaker account whoami --format=json | jq -r '.[].name')
    set -l current_session $(beaker session list --author="$author" --cluster="$cluster" --format=json | jq -r '.[].id' | head -n 1)
    if test -n "$current_session"
        echo "Using existing session: $current_session"
        beaker session attach --remote "$current_session"
        return 0
    end

    # Otherwise create and attach to a new one.
    beaker session create --remote --bare --cluster="$cluster" --mount "src=weka,ref=oe-training-default,dst=/weka/oe-training-default"
end
