import random
from typing import List
from argparse import ArgumentParser, Namespace

config = {
     # num of testcase
    'PATTERN_NUM': 1000,

    # Random seed
    'seed': 0,

    # Number of master
    'master_num': 2,

    # Boundary of operation time
    'op_lower': 3,
    'op_upper': 100,

    # Boundary of data (0d ~ 127d)
    'data_lower': 0,
    'data_upper': 127,
}

random.seed(config['seed'])

def parse_args() -> Namespace:
    parser = ArgumentParser(description='DCSLab Lab05 testdata generator')

    args = parser.parse_args()
    return args


def int2bin(n: int, width: int) -> str:
    return format(n, 'b').zfill(width)


def gen_test_data(input_file_path: str, output_file_path: str) -> None:    
    pIFile = open(input_file_path, 'w')
    # pOFile = open(output_file_path, 'w')

    valid = '1'
    invalid = '0'

    PATTERN_NUM = config['PATTERN_NUM']
    pIFile.write(f"{PATTERN_NUM}\n")
    for _ in range(PATTERN_NUM):
        master = random.randint(0, config['master_num'])
        master_bin = int2bin(master, 2)
        pIFile.write(f"{master_bin} ")

        for i in range(config['master_num']):
            data = random.randint(config['data_lower'], config['data_upper'])
            if master_bin[i] == valid:
                pIFile.write(f"{valid} ")
            else:
                pIFile.write(f"{invalid} ")
            
            data_bin = int2bin(data, 8)
            pIFile.write(f"{data_bin} ")
        
        pIFile.write("\n")
    
    pIFile.close()
    # pOFile.close()


def main(args: Namespace) -> None:
    gen_test_data("input.txt", "output.txt")


if __name__ == '__main__':
    args = parse_args()
    main(args)