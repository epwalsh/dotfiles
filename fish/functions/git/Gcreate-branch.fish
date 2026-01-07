function Gcreate-branch
    # Create and push a new branch.
    # Takes 1 argument, the name of the new branch.
    argparse --min-args=1 --max-args=1 'h/help' 'r/remote=?' -- $argv
    or return

    if set -ql _flag_help
        echo "Gcreate-branch [-h/--help] [-r/--remote=REMOTE] BRANCH"
        return 0
    end

    # Set remote to --remote option or default to 'origin'.
    set -l remote origin
    set -ql _flag_remote[1]
    and set remote $_flag_remote[-1]

    git checkout -b $argv[-1] || return 1
    git push --set-upstream $remote $argv[-1] || return 1
end
