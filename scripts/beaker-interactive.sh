#!/bin/bash
# Run this script to bootstrap a Beaker interactive image.
# curl https://raw.githubusercontent.com/epwalsh/dotfiles/master/scripts/beaker-interactive.sh | sh

set -eo pipefail

beaker account whoami

# Pull a GitHub token that can be used to clone private repos.
export GITHUB_TOKEN=$(beaker secret read GITHUB_TOKEN --workspace ai2/llm-testing)

# Initialize conda for bash.
# See https://stackoverflow.com/a/58081608/4151392
eval "$(command conda 'shell.bash' 'hook' 2> /dev/null)"

# Create and activate environment.
conda create -n myenv python=3.10
conda activate myenv

# Install GitHub CLI.
conda install gh --channel conda-forge

# Configure git to use GitHub CLI as a credential helper so that we can clone private repos.
gh auth setup-git

# Install PyTorch.
conda install pytorch torchvision torchaudio pytorch-cuda=11.7 -c pytorch -c nvidia

# Check for GPUs.
python -c 'import torch; print(f"GPUs available: {torch.cuda.device_count()}")'
