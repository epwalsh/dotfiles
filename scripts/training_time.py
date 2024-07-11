#!/user/bin/env python

"""
Calculate the time remaining of a run to reach a certain number of tokens given its TPS
per GPU and the number of GPUs.
"""

import argparse
from datetime import timedelta


def get_time_remaining(
    *,
    tps_per_gpu: float,
    num_gpus: int,
    target_tokens: float,
    current_tokens: float = 0.0,
) -> timedelta:
    assert 0 < target_tokens, "`target_tokens` should be greater than 0"
    assert 0 <= current_tokens, "`current_tokens` should be non-negative"
    assert current_tokens < target_tokens
    tokens_remaining = target_tokens - current_tokens
    total_tps = tps_per_gpu * num_gpus
    seconds_remaining = int(tokens_remaining / total_tps)
    return timedelta(seconds=seconds_remaining)


def main():
    parser = argparse.ArgumentParser()

    parser.add_argument("-s", "--tps", type=float, required=True, help="TPS per GPU")
    parser.add_argument("-g", "--gpus", type=int, required=True, help="Number of GPUs")
    parser.add_argument(
        "-t", "--target", type=float, required=True, help="Target number of tokens"
    )
    parser.add_argument(
        "-c", "--current", type=float, required=True, help="Current number of tokens"
    )
    opts = parser.parse_args()

    time_remaining = get_time_remaining(
        tps_per_gpu=opts.tps,
        num_gpus=opts.gpus,
        target_tokens=opts.target,
        current_tokens=opts.current,
    )
    print(f"Time remaining: {time_remaining}")


if __name__ == "__main__":
    main()
