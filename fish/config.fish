eval (python -m virtualfish auto_activation global_requirements)

# Default virtual env
if not set -q VIRTUAL_ENV
    vf activate py3.6
end

# Add cargo bin to PATH
set -gx PATH ~/.cargo/bin/ $PATH

# Set default editor
set -gx EDITOR nvim
