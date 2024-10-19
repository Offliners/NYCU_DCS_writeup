.PHONY:syn syn_dv read_dv_rtl read_ddc vcs_rtl vcs_gate irun_rtl irun_gate xrun_rtl xrun_gate nWave verdi_rtl verdi_gate clean

######################################
# Set your desired file names
######################################
top_design=BCD
source_file="filelist.f"	# Name of your source file
output_file="simv"      	# Desired output simulation file name
log_file="vcs.log"      	# Desired log file name
syn_tcl="syn.tcl"       	# Name of your synthesis tcl file
syn_log="syn.log"       	# Name of your synthesis log file
pt_tcl="pt.tcl"       	# Name of your synthesis tcl file
pt_log="pt.log"       	# Name of your synthesis log file


######################################
# Default Setting
######################################
num_CPU_cores=4               # Maximum Number of CPU that used for simulation/synthesis
TIMESCALE=-timescale=1ns/1fs
TIMESCALE1=-timescale 1ns/1fs
VERDI=/usr/cad/synopsys/verdi/2022.06/
DW_SIM=/usr/cad/synopsys/synthesis/cur/dw/sim_ver/
TSMC13_SIM=./TSMC_013/Verilog/tsmc13_neg.v
TSMC13_IO_SIM=./TSMC_013/Verilog/tpz013g3.v


# =====================================
# ============== irun =================
# =====================================
IRUN_RTL_SIM = irun -f ${source_file} \
	-incdir ${DW_SIM} \
	-loadpli1 debpli:novas_pli_boot \
	-debug \
	-notimingchecks \
	-define RTL

IRUN_RTL_SIM_CUST = irun -f ${source_file} \
	-incdir ${DW_SIM} \
	-loadpli1 debpli:novas_pli_boot \
	-debug \
	-notimingchecks \
	-define RTL \
	-define CUSTOM

IRUN_GATE_SIM = irun -f ${source_file} \
	-override_precision \
	${TIMESCALE1} \
	-sdf_precision 1fs \
	-v ${TSMC13_SIM} \
	-loadpli1 debpli:novas_pli_boot \
	-debug \
	-define GATE

IRUN_GATE_SIM_CUST = irun -f ${source_file} \
	-override_precision \
	${TIMESCALE1} \
	-sdf_precision 1fs \
	-v ${TSMC13_SIM} \
	-loadpli1 debpli:novas_pli_boot \
	-debug \
	-define GATE \
	-define CUSTOM


# =====================================
# ============= verdi =================
# =====================================
nWave_ON = nWave -ssf *.vcd

VERDI_RTL_ON = verdi -ssf *.vcd \
	-sv \
	-f ${source_file} \
    	-nologo           \
	+define+RTL	  \
	+v2k \
	-autoalias

VERDI_GATE_ON = verdi -ssf *.vcd \
	-sv \
	-f ${source_file} \
    	-nologo           \
	+define+GATE	  \
	+v2k \
	-autoalias


# =====================================
# ========== Design Compiler ==========
# =====================================
DC_shell = dcnxt_shell -f ${syn_tcl} \
	-x "set_host_options -max_cores ${num_CPU_cores}" \
    -output_log_file ${syn_log}


# =====================================	
# ============= clean =================
# =====================================
clean_irun = rm -rf *.vcd *.fsdb *.sdf.X ./INCA_libs *.history *.log
clean_verdi = rm -rf ./nWaveLog ./verdiLog *.conf *.rc *.log
clean_syn = rm -rf ./Netlist/*.* ./Report/*.* *.log alib* *.svf dwsvf* *.ddc *.pvl *.syn *.mr
# =====================================

irun_rtl:
	${IRUN_RTL_SIM}

irun_rtl_cust:
	${IRUN_RTL_SIM_CUST}

irun_gate:
	${IRUN_GATE_SIM}

irun_gate_cust:
	${IRUN_GATE_SIM_CUST}

syn:
	mkdir -p ./Netlist/
	mkdir -p ./Report/
	${DC_shell}

nWave:
	${nWave_ON}

verdi_rtl:
	${VERDI_RTL_ON}

verdi_gate:
	${VERDI_GATE_ON}

clean:
	${clean_irun}
	${clean_verdi}
	${clean_syn}
	${clean_power}