import random
from typing import List
from argparse import ArgumentParser, Namespace

config = {
     # num of testcase
    'PATTERN_NUM': 1000,

    # Random seed
    'seed': 0,

    # Boundary of input value (0d ~ 511d)
    'num_lower': 0,
    'num_upper': 511
}

random.seed(config['seed'])

def parse_args() -> Namespace:
    parser = ArgumentParser(description='DCSLab Lab01 testdata generator')

    args = parser.parse_args()
    return args


def sol(num: int) -> List[int]:
    num_decimal = []
    num_decimal.append(int((num / 100) % 10))
    num_decimal.append(int((num / 10) % 10))
    num_decimal.append(int(num % 10))
    
    return num_decimal 


def gen_test_data(input_file_path: str, output_file_path: str) -> None:    
    pIFile = open(input_file_path, 'w')
    pOFile = open(output_file_path, 'w')

    PATTERN_NUM = config['PATTERN_NUM']
    pIFile.write(f"{PATTERN_NUM}\n")
    for _ in range(PATTERN_NUM):
        num = random.randint(config['num_lower'], config['num_upper'])
        pIFile.write(f"{num}\n")
        num_decimal = sol(num)
        out = [str(e) for e in num_decimal]
        pOFile.write(f'{" ".join(out)}\n')
    
    pIFile.close()
    pOFile.close()


def main(args: Namespace) -> None:
    gen_test_data("input.txt", "output.txt")


if __name__ == '__main__':
    args = parse_args()
    main(args)