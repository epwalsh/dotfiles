function Gpost-merged-pr
    set -l current_branch (git rev-parse --abbrev-ref HEAD)
    set -l default_branch (git_get_default_branch)

    git checkout $default_branch || return 1

    set -l has_upstream_remote (git remote -v | grep upstream | wc -l)
    if test $has_upstream_remote -ne 0
        git pull --rebase upstream $default_branch || return 1
    else
        git pull || return 1
    end
    git branch -D $current_branch
end
