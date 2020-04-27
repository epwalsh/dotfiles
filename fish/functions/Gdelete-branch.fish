function Gdelete-branch
    set current_branch (git rev-parse --abbrev-ref HEAD)
    set has_upstream_remote (git remote -v | grep upstream | wc -l)
    git checkout master
    if test $has_upstream_remote -ne 0
        git pull --rebase upstream master
    else
        git pull
    end
    git branch -d $current_branch
    git remote prune origin
end
