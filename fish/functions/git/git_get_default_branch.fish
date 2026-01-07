function git_get_default_branch
    # Returns the default branch of the current git repository.
    # Usage: git_get_default_branch
    set -l default_branch (git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@')
    if test $status -ne 0 -o -z "$default_branch"
        log_warning "Unable to automatically determine default branch. Defaulting to 'main', but consider running 'git remote set-head origin --auto'."
        set default_branch main
    end
    echo $default_branch
end
