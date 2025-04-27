import random
from typing import List
from argparse import ArgumentParser, Namespace

config = {
     # num of testcase
    'PATTERN_NUM': 1000,

    # Random seed
    'seed': 0,

    # Boundary of input value (0d ~ 15d)
    'num_lower': 0,
    'num_upper': 15
}

random.seed(config['seed'])

def parse_args() -> Namespace:
    parser = ArgumentParser(description='DCSLab Lab01 testdata generator')

    args = parser.parse_args()
    return args


def signed2unsigend(n: int, bitwidth: int = 4) -> int:
    return n & (1 << bitwidth) - 1


def sol(nums: List[int]) -> List[int]:
    ans = []

    in_num0, in_num1, in_num2, in_num3 = nums

    A = signed2unsigend(~in_num0 ^ in_num1)
    B = signed2unsigend(in_num1 | in_num3)
    C = signed2unsigend(in_num0 & in_num2)
    D = signed2unsigend(in_num2 ^ in_num3)

    AB = A + B
    CD = C + D

    if AB < CD:
        ans = [AB, CD]
    else:
        ans = [CD, AB]

    return ans 


def gen_test_data(input_file_path: str, output_file_path: str) -> None:    
    pIFile = open(input_file_path, 'w')
    pOFile = open(output_file_path, 'w')

    PATTERN_NUM = config['PATTERN_NUM']
    pIFile.write(f"{PATTERN_NUM}\n")
    for _ in range(PATTERN_NUM):
        nums = [random.randint(config['num_lower'], config['num_upper']) for _ in range(4)]
        nums_str = [str(e) for e in nums]
        pIFile.write(f'{" ".join(nums_str)}\n')
        ans = sol(nums)
        out = [str(e) for e in ans]
        pOFile.write(f'{" ".join(out)}\n')
    
    pIFile.close()
    pOFile.close()


def main(args: Namespace) -> None:
    gen_test_data("input.txt", "output.txt")


if __name__ == '__main__':
    args = parse_args()
    main(args)