function tre
    if set -q argv
        set dir $argv[1]
    else
        set dir .
    end
    exa -T \
        --all \
        --git-ignore \
        --ignore-glob '**/.git|**/.mypy_cache|**/__pycache__|**/*.egg-info|**/.pytest_cache' \
        --icons \
        --color always \
        --group-directories-first $dir | less -RFX
end
