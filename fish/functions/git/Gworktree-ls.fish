function Gworktree-ls
    set -l current_dir (pwd)
    set -l git_root (git rev-parse --show-toplevel 2>/dev/null)
    set -l parent_dir (basename (dirname "$git_root"))
    if test "$parent_dir" = "git-worktrees" && test -d "$git_root/../../.git"
        set git_root "$git_root/../../"
    end

    set -l worktree_root "$git_root/git-worktrees"
    log_info "Listing worktrees in $worktree_root:"

    for worktree in (find $worktree_root -mindepth 1 -maxdepth 1 -type d)
        set -l rel_path (string replace -r "^$git_root\/" '' $worktree)
        set -l branch_name (cd "$worktree"; git branch --show-current; cd "$current_dir")
        set -l display (set_color blue)"$rel_path"(set_color normal) "on" (set_color magenta)" $branch_name"(set_color normal)

        set -l pr_number (basename $worktree | string replace -r '^pr-(\d+)$' '$1')
        if test -n "$pr_number"
            set -l pr_info (gh pr view 626 --json=url,title,state) || return 1
            set -l state (echo "$pr_info" | jq -r '.state')
            set -l state_color yellow
            if test "$state" = "OPEN"
                set state_color green
            else if test "$state" = "CLOSED"
                set state_color red
            end
            set display $display "for" (set_color $state_color)" PR #$pr_number" (set_color --bold)(echo "$pr_info" | jq '.title')(set_color normal) "at" (set_color cyan)(echo "$pr_info" | jq -r '.url')(set_color normal)
        end

        echo "$display"
    end
end
