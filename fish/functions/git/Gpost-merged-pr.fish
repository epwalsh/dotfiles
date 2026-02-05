function Gpost-merged-pr
    set -l current_branch (git rev-parse --abbrev-ref HEAD)
    set -l default_branch (git_get_default_branch)

    git checkout $default_branch || return 1
    git pull || return 1
    git branch -D $current_branch

    set -l has_upstream_remote (git remote -v | grep upstream | wc -l)
    if test $has_upstream_remote -ne 0
        read -l -P 'Do you want to rebase with upstream remote? [y/n] ' confirm
        switch $confirm
            case Y y ''
                git pull --rebase upstream $default_branch || return 1
                return 0
            case N n '*'
                return 0
        end
    end
end
