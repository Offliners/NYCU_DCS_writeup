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
DW_SIM=/usr/cad/synopsys/synthesis/cur/dw/sim_ver/

# =====================================
# ============== irun =================
# =====================================
IRUN_RTL_SIM = irun -f ${source_file} \
	-incdir ${DW_SIM} \
	-loadpli1 debpli:novas_pli_boot \
	-debug \
	-notimingchecks \
	-define RTL
 
IRUN_RTL_SIM1 = irun -f ${source_file1} \
	-incdir ${DW_SIM} \
	-loadpli1 debpli:novas_pli_boot \
	-debug \
	-notimingchecks \
	-define RTL

IRUN_RTL_SIM2 = irun -f ${source_file2} \
	-incdir ${DW_SIM} \
	-loadpli1 debpli:novas_pli_boot \
	-debug \
	-notimingchecks \
	-define RTL
 
IRUN_RTL_SIM3 = irun -f ${source_file3} \
	-incdir ${DW_SIM} \
	-loadpli1 debpli:novas_pli_boot \
	-debug \
	-notimingchecks \
	-define RTL

IRUN_RTL_SIM4 = irun -f ${source_file4} \
	-incdir ${DW_SIM} \
	-loadpli1 debpli:novas_pli_boot \
	-debug \
	-notimingchecks \
	-define RTL
 
IRUN_RTL_SIM5 = irun -f ${source_file5} \
	-incdir ${DW_SIM} \
	-loadpli1 debpli:novas_pli_boot \
	-debug \
	-notimingchecks \
	-define RTL

IRUN_RTL_SIM6 = irun -f ${source_file6} \
	-incdir ${DW_SIM} \
	-loadpli1 debpli:novas_pli_boot \
	-debug \
	-notimingchecks \
	-define RTL


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
clean_irun = rm -rf *.vcd *.fsdb *.sdf.X ./INCA_libs *.history *.log
clean_verdi = rm -rf ./nWaveLog ./verdiLog *.conf *.rc *.log
# =====================================

irun_rtl:
	${IRUN_RTL_SIM}

irun_rtl_1:
	${IRUN_RTL_SIM1}

irun_rtl_2:
	${IRUN_RTL_SIM2}

irun_rtl_3:
	${IRUN_RTL_SIM3}

irun_rtl_4:
	${IRUN_RTL_SIM4}

irun_rtl_5:
	${IRUN_RTL_SIM5}

irun_rtl_6:
	${IRUN_RTL_SIM6}

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
	${clean_irun}
	${clean_verdi}