function git_repo_is_dirty
    # Returns 0 if the current git repository has uncommitted changes, 1 otherwise.
    # Usage: git_repo_is_dirty
    set -l dirty_file_count (git status --porcelain 2>/dev/null | wc -l | string trim)
    if test $status -ne 0
        log_error "not a git repository."
        return 1
    end

    if test $dirty_file_count -gt 0
        return 0
    else
        return 1
    end
end
