function Gdelete-branch
    set current_branch (git rev-parse --abbrev-ref HEAD)
    set has_upstream_remote (git remote -v | grep upstream | wc -l)
    set default_branch (git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@')
    git checkout $default_branch
    if test $has_upstream_remote -ne 0
        git pull --rebase upstream $default_branch
    else
        git pull
    end
    git branch -d $current_branch
    git remote prune origin
end
