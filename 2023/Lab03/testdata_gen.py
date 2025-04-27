import random
from typing import List
from argparse import ArgumentParser, Namespace

config = {
     # num of testcase
    'PATTERN_NUM': 500,

    # Random seed
    'seed': 0
}

random.seed(config['seed'])

def parse_args() -> Namespace:
    parser = ArgumentParser(description='DCSLab Lab03 testdata generator')

    args = parser.parse_args()
    return args


def gen_test_data(input_file_path: str, output_file_path: str) -> None:    
    pIFile = open(input_file_path, 'w')
    pOFile = open(output_file_path, 'w')

    PATTERN_NUM = config['PATTERN_NUM']
    pIFile.write(f"{PATTERN_NUM}\n")

    clk2 = False
    freq = 4
    for i in range(PATTERN_NUM):
        if (i + 1) % (freq / 2) == 0:
            clk2 = not clk2
        
        if clk2:
            pOFile.write('1\n')
        else:
            pOFile.write('0\n')

    pIFile.close()
    pOFile.close()


def main(args: Namespace) -> None:
    gen_test_data("input.txt", "output.txt")


if __name__ == '__main__':
    args = parse_args()
    main(args)