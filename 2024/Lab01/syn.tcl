#======================================================
#
# Synopsys Synthesis Scripts (Design Vision dctcl mode)
#
#======================================================

#======================================================
#  Set Libraries
#======================================================
set search_path {	./								 \
					~/iclabTA01/umc018/Synthesis/ 	 \
					/usr/synthesis/libraries/syn/    \
					/usr/synthesis/dw/ }

set synthetic_library {dw_foundation.sldb}
set link_library {* dw_foundation.sldb standard.sldb slow.db}
set target_library {slow.db}

#======================================================
#
# Synopsys Synthesis Scripts (Design Vision dctcl mode)
#
#======================================================

#======================================================
#  Global Parameters
#======================================================
set DESIGN "Comb_1"
set MAX_DELAY 10
#======================================================
#  Read RTL Code
#======================================================
#read_sverilog { $DESIGN\.sv }
read_sverilog { ./Comb.sv }
current_design $DESIGN

#======================================================
#  Global Setting
#======================================================
#set_wire_load_mode top

#======================================================
#  Set Design Constraints
#======================================================
#create_clock -name "CLK" -period $CLK_period CLK 
#set_input_delay  [ expr $CLK_period*0.5 ] -clock CLK [all_inputs]
#set_output_delay [ expr $CLK_period*0.5 ] -clock CLK [all_outputs]
#set_input_delay 0 -clock CLK CLK
#set_load 0.05 [all_outputs]
set_max_delay $MAX_DELAY -from [all_inputs] -to [all_outputs]
#======================================================
#  Optimization
#======================================================
uniquify
set_fix_multiple_port_nets -all -buffer_constants
#set_fix_hold [all_clocks]
compile_ultra

#======================================================
#  Output Reports 
#======================================================
report_timing >  Report/$DESIGN\.timing
report_area >  Report/$DESIGN\.area
report_resource >  Report/$DESIGN\.resource

#======================================================
#  Change Naming Rule
#======================================================
set bus_inference_style "%s\[%d\]"
set bus_naming_style "%s\[%d\]"
set hdlout_internal_busses true

change_names -hierarchy -rule verilog

define_name_rules name_rule -allowed "a-z A-Z 0-9 _" -max_length 255 -type cell
define_name_rules name_rule -allowed "a-z A-Z 0-9 _[]" -max_length 255 -type net
define_name_rules name_rule -map {{"\\*cell\\*" "cell"}}
change_names -hierarchy -rules name_rule

#======================================================
#  Output Results
#======================================================

set verilogout_higher_designs_first true
write -format verilog -output Comb_SYN.v -hierarchy
write_sdf -version 2.1 -context verilog -load_delay cell Comb_SYN.sdf

#======================================================
#  Finish and Quit
#======================================================
report_timing
report_area
exit
