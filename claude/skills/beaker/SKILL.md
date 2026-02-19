---
allowed-tools: Bash(beaker *), Bash(gantry *), WebFetch(domain:beaker-docs.apps.allenai.org), WebFetch(domain:beaker-py-docs.allen.ai)
denied-tools: Bash(beaker secret read *)
description: Launch and manage jobs on Ai2 Beaker clusters using the beaker and gantry CLIs
---

# Beaker and Gantry

Help the user launch, monitor, and manage compute jobs on Ai2's Beaker clusters.

There are two CLIs:

- **beaker**: The low-level CLI for Beaker. Use for sessions, datasets, images, secrets, cluster inspection, and submitting raw experiment specs.
- **gantry**: A high-level wrapper around Beaker for batch jobs. Use for most training/eval runs. It handles Docker images, environment setup, and dependency installation automatically from the user's git repo.

## When to use which

| Task | Tool |
|------|------|
| Launch a batch training/eval job | `gantry run` |
| Start an interactive session (SSH-able) | `beaker session create` |
| Find available GPUs | `gantry find-gpus` |
| Check job status / stream logs | `gantry list`, `gantry follow`, `gantry logs` |
| Stop a running job | `gantry stop` or `beaker experiment stop` |
| Upload/download datasets | `beaker dataset create`, `beaker dataset fetch` |
| Manage secrets | `beaker secret write`, `beaker secret list` |
| Inspect clusters/nodes | `beaker cluster list`, `beaker cluster nodes` |
| Submit a raw YAML experiment spec | `beaker experiment create <spec.yaml>` |

## gantry run

The primary command for launching batch jobs. Runs from the user's git repo -- Gantry clones the repo on the remote machine, sets up Python (via uv by default), and installs dependencies automatically.

```bash
gantry run [OPTIONS] -- COMMAND [ARGS...]
```

### Key flags

**Basics:**

- `-n, --name TEXT` -- experiment name (random if omitted)
- `-w, --workspace TEXT` -- Beaker workspace
- `-b, --budget TEXT` -- budget account
- `--show-logs` -- stream logs to stdout (avoid: blocks the session; use `gantry logs`/`gantry follow` instead)
- `-y, --yes` -- skip confirmation prompts
- `--dry-run` -- preview without submitting
- `--save-spec FILE` -- save generated YAML spec

**Hardware:**

- `--gpus INT` -- GPUs per replica
- `--gpu-type TEXT` -- filter by GPU type (e.g. `h100`, `a100`). Multiple allowed.
- `-c, --cluster TEXT` -- cluster name or glob (e.g. `ai2/*-cirrascale`). Multiple allowed.
- `--cpus FLOAT` -- CPU cores per replica
- `--memory TEXT` -- system memory (e.g. `64GiB`)
- `--shared-memory TEXT` -- /dev/shm size

**Data and storage:**

- `--weka 'bucket:/mount'` -- mount Weka bucket (repeatable). This is the primary way to access large data and save checkpoints. Mounts appear at `/weka/<bucket>` on cluster nodes. Common buckets:
  - `oe-training-default` (`/weka/oe-training-default`)
  - `oe-adapt-default` (`/weka/oe-adapt-default`)
  - `oe-eval-default` (`/weka/oe-eval-default`)
  - `climate-default` (`/weka/climate-default`)
  - `prior-default` (`/weka/prior-default`)
- `--dataset 'name:/mount'` -- attach Beaker dataset (rarely needed; prefer Weka for data)
- `-m, --mount 'host:target'` -- mount host directory
- `-u, --upload 'local:remote'` -- upload local files
- `--env 'KEY=VALUE'` -- set environment variables
- `--env-secret 'NAME=SECRET'` -- env vars from Beaker secrets

**Distributed / multi-node:**

- `--replicas INT` -- number of replicas
- `--torchrun` -- auto-configure torchrun (sets leader-selection, host-networking, propagate-failure, synchronized-start-timeout)
- `--leader-selection` -- designate first replica as leader
- `--host-networking` -- enable inter-node communication
- `--propagate-failure` -- stop all replicas if one fails
- `--synchronized-start-timeout TEXT` -- wait for all replicas to be ready

**Task:**

- `--priority [low|normal|high|urgent|immediate]` -- `normal` is default. `low` runs preemptible on any cluster (not restricted by budget). Never use `high` or `urgent` without asking the user first.
- `--preemptible / --not-preemptible`
- `--retries INT`
- `--task-timeout TEXT` -- e.g. `24h`

**Python:**

- `--install TEXT` -- override install command
- `--no-python` -- skip Python setup
- `--system-python` -- use image's Python

**Python uv settings:**

- `--uv-extra TEXT` -- install optional dependency extra (repeatable, e.g. `--uv-extra=gpu --uv-extra=dev`)
- `--uv-all-extras` -- install all extras (default when no `--uv-extra` is specified)
- `--uv-no-extras` -- install with no extras
- `--uv-torch-backend TEXT` -- PyTorch backend (e.g. `cu129`, `cpu`, `auto`)
- `--uv-venv TEXT` -- path to an existing venv on the image

### Common patterns

**Single GPU training:**

```bash
gantry run --gpus=1 --gpu-type=h100 --budget=ai2/BUDGET \
  -- python train.py --config config.yaml
```

**Multi-GPU single node:**

```bash
gantry run --gpus=8 --gpu-type=h100 --cluster=ai2/jupiter \
  -- torchrun --nproc-per-node=8 train.py
```

**Multi-node with --torchrun (recommended):**

```bash
gantry run --gpus=8 --gpu-type=h100 --replicas=4 --torchrun \
  -- python -m my_training_module
```

**With Weka storage (reading data + saving checkpoints):**

```bash
gantry run --gpus=8 \
  --weka='oe-training-default:/weka/oe-training-default' \
  -- python train.py \
    --data-dir /weka/oe-training-default/data/my-dataset \
    --checkpoint-dir /weka/oe-training-default/checkpoints/my-run
```

**Multiple Weka mounts:**

```bash
gantry run --gpus=8 \
  --weka='oe-training-default:/weka/oe-training-default' \
  --weka='oe-eval-default:/weka/oe-eval-default' \
  -- python train.py
```

**Preemptible with retries:**

```bash
gantry run --preemptible --retries=3 --gpus=8 \
  -- python train.py
```

**With specific uv extras (e.g. `[gpu,dev]` from pyproject.toml):**

```bash
gantry run --gpus=8 \
  --uv-extra=gpu --uv-extra=dev --uv-torch-backend=cu129 \
  -- python train.py
```

**With no extras (only core deps):**

```bash
gantry run --uv-no-extras -- python eval.py
```

**Custom install:**

```bash
gantry run \
  --install='uv pip install . torch --torch-backend=cu129' \
  -- python train.py
```

**Dry run to inspect spec:**

```bash
gantry run --dry-run --save-spec=spec.yaml --gpus=8 -- python train.py
```

## Docker images

The default gantry image (`petew/gantry`) works for most Python jobs. When a specific CUDA or PyTorch version is needed, use Ai2's pre-built images from [allenai/docker-images](https://github.com/allenai/docker-images/blob/main/cuda/README.md).

To check the latest available images, run:

```bash
gh api repos/allenai/docker-images/contents/cuda/README.md -q '.content' | base64 -d
```

Common images (Beaker names, use with `--beaker-image`):

| Image | Description |
| ----- | ----------- |
| `ai2/cuda12.8-ubuntu22.04-torch2.6.0` | CUDA 12.8, PyTorch 2.6. Default for Beaker sessions. |
| `ai2/cuda12.8-ubuntu22.04-torchnightly` | Torch nightly (2.8.0dev). Better B200 support. |
| `ai2/cuda12.8-ubuntu22.04-notorch` | CUDA 12.8, no PyTorch. Smaller base image. |
| `ai2/cuda12.8-dev-ubuntu22.04-torchxxx` | CUDA 12.8 with dev tools (`nvcc`). Much larger. |

These images ship with both `conda` and `uv` preinstalled.

**Using a custom image with gantry:**

```bash
gantry run --beaker-image=ai2/cuda12.8-ubuntu22.04-torch2.6.0 --system-python \
  --gpus=8 -- python train.py
```

When the user needs a non-default image (specific CUDA version, torch nightly, no-torch base, or dev tools), fetch the latest list from the repo above and suggest the best match.

## beaker session create

For interactive sessions (SSH access to a GPU node).

```bash
beaker session create [flags] [-- command...]
```

### Key flags

- `-w, --workspace TEXT`
- `--budget TEXT`
- `--gpus INT` -- number of GPUs (default: none)
- `-i, --image TEXT` -- base Docker or Beaker image
- `--cluster TEXT` -- target cluster(s)
- `--cpus FLOAT`, `--memory TEXT`, `--shared-memory TEXT`
- `--env KEY=VALUE` -- environment variables
- `--secret-env KEY=SECRET` -- secrets as env vars
- `-n, --name TEXT`
- `--priority [low|normal|high|urgent|immediate]`
- `--timeout TEXT` -- max duration (e.g. `2h`)
- `-d, --detach` -- don't attach to session
- `--bare` -- skip home directory mount, run as root
- `--port TEXT` -- expose TCP ports (e.g. `8080:8080`)

### Example

```bash
beaker session create --gpus=1 --workspace=ai2/my-workspace --budget=ai2/BUDGET
```

## Monitoring and management

**Find GPUs:**

```bash
gantry find-gpus                    # clusters with free GPUs
gantry find-gpus --gpu-type h100    # filter by type
gantry find-gpus --all              # include fully occupied clusters
```

**List jobs:**

```bash
gantry list --me                    # your recent experiments
gantry list --status=running        # running only
gantry list --limit=20              # more results
```

**Follow logs:**

```bash
gantry follow --latest              # latest running job
gantry follow WORKLOAD_ID           # specific job
```

**Download logs:**

```bash
gantry logs WORKLOAD_ID             # print to stdout
gantry logs WORKLOAD_ID -o ./logs/  # save to directory
gantry logs WORKLOAD_ID --tail=100  # last 100 lines
```

**Stop jobs:**

```bash
gantry stop --latest --yes
gantry stop WORKLOAD_ID
```

**Open in browser:**

```bash
gantry open WORKLOAD_ID
```

## Beaker data management

**Datasets:**

```bash
beaker dataset create --name my-data --workspace ai2/ws ./local-dir  # upload
beaker dataset fetch -o ./output my-data                             # download
beaker dataset ls my-data                                            # list files
```

**Secrets:**

```bash
beaker secret write -w ai2/ws MY_SECRET "secret-value"
beaker secret list -w ai2/ws
# Note: reading secret values (beaker secret read) is not allowed
```

**Images:**

```bash
beaker image create --name my-image --workspace ai2/ws ./Dockerfile
```

## Cluster inspection

```bash
beaker cluster list --org ai2
beaker cluster nodes ai2/jupiter
beaker cluster usage ai2/jupiter
beaker cluster free-slots ai2/jupiter
```

## Environment variables available in jobs

| Variable | Description |
|----------|-------------|
| `RESULTS_DIR` | Output directory (default `/results`) |
| `BEAKER_REPLICA_COUNT` | Total replicas |
| `BEAKER_REPLICA_RANK` | This replica's rank (0-indexed) |
| `BEAKER_ASSIGNED_GPU_COUNT` | GPUs on this replica |
| `BEAKER_LEADER_REPLICA_HOSTNAME` | Leader hostname (distributed) |
| `BEAKER_WORKLOAD_ID` | Workload identifier |

## Important notes

- Gantry requires your code to be committed and pushed to GitHub (it clones the repo via GitHub on the remote machine). Use `--allow-dirty` to skip the dirty-workdir check, but unpushed changes still won't be available on the remote.
- Results written to `/results` (or `$RESULTS_DIR`) are persisted as a Beaker dataset. This is the only typical use of Beaker datasets.
- For reading training data and saving checkpoints, use Weka mounts (`--weka`), not Beaker datasets. Weka is a high-performance shared filesystem available on Ai2 clusters. Ask the user which Weka bucket to use if they need data or checkpoint storage.
- Weka is also accessible via S3-compatible interface from outside the cluster:

  ```bash
  aws s3 cp --endpoint-url https://weka-aus.beaker.org:9000 's3://BUCKET/path/to/file' .
  aws s3 ls --endpoint-url https://weka-aus.beaker.org:9000 's3://BUCKET/path/'
  ```

- Default Python manager is `uv`; use `--python-manager=conda` for conda
- When the user doesn't specify a cluster, ask them which cluster/GPU type they want
- When the user doesn't specify a budget, ask them for it -- it is required
- The current Beaker username can be retrieved with `beaker account whoami`. When the user doesn't specify a workspace, default to `ai2/<username>`.
- Do NOT use `--show-logs` or `--timeout=-1` with `gantry run` -- these block the session waiting for the job to finish. Instead, launch with `--timeout=0` (the default) and use `gantry list`, `gantry follow`, and `gantry logs` after the fact to check status and retrieve output.
- Priority guidance: `normal` is the default but is restricted by budget allocation. `low` is useful because it can run preemptible jobs on any cluster regardless of budget. Always ask the user before setting `high` or `urgent` priority.
- Always confirm the command with the user before running `gantry run` or `beaker session create`
- After launching a job, always return the Beaker experiment URL to the user (e.g. `https://beaker.org/ex/...`)
- Use `--dry-run` first if the user seems uncertain about the configuration

## Documentation references

For additional details beyond this skill, consult these sources:

- **Gantry README**: `gh api repos/allenai/beaker-gantry/contents/README.md -q '.content' | base64 -d`
- **Beaker CLI help**: `beaker --help`, `beaker <command> --help`, `beaker <command> <subcommand> --help`
- **Gantry CLI help**: `gantry --help`, `gantry run --help`
- **Docker images**: `gh api repos/allenai/docker-images/contents/cuda/README.md -q '.content' | base64 -d`
- **Beaker docs**: <https://beaker-docs.apps.allenai.org> (fetchable via WebFetch)
- **Beaker Python client docs**: <https://beaker-py-docs.allen.ai> (fetchable via WebFetch)
- **Gantry repo**: <https://github.com/allenai/beaker-gantry>
- **Beaker repo**: <https://github.com/allenai/beaker>
