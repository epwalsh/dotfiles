eval (python -m virtualfish auto_activation global_requirements)

# Default virtual env
if not set -q VIRTUAL_ENV
    vf activate py3.6
end

set -gx PATH ~/.cargo/bin/ $PATH
