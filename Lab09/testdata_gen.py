import random
from typing import List
from argparse import ArgumentParser, Namespace

config = {
     # num of testcase
    'PATTERN_NUM': 1000,

    # Random seed
    'seed': 0,

    # Input num
    'input_num': 4,

    # Bit width of each input number
    'intput_bit_width': 47,

    # Bit width of each output number
    'output_bit_width': 96
}

random.seed(config['seed'])

def parse_args() -> Namespace:
    parser = ArgumentParser(description='DCSLab Lab09 testdata generator')

    args = parser.parse_args()
    return args


def bin2int(n: str) -> int:
    return int(n, 2)


def int2bin(n: int, bin_width: int) -> str:
    return format(n, 'b').zfill(bin_width)


def sol(nums_bin: List[str]) -> List[int]:
    num1, num2, num3, num4 = [bin2int(e) for e in nums_bin]
    ans = (num1 + num2) * (num3 + num4)
    
    return int2bin(ans, config['output_bit_width']) 


def gen_test_data(input_file_path: str, output_file_path: str) -> None:    
    pIFile = open(input_file_path, 'w')
    pOFile = open(output_file_path, 'w')

    PATTERN_NUM = config['PATTERN_NUM']
    pIFile.write(f"{PATTERN_NUM}\n")
    for _ in range(PATTERN_NUM):
        nums = []
        for _ in range(config['input_num']):
            zero_cnt = random.randint(0, config['intput_bit_width'])
            one_cnt = config['intput_bit_width'] - zero_cnt
            random_bin = '0' * zero_cnt + '1' * one_cnt
            nums.append(random_bin)

        pIFile.write(f'{" ".join(nums)}\n')
        ans = sol(nums)
        pOFile.write(f'{ans}\n')
    
    pIFile.close()
    pOFile.close()


def main(args: Namespace) -> None:
    gen_test_data("input.txt", "output.txt")


if __name__ == '__main__':
    args = parse_args()
    main(args)