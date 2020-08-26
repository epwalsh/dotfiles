function l
    if set -q argv
        set dir $argv[1]
    else
        set dir .
    end
    exa --long --all --git-ignore --ignore-glob '**/.git' --icons --color always --group-directories-first $dir | less -RFX
end
