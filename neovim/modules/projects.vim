" Project-specific settings.
"

augroup custom_project_settings
    autocmd!
    au BufRead *meta-learn-prompt/*.py let b:isort_off=1
augroup END
