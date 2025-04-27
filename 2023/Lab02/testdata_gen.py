import random
from typing import List
from argparse import ArgumentParser, Namespace

config = {
     # num of testcase
    'PATTERN_NUM': 1000,

    # Random seed
    'seed': 0,

    # Boundary of input value (0d ~ 63d)
    'num_lower': 0,
    'num_upper': 63
}

random.seed(config['seed'])

def parse_args() -> Namespace:
    parser = ArgumentParser(description='DCSLab Lab02 testdata generator')

    args = parser.parse_args()
    return args


def sol(nums: List[int]) -> int:
    nums_sorted = sorted(nums)
    
    return nums_sorted[2]


def gen_test_data(input_file_path: str, output_file_path: str) -> None:    
    pIFile = open(input_file_path, 'w')
    pOFile = open(output_file_path, 'w')

    PATTERN_NUM = config['PATTERN_NUM']
    pIFile.write(f"{PATTERN_NUM}\n")
    for _ in range(PATTERN_NUM):
        nums = [random.randint(config['num_lower'], config['num_upper']) for _ in range(5)]
        nums_str = [str(e) for e in nums]
        pIFile.write(f"{' '.join(nums_str)}\n")
        out_num = sol(nums)
        pOFile.write(f'{out_num}\n')
    
    pIFile.close()
    pOFile.close()


def main(args: Namespace) -> None:
    gen_test_data("input.txt", "output.txt")


if __name__ == '__main__':
    args = parse_args()
    main(args)