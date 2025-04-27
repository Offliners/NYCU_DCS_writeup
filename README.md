# NYCU Digital Circuit System - writeup
This repository contained my designs (System Verilog) and patterns (System Verilog & Python3) is used to practice the homeworks and labs from Prof. Tien-Hsuan Chang's Digital Circuit System (DCS) course (2022 ~ 2024) at NYCU.

## Outline

### 2023
<details open>
<summary>More</summary>

| #     | Topic                                                    | 01_RTL | 02_SYN | 03_GATE |
| ----- | -------------------------------------------------------- | ------ | ------ | ------- |
| Lab01 | [Binary-Coded Decimal](./2023/Lab01/DCS_Lab01.pdf)       | ✅      | ✅      | ✅       |
| Lab02 | [Merge Sort](./2023/Lab02/DCS_Lab02.pdf)                 | ✅      | ✅      | ✅       |
| Lab03 | [Frequency Divider](./2023/Lab03/DCS_Lab03.pdf)          | ✅      | ✅      | ✅       |
| Lab04 | [Sequential Circuit](./2023/Lab04/DCS_Lab04.pdf)         | ✅      | ✅      | ✅       |
| Lab05 | [AHB Interconnect](./2023/Lab05/DCS_Lab05.pdf)           | ✅      | ✅      | ✅       |
| Lab06 | [Pattern](./2023/Lab06/DCS_Lab06.pdf)                    | ✅      | ❌      | ❌       |
| Lab07 | [Matrix Multiplication](./2023/Lab07/DCS_Lab07.pdf)      | ✅      | ✅      | ✅       |
| Lab08 | [Floating Point Computation](./2023/Lab08/DCS_Lab08.pdf) | ✅      | ✅      | ✅       |
| Lab09 | [Pipeline](./2023/Lab09/DCS_Lab09.pdf)                   | ✅      | ✅      | ✅       |
| Lab10 | [Clock Domain Crossing](./2023/Lab10/DCS_Lab10.pdf)      | ✅      | ✅      | ✅       |
| HW01  | [Simplified Mahjong Judgment](./2023/HW01/DCS_HW01.pdf)  | ✅      | ✅      | ✅       |
| HW02  | [Simplified I2C](./2023/HW02/DCS_HW02.pdf)               | ✅      | ✅      | ✅       |
| HW03  | [Traffic Light Controller](./2023/HW03/DCS_HW03.pdf)     |        |        |         |
| HW04  | [Histogram Equalizer](./2023/HW04/DCS_HW04.pdf)          |        |        |         |
| HW05  | [MIPS CPU](./2023/HW05/DCS_HW05.pdf)                     |        |        |         |
| OT    | [Systolic Array](./2023/OT/OT.pdf)                       |        |        |         |
| FP    | [Simple CNN](./2023/Final/DCS_Final_Project.pdf)         |        |        |         |

</details>

## Design Flow
```mermaid
%%{
  init: {
    'theme': 'neutral',
    'themeVariables': {
      'textColor': '#000000',
      'noteTextColor' : '#000000',
      'fontSize': '20px'
    }
  }
}%%

flowchart LR
    b0[                  ] --- b2[ ] --- b4[ ] --- DesignFlow --- b1[ ] --- b3[ ] --- b5[                  ]
    style b0 stroke-width:0px, fill: #FFFFFF00, color:#FFFFFF00
    style b1 stroke-width:0px, fill: #FFFFFF00
    style b2 stroke-width:0px, fill: #FFFFFF00
    style b3 stroke-width:0px, fill: #FFFFFF00
    style b4 stroke-width:0px, fill: #FFFFFF00
    style b5 stroke-width:0px, fill: #FFFFFF00, color:#FFFFFF00

    linkStyle 0 stroke-width:0px
    linkStyle 1 stroke-width:0px
    linkStyle 2 stroke-width:0px
    linkStyle 3 stroke-width:0px
    linkStyle 4 stroke-width:0px
    linkStyle 5 stroke-width:0px
    
    subgraph DesignFlow
    direction TB
    style DesignFlow fill:#ffffff00, stroke-width:0px

    direction TB
        A[Spec Development System models]
        A --> B[RTL and Verification]
        B --> C[Synthesis]
        C --> D[Timing Verificaiton]
        D --> E[Gate Level Simulation]
        E --> F[Finish]
        style A fill:#74c2b5,stroke:#000000,stroke-width:4px
        style B fill:#f8cecc,stroke:#000000,stroke-width:4px
        style C fill:#fff2cc,stroke:#000000,stroke-width:4px
        style D fill:#cce5ff,stroke:#000000,stroke-width:4px
        style E fill:#fa6800,stroke:#000000,stroke-width:4px
        style F fill:#ff6666,stroke:#000000,stroke-width:4px
    end
```

## Usage
```shell
# RTL & Verification
$ make irun_rtl

# Install Python3 thirdparty library (Optional)
$ pip3 install -r requirements.txt

# Use Python3 to generate custom testcase (Optional)
$ python3 testdata_gen.py

# RTL & Verification with custom testcase
$ make irun_rtl_cust

# Synthesis & STA report
$ make syn

# Gate level simulation
$ make irun_gate

# Gate level simulation with custom testcase
$ make irun_gate_cust

# View waveform
$ make nWave

# Debug design and check critical path
$ make verdi_rtl
$ make verdi_gate

# Clean output file
$ make clean
```

## Tool Chain
* Cadence irun
* Synopsys VCS
* Synopsys Design Compiler
* Synopsys Verdi
* Process : `UMC 0.18µm` (Not provide in this repository)
