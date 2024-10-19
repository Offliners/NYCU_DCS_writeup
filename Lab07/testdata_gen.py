import random
import copy
from fxpmath import Fxp
from bitstring import BitArray
from typing import List
from argparse import ArgumentParser, Namespace

config = {
     # num of testcase
    'PATTERN_NUM': 1000,

    # Random seed
    'seed': 0,

    # Matrix size
    'row_size': 4,
    'col_size': 4,

    # Boundary of input value (-1d ~ 1d)
    'num_lower': -1,
    'num_upper': 1
}

random.seed(config['seed'])

dct_mat = [
    [0.5   , 0.5    , 0.5    , 0.5],
    [0.6533, 0.2706 , -0.2706, -0.6533],
    [0.5   , -0.5   , -0.5   , 0.5],
    [0.2706, -0.6533, 0.6533 , -0.2706]
]

def parse_args() -> Namespace:
    parser = ArgumentParser(description='DCSLab Lab07 testdata generator')

    args = parser.parse_args()
    return args


def float_to_fixed_point_bin(num: float, n_word: int = 8, n_frac: int = 7, n_int: int = 0) -> str:
    return Fxp(
        val=num, 
        signed=True, 
        n_word=n_word, 
        n_frac=n_frac,
        n_int=n_int).bin(frac_dot=False)


def bin2int(n: str) -> int:
    return BitArray(bin=n).int


def int2bin(n: int, bin_width: int = 10) -> str:
    if n >= 0:
        return format(n, 'b').zfill(bin_width)
    else:
        temp = format(n, 'b').zfill(bin_width)[1:]
        temp = '1' + temp
        return temp


def convert_float_mat_to_int(mat: List[List[float]]) -> List[List[int]]:
    mat_copy = copy.deepcopy(mat)
    for i in range(config['row_size']):
        for j in range(config['col_size']):
            mat_copy[i][j] = bin2int(float_to_fixed_point_bin(mat[i][j]))
    
    return mat_copy


def sol(input_mat: List[List[float]]) -> List[List[float]]:
    result_mat_1 = [
        [0, 0, 0, 0],
        [0, 0, 0, 0],
        [0, 0, 0, 0],
        [0, 0, 0, 0]
    ]
    result_mat_2 = copy.deepcopy(result_mat_1)

    dct_mat_int = convert_float_mat_to_int(dct_mat)
    input_mat_int = convert_float_mat_to_int(input_mat)

    for i in range(config['row_size']):
        for j in range(config['col_size']):
            for k in range(config['col_size']):
                result_mat_1[i][j] += dct_mat_int[i][k] * input_mat_int[k][j]
            
            result_mat_1[i][j] //= 128

    for i in range(config['row_size']):
        for j in range(config['col_size']):
            for k in range(config['col_size']):
                result_mat_2[i][j] += result_mat_1[i][k] * dct_mat_int[j][k]

            result_mat_2[i][j] //= 128

    return result_mat_2 


def gen_test_data(input_file_path: str, output_file_path: str) -> None:    
    pIFile = open(input_file_path, 'w')
    pOFile = open(output_file_path, 'w')

    PATTERN_NUM = config['PATTERN_NUM']
    pIFile.write(f"{PATTERN_NUM}\n")

    for _ in range(PATTERN_NUM):
        input_mat = []

        for _ in range(config['row_size']):
            row = []
            for _ in range(config['col_size']):
                num = random.uniform(config['num_lower'], config['num_upper'])
                row.append(num)
                pIFile.write(f"{bin2int(float_to_fixed_point_bin(num))} ")
            
            input_mat.append(row)
        
        pIFile.write("\n")
         
        result_mat = sol(input_mat)
        for i in range(config['row_size']):
            for j in range(config['col_size']):
                pOFile.write(f"{result_mat[i][j]} ")

        pOFile.write("\n")

    pIFile.close()
    pOFile.close()


def main(args: Namespace) -> None:
    gen_test_data("input.txt", "output.txt")


if __name__ == '__main__':
    args = parse_args()
    main(args)