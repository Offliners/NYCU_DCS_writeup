import random
from typing import List
from argparse import ArgumentParser, Namespace

config = {
     # num of testcase
    'PATTERN_NUM': 1000,

    # Random seed
    'seed': 0,

    # Boundary of idle time
    'idle_lower': 1,
    'idle_upper': 10,

    # Boundary of operation time
    'op_lower': 3,
    'op_upper': 100,

    # Boundary of input
    'num_lower': 1,
    'num_upper': 15,
}

random.seed(config['seed'])

def parse_args() -> Namespace:
    parser = ArgumentParser(description='DCSLab Lab04 testdata generator')

    args = parser.parse_args()
    return args


def sol(input: List[List[int]]) -> List[List[int]]:
    output = []
    data = []
    out_valid, out_data = 0, 0
    for in_valid, in_data in input:
        if in_valid:
            data.append(in_data)
        
        if not in_valid or len(data) < 3:
            out_valid = 0
        else:
            out_valid = 1

        if out_valid:
            in1, in2, in3 = data[-3:]
            if (in1 < in2 and in2 < in3) or (in1 > in2 and in2 > in3):
                out_data = 1
            else:
                out_data = 0
        else:
            out_data = 0

        output.append([out_valid, out_data])
    
    return output


def gen_test_data(input_file_path: str, output_file_path: str) -> None:    
    pIFile = open(input_file_path, 'w')
    pOFile = open(output_file_path, 'w')

    PATTERN_NUM = config['PATTERN_NUM']
    pIFile.write(f"{PATTERN_NUM}\n")
    for _ in range(PATTERN_NUM):
        idle_time = random.randint(config['idle_lower'], config['idle_upper'])
        pIFile.write(f"{idle_time}\n")

        input = []
        for _ in range(idle_time):
            in_valid, in_data = 0, 0
            input.append([in_valid, in_data])
            pIFile.write(f"{in_valid} {in_data}\n")

        op_time = random.randint(config['op_lower'], config['op_upper']) 
        pIFile.write(f"{op_time}\n")
        for i in range(op_time):
            if i == op_time - 1:
                in_valid, in_data = 0, 0
                input.append([in_valid, in_data])
            else:
                num = random.randint(config['num_lower'], config['num_upper'])
                in_valid, in_data = 1, num
                input.append([in_valid, in_data])
            
            pIFile.write(f"{in_valid} {in_data}\n")
        
        ans = sol(input)
        for out_valid, out_data in ans:
            pOFile.write(f'{out_valid} {out_data}\n')
    
    pIFile.close()
    pOFile.close()


def main(args: Namespace) -> None:
    gen_test_data("input.txt", "output.txt")


if __name__ == '__main__':
    args = parse_args()
    main(args)