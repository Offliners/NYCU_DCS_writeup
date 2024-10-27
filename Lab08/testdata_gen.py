import random
import struct
from argparse import ArgumentParser, Namespace

config = {
     # num of testcase
    'PATTERN_NUM': 1000,

    # Random seed
    'seed': 0,

    # Boundary of mode
    'mode_lower': 0,
    'mode_upper': 1,

    # Boundary of sign
    'sign_lower': 0,
    'sign_upper': 1,

    # Boundary of exponent
    'exp_lower': 120,
    'exp_upper': 135,

    # Boundary of fraction
    'frac_lower': 0,
    'frac_upper': 127
}

random.seed(config['seed'])

def parse_args() -> Namespace:
    parser = ArgumentParser(description='DCSLab Lab08 testdata generator')

    args = parser.parse_args()
    return args

def float_to_bfloat16(f: float) -> str:
    n = struct.unpack('>H', struct.pack('>f', f)[0:2])[0]
    return int2bin(n, 16)


def bfloat16_to_float(bf: str) -> float:
    return struct.unpack('>f', struct.pack('>H', int(bf, 2)) + b'\x00\x00')[0]


def sol(mode: int, in_a: str, in_b: str) -> str:
    a = bfloat16_to_float(in_a)
    b = bfloat16_to_float(in_b)
    if mode == 0:    
        c = a + b
    else:
        c = a * b

    return float_to_bfloat16(c)        


def int2bin(n: int, bin_width: int) -> str:
    return format(n, 'b').zfill(bin_width)


def gen_test_data(input_file_path: str, output_file_path: str) -> None:    
    pIFile = open(input_file_path, 'w')
    pOFile = open(output_file_path, 'w')

    PATTERN_NUM = config['PATTERN_NUM']
    pIFile.write(f"{PATTERN_NUM}\n")

    for _ in range(PATTERN_NUM):
        mode = random.randint(config['mode_lower'], config['mode_upper'])
        
        sign = random.randint(config['sign_lower'], config['sign_upper'])
        exp = random.randint(config['exp_lower'], config['exp_upper'])
        frac = random.randint(config['frac_lower'], config['frac_upper'])

        sign_bin = int2bin(sign, 1)
        exp_bin = int2bin(exp, 8)
        frac_bin = int2bin(frac, 7)

        in_a = sign_bin + exp_bin + frac_bin

        sign = random.randint(config['sign_lower'], config['sign_upper'])
        exp = random.randint(exp - 3, exp + 3)
        frac = random.randint(config['frac_lower'], config['frac_upper'])
        sign_bin = int2bin(sign, 1)
        exp_bin = int2bin(exp, 8)
        frac_bin = int2bin(frac, 7)

        in_b = sign_bin + exp_bin + frac_bin
        pIFile.write(f"{mode} {in_a} {in_b}\n")

        ans = sol(mode, in_a, in_b)
        pOFile.write(f"{ans}\n")

    pIFile.close()
    pOFile.close()


def main(args: Namespace) -> None:
    gen_test_data("input.txt", "output.txt")


if __name__ == '__main__':
    args = parse_args()
    main(args)