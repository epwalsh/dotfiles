function Gmerge-and-delete
    set current_branch (git rev-parse --abbrev-ref HEAD)
    set has_upstream_remote (git remote -v | grep upstream | wc -l)
    # If this step fails, run 'git remote set-head origin --auto'
    set default_branch (git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@')
    git checkout $default_branch
    if test $has_upstream_remote -ne 0
        git pull --rebase upstream $default_branch
    else
        git pull
    end
    git push -d origin $current_branch
    git branch -d $current_branch
    git remote prune origin
end
