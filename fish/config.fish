eval (python -m virtualfish auto_activation global_requirements)

set -gx PIPENV_IGNORE_VIRTUALENVS 1

set -gx WORKON_HOME $HOME/.virtualenvs

# Default virtual env
if not set -q VIRTUAL_ENV
    vf activate py3.6
end

# Add cargo bin to PATH
set -gx PATH ~/.cargo/bin/ $PATH

# Set default editor
set -gx EDITOR nvim

# Vi bindings
fish_vi_key_bindings
