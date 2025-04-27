import random
from typing import List
from argparse import ArgumentParser, Namespace

config = {
     # num of testcase
    'PATTERN_NUM': 1000,

    # Random seed
    'seed': 0,

    # Boundary of mode
    'mode_lower': 0,
    'mode_upper': 1,

    # Boundary of input value (0d ~ 15d)
    'num_lower': 0,
    'num_upper': 15
}

random.seed(config['seed'])

def parse_args() -> Namespace:
    parser = ArgumentParser(description='DCSLab Lab10 testdata generator')

    args = parser.parse_args()
    return args


def int2bin(n: int, bin_width: int = 4) -> str:
    return format(n, 'b').zfill(bin_width)


def sol(mode: int, num_a: int, num_b: int) -> int:
    if mode:
        return num_a * num_b
    else:
        return num_a + num_b


def gen_test_data(input_file_path: str, output_file_path: str) -> None:    
    pIFile = open(input_file_path, 'w')
    pOFile = open(output_file_path, 'w')

    PATTERN_NUM = config['PATTERN_NUM']
    pIFile.write(f"{PATTERN_NUM}\n")
    for _ in range(PATTERN_NUM):
        mode = random.randint(config['mode_lower'], config['mode_upper'])
        num_a = random.randint(config['num_lower'], config['num_upper'])
        num_b = random.randint(config['num_lower'], config['num_upper'])
        pIFile.write(f"{mode} {int2bin(num_a)} {int2bin(num_b)}\n")
        ans = sol(mode, num_a, num_b)
        pOFile.write(f'{ans}\n')
    
    pIFile.close()
    pOFile.close()


def main(args: Namespace) -> None:
    gen_test_data("input.txt", "output.txt")


if __name__ == '__main__':
    args = parse_args()
    main(args)