function today
    set today (date +%F)
    nvim "$today.md"
end
