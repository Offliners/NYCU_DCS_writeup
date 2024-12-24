.PHONY:syn syn_dv read_dv_rtl read_ddc vcs_rtl vcs_gate irun_rtl irun_gate xrun_rtl xrun_gate nWave verdi_rtl verdi_gate clean

######################################
# Set your desired file names
######################################
source_file="filelist.f"	# Name of your source file
source_file1="filelist1.f"	# Name of your source file1
source_file2="filelist2.f"	# Name of your source file2
source_file3="filelist3.f"	# Name of your source file3
source_file4="filelist4.f"	# Name of your source file4
source_file5="filelist5.f"	# Name of your source file5
source_file6="filelist6.f"	# Name of your source file6
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

# =====================================
# ============== irun =================
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
    +define+CUSTOM \
    +notimingchecks 
 
VCS_RTL_SIM1 = vcs ${TIMESCALE} \
    -j${num_CPU_cores} \
    -sverilog \
    +v2k \
    -full64 \
    -Mupdate \
    -R \
    -debug_access+all \
    -y ${DW_SIM} \
    +libext+.v \
    -f ${source_file1} \
    -o ${output_file} \
    -l ${log_file} \
    -P ${VERDI}/share/PLI/VCS/linux64/novas.tab \
       ${VERDI}/share/PLI/VCS/linux64/pli.a \
    +define+RTL \
    +define+CUSTOM \
    +notimingchecks 

VCS_RTL_SIM2 = vcs ${TIMESCALE} \
    -j${num_CPU_cores} \
    -sverilog \
    +v2k \
    -full64 \
    -Mupdate \
    -R \
    -debug_access+all \
    -y ${DW_SIM} \
    +libext+.v \
    -f ${source_file2} \
    -o ${output_file} \
    -l ${log_file} \
    -P ${VERDI}/share/PLI/VCS/linux64/novas.tab \
       ${VERDI}/share/PLI/VCS/linux64/pli.a \
    +define+RTL \
    +define+CUSTOM \
    +notimingchecks 
 
VCS_RTL_SIM3 = vcs ${TIMESCALE} \
    -j${num_CPU_cores} \
    -sverilog \
    +v2k \
    -full64 \
    -Mupdate \
    -R \
    -debug_access+all \
    -y ${DW_SIM} \
    +libext+.v \
    -f ${source_file3} \
    -o ${output_file} \
    -l ${log_file} \
    -P ${VERDI}/share/PLI/VCS/linux64/novas.tab \
       ${VERDI}/share/PLI/VCS/linux64/pli.a \
    +define+RTL \
    +define+CUSTOM \
    +notimingchecks 

VCS_RTL_SIM4 = vcs ${TIMESCALE} \
    -j${num_CPU_cores} \
    -sverilog \
    +v2k \
    -full64 \
    -Mupdate \
    -R \
    -debug_access+all \
    -y ${DW_SIM} \
    +libext+.v \
    -f ${source_file4} \
    -o ${output_file} \
    -l ${log_file} \
    -P ${VERDI}/share/PLI/VCS/linux64/novas.tab \
       ${VERDI}/share/PLI/VCS/linux64/pli.a \
    +define+RTL \
    +define+CUSTOM \
    +notimingchecks 
 
VCS_RTL_SIM5 = vcs ${TIMESCALE} \
    -j${num_CPU_cores} \
    -sverilog \
    +v2k \
    -full64 \
    -Mupdate \
    -R \
    -debug_access+all \
    -y ${DW_SIM} \
    +libext+.v \
    -f ${source_file5} \
    -o ${output_file} \
    -l ${log_file} \
    -P ${VERDI}/share/PLI/VCS/linux64/novas.tab \
       ${VERDI}/share/PLI/VCS/linux64/pli.a \
    +define+RTL \
    +define+CUSTOM \
    +notimingchecks 

VCS_RTL_SIM6 = vcs ${TIMESCALE} \
    -j${num_CPU_cores} \
    -sverilog \
    +v2k \
    -full64 \
    -Mupdate \
    -R \
    -debug_access+all \
    -y ${DW_SIM} \
    +libext+.v \
    -f ${source_file6} \
    -o ${output_file} \
    -l ${log_file} \
    -P ${VERDI}/share/PLI/VCS/linux64/novas.tab \
       ${VERDI}/share/PLI/VCS/linux64/pli.a \
    +define+RTL \
    +define+CUSTOM \
    +notimingchecks 


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

VERDI_RTL_ON1 = verdi -ssf *.vcd \
	-sv \
	-f ${source_file1} \
    	-nologo           \
	+define+RTL	  \
	+v2k \
	-autoalias

VERDI_RTL_ON2 = verdi -ssf *.vcd \
	-sv \
	-f ${source_file2} \
    	-nologo           \
	+define+RTL	  \
	+v2k \
	-autoalias

VERDI_RTL_ON3 = verdi -ssf *.vcd \
	-sv \
	-f ${source_file3} \
    	-nologo           \
	+define+RTL	  \
	+v2k \
	-autoalias

VERDI_RTL_ON4 = verdi -ssf *.vcd \
	-sv \
	-f ${source_file4} \
    	-nologo           \
	+define+RTL	  \
	+v2k \
	-autoalias

VERDI_RTL_ON5 = verdi -ssf *.vcd \
	-sv \
	-f ${source_file5} \
    	-nologo           \
	+define+RTL	  \
	+v2k \
	-autoalias

VERDI_RTL_ON6 = verdi -ssf *.vcd \
	-sv \
	-f ${source_file6} \
    	-nologo           \
	+define+RTL	  \
	+v2k \
	-autoalias


# =====================================	
# ============= clean =================
# =====================================
clean_vcs = rm -rf *.fsdb ./csrc *.log simv* *.sdf.X *.key
clean_verdi = rm -rf ./nWaveLog ./verdiLog *.conf *.rc *.log
# =====================================

vcs_rtl:
	${VCS_RTL_SIM}

vcs_rtl1:
	${VCS_RTL_SIM1}

vcs_rtl2:
	${VCS_RTL_SIM2}

vcs_rtl3:
	${VCS_RTL_SIM3}

vcs_rtl4:
	${VCS_RTL_SIM4}

vcs_rtl5:
	${VCS_RTL_SIM5}

vcs_rtl6:
	${VCS_RTL_SIM6}

nWave:
	${nWave_ON}

verdi_rtl:
	${VERDI_RTL_ON}

verdi_rtl_1:
	${VERDI_RTL_ON1}

verdi_rtl_2:
	${VERDI_RTL_ON2}

verdi_rtl_3:
	${VERDI_RTL_ON3}

verdi_rtl_4:
	${VERDI_RTL_ON4}

verdi_rtl_5:
	${VERDI_RTL_ON5}

verdi_rtl_6:
	${VERDI_RTL_ON6}

clean:
	${clean_vcs}
	${clean_verdi}