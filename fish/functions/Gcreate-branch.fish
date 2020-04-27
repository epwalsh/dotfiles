function Gcreate-branch
    git checkout -b $argv[1]
    git push --set-upstream origin $argv[1]
end
