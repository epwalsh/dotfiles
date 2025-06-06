function Gdelete-branch
    argparse --min-args=1 'h/help' 'r/remote=?' -- $argv
    or return

    if set -ql _flag_help
        echo "Gdelete-branch [-h/--help] [-r/--remote=REMOTE] BRANCH"
        return 0
    end

    set -l remote origin
    set -ql _flag_remote[1]
    and set remote $_flag_remote[-1]

    git push -d $remote $argv[-1]
    git branch -D $argv[-1]
end
