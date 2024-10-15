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
| Lab#  | Topic                                         | Design                     | Area        | Slack |
| ----- | --------------------------------------------- | -------------------------- | ----------- | ----- |
| Lab01 | [Binary-Coded Decimal](./Lab01/DCS_Lab01.pdf) | [BCD.sv](./Lab01/BCD.sv)   | 560.142001  | 7.39  |
| Lab02 | [Merge Sort](./Lab02/DCS_Lab02.pdf)           | [Sort.sv](./Lab02/Sort.sv) | 1568.397579 | 0.12  |
| Lab03 | Frequency Divider                             |                            |             |       |
| Lab04 | Sequential Circuit                            |                            |             |       |
| Lab05 | AHB Interconnect                              |                            |             |       |
| Lab06 | Pattern                                       |                            |             |       |
| Lab07 | Matrix Multiplication                         |                            |             |       |
| Lab08 | Floating Point Computation                    |                            |             |       |
| Lab09 | Pipeline                                      |                            |             |       |
| Lab10 | Clock Domain Crossing                         |                            |             |       |

### Final Project
* Simple CNN : [[spec](./Final/DCS_Final_Project.pdf)]

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