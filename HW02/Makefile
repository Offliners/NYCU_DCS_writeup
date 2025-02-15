.PHONY:syn vcs_rtl vcs_rtl_cust vcs_gate vcs_gate_cust nWave verdi_rtl verdi_gate clean

######################################
# Set your desired file names
######################################
top_design=I2S
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

VERDI=/usr/cad/synopsys/verdi/
DW_SIM=/usr/cad/synopsys/synthesis/cur/dw/sim_ver/
UMC018_SIM=~/iclabTA01/umc018/Verilog/umc18_neg.v


# =====================================
# ============== VCS ==================
# =====================================
VCS_RTL_SIM = vcs ${TIMESCALE} \
    -j${num_CPU_cores} \
    -sverilog \
    +v2k \
    -full64 \
    -Mupdate \
    -R \
    -debug_access+all \
    -y ${DW_SIM} \
    +libext+.v \
    -f ${source_file} \
    -o ${output_file} \
    -l ${log_file} \
    -P ${VERDI}/share/PLI/VCS/linux64/novas.tab \
       ${VERDI}/share/PLI/VCS/linux64/pli.a \
    +define+RTL \
    +notimingchecks 
    
VCS_RTL_SIM_CUST = vcs ${TIMESCALE} \
    -j${num_CPU_cores} \
    -sverilog \
    +v2k \
    -full64 \
    -Mupdate \
    -R \
    -debug_access+all \
    -y ${DW_SIM} \
    +libext+.v \
    -f ${source_file} \
    -o ${output_file} \
    -l ${log_file} \
    -P ${VERDI}/share/PLI/VCS/linux64/novas.tab \
       ${VERDI}/share/PLI/VCS/linux64/pli.a \
    +define+RTL \
    +define+CUSTOM \
    +notimingchecks 


VCS_GATE_SIM = vcs ${TIMESCALE} \
    -j${num_CPU_cores} \
    -sverilog \
    +v2k \
    -full64 \
    -Mupdate \
    -R \
    -debug_access+all \
    -f ${source_file} \
    -o ${output_file} \
    -l ${log_file} \
    -P ${VERDI}/share/PLI/VCS/linux64/novas.tab \
       ${VERDI}/share/PLI/VCS/linux64/pli.a \
	  -v ${UMC018_SIM} \
    +define+GATE \
	  +neg_tchk 
     
     
VCS_GATE_SIM_CUST = vcs ${TIMESCALE} \
    -j${num_CPU_cores} \
    -sverilog \
    +v2k \
    -full64 \
    -Mupdate \
    -R \
    -debug_access+all \
    -f ${source_file} \
    -o ${output_file} \
    -l ${log_file} \
    -P ${VERDI}/share/PLI/VCS/linux64/novas.tab \
       ${VERDI}/share/PLI/VCS/linux64/pli.a \
	  -v ${UMC018_SIM} \
    +define+GATE \
    +define+CUSTOM \
	  +neg_tchk 


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
DC_shell = dc_shell -f ${syn_tcl} \
	-x "set_host_options -max_cores ${num_CPU_cores}" \
    -output_log_file ${syn_log}


# =====================================	
# ============= clean =================
# =====================================
clean_vcs = rm -rf *.fsdb ./csrc *.log simv* *.sdf.X *.key
clean_verdi = rm -rf ./nWaveLog ./verdiLog *.conf *.rc *.log
clean_syn = rm -rf ./Report *.log alib* *.svf dwsvf* *.ddc *.pvl *.syn *.mr *_SYN.v *.sdf
# =====================================

vcs_rtl:
	${VCS_RTL_SIM}
 
vcs_rtl_cust:
	${VCS_RTL_SIM_CUST}

vcs_gate:
	${VCS_GATE_SIM}
 
vcs_gate_cust:
	${VCS_GATE_SIM_CUST}

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
	${clean_verdi}
	${clean_syn}