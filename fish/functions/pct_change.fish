function pct_change
    python -c "print(f'{100 * ($argv[1] - $argv[2]) / $argv[2]:.2f}%')"
end

