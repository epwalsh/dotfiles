function Gupdate-branch
    # Update the current branch with the main branch.
    # Takes 1 argument, the name of the base branch, which defaults to 'main'.
    argparse --max-args=1 'h/help' 'r/remote=?' -- $argv
    or return

    if set -ql _flag_help
        echo "Gupdate-branch [-h/--help] [-r/--remote=REMOTE] [BASE_BRANCH]"
        return 0
    end

    # Check if repo is dirty.
    if git_repo_is_dirty
        log_error "Repository has uncommitted changes. Please commit or stash them before updating the branch."
        return 1
    end

    # Set remote to --remote option or default to 'origin'.
    set -l remote origin
    set -ql _flag_remote[1]
    and set remote $_flag_remote[-1]

    # Set base branch to argument or default to 'main'.
    set -l base_branch main
    if test (count $argv) -eq 1
        set base_branch $argv[-1]
    end

    set -l current_branch (git rev-parse --abbrev-ref HEAD)
    if test $status -ne 0
        log_error "unable to determine current branch"
        return 1
    end

    git checkout $base_branch || return 1
    git pull $remote $base_branch || return 1
    git checkout $current_branch || return 1
    git merge $base_branch
end
