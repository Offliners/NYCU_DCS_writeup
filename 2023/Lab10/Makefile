######################################
# Set your desired file names
######################################
top_design=CDC
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
TIMESCALE=-timescale 1ns/1fs
DW_SIM=/usr/cad/synopsys/synthesis/cur/dw/sim_ver/
UMC018_SIM=~/iclabTA01/umc018/Verilog/umc18_neg.v


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
	${TIMESCALE} \
	-sdf_precision 1fs \
	-v ${UMC018_SIM} \
	-loadpli1 debpli:novas_pli_boot \
	-debug \
	-define GATE

IRUN_GATE_SIM_CUST = irun -f ${source_file} \
	-override_precision \
	${TIMESCALE} \
	-sdf_precision 1fs \
	-v ${UMC018_SIM} \
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
clean_vcs = rm -rf *.fsdb ./csrc *.log simv* *.sdf.X *.key
clean_irun = rm -rf *.vcd *.fsdb *.sdf.X ./INCA_libs *.history *.log
clean_verdi = rm -rf ./nWaveLog ./verdiLog *.conf *.rc *.log *.sdf
clean_syn = rm -rf ./Report *.log alib* *.svf dwsvf* *.ddc *.pvl *.syn *.mr *_SYN.v *_SYN.sdc *_pt.sdc
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
	mkdir -p ./Report/
	${DC_shell}

nWave:
	${nWave_ON}

verdi_rtl:
	${VERDI_RTL_ON}

verdi_gate:
	${VERDI_GATE_ON}

clean:
	${clean_vcs}
	${clean_irun}
	${clean_verdi}
	${clean_syn}