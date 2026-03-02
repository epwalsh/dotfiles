function Gworktree-pr
    set -l git_root (git rev-parse --show-toplevel 2>/dev/null)
    set -l parent_dir (basename (dirname $git_root))
    if test $parent_dir = "git-worktrees" && test -d $git_root/../../.git
        log_error "Cannot run Gworktree-pr from within a worktree."
        return 1
    end

    # Checkout a worktree for a GitHub PR.
    argparse --min-args=1 --max-args=1 'h/help' 'r/remote=?' -- $argv
    or return

    if set -ql _flag_help
        echo "Gworktree-pr [-h/--help] [-r/--remote=REMOTE] PR_NUMBER"
        return 0
    end

    # Set remote to --remote option or default to 'origin'.
    set -l remote origin
    set -ql _flag_remote[1]
    and set remote $_flag_remote[-1]

    set -l pr_number $argv[-1]

    # Get branch name from PR number using GitHub CLI.
    set -l branch_name (gh pr view $pr_number --json=headRefName --jq=.headRefName)
    if test -z "$branch_name"
        log_error "PR #$pr_number not found."
        return 1
    end

    # Resolve the path for the worktree and check if it already exists.
    set -l worktree_path git-worktrees/pr-$pr_number
    if test -d $worktree_path
        log_info "Worktree for PR #$pr_number already exists at $worktree_path."
        cd $worktree_path
        return 0
    end

    # Create the new worktree for the PR branch.
    git worktree add --quiet --guess-remote -b $branch_name $worktree_path $remote/$branch_name || return 1
    log_info "Worktree for PR #$pr_number created at $worktree_path."
    cd $worktree_path
end
