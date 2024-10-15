# NYCU Digital Circuit System (2023) - writeup
This repository contained my designs and patterns is used to practice the homeworks and labs from Prof. Tien-Hsuan Chang's Digital Circuit System (DCS) course (2023) at NYCU.

## Outline
### Homeworks
| HW#  | Topic                       | Area | Slack |
| ---- | --------------------------- | ---- | ------ |
| HW01 | Simplified Mahjong Judgment |      |        |
| HW02 | Simplified I2C              |      |        |
| HW03 | Traffic Light Controller    |      |        |
| HW04 | Histogram Equalizer         |      |        |
| HW05 | MIPS CPU                    |      |        |

### Labs
| Lab#  | Topic                                         | Area                                                      | Timimg                                               |
| ----- | --------------------------------------------- | --------------------------------------------------------- | ---------------------------------------------------- |
| Lab01 | [Binary-Coded Decimal](./Lab01/DCS_Lab01.pdf) | ![area](https://img.shields.io/badge/560.142001-blue.svg) | ![slack](https://img.shields.io/badge/7.39-blue.svg) |
| Lab02 | Merge Sort                                    |                                                           |                                                      |
| Lab03 | Frequency Divider                             |                                                           |                                                      |
| Lab04 | Sequential Circuit                            |                                                           |                                                      |
| Lab05 | AHB Interconnect                              |                                                           |                                                      |
| Lab06 | Pattern                                       |                                                           |                                                      |
| Lab07 | Matrix Multiplication                         |                                                           |                                                      |
| Lab08 | Floating Point Computation                    |                                                           |                                                      |
| Lab09 | Pipeline                                      |                                                           |                                                      |
| Lab10 | Clock Domain Crossing                         |                                                           |                                                      |
### Final Project
* Simple CNN : [[spec](./Final/DCS_Final_Project.pdf)]

## Usage
```shell
# RTL & Verification
$ make irun_rtl

# Use Python3 to generate custom testcase 
$ python3 testdata_gen.py

# RTL & Verification with custom testcase
$ make irun_rtl_cust

# Synthesis & STA
$ make syn

# Gate level simulation
$ make irun_gate

# Gate level simulation with custom testcase
$ make irun_gate_cust

# View waveform
$ make nWave

# Debug design and critical path
$ make verdi_rtl
$ make verdi_gate

# Clean output file
$ make clean
```

## Tool Chain
* Python3
* Cadence irun
* Synopsys Design Compiler
    * cell : `TSMC 0.13um`
* Synopsys Verdi

## References
* Course video playlist (2023): [Link](https://www.youtube.com/playlist?list=PLCUEmRsKEgZ4p8HK5IXMrohliNuRttqpt)