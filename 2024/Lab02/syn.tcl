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
set link_library {* dw_foundation.sldb standard.sldb slow.db }
set target_library {slow.db}

#======================================================
#  Global Parameters
#======================================================
#set DESIGN "Sort"
set MAX_Delay 10
#set CYCLE 10

#======================================================
#  Read RTL Code
#======================================================
read_sverilog {Sort.sv}
current_design Sort

#======================================================
#  Global Setting
#======================================================
set_wire_load_mode top

#======================================================
#  Set Design Constraints
#======================================================

#create_clock -name "clk" -period $CYCLE clk
#set_input_delay  [ expr $CYCLE*0.5 ] -clock clk [all_inputs]
#set_output_delay [ expr $CYCLE*0.5 ] -clock clk [all_outputs]
#set_input_delay 0 -clock clk clk
#set_input_delay 0 -clock clk rst_n

set_load 0.05 [all_outputs]
set_max_delay $MAX_Delay -from [all_inputs] -to [all_outputs]
set_dont_use slow/JKFF*

#======================================================
#  Optimization
#======================================================
uniquify
set_fix_multiple_port_nets -all -buffer_constants
compile_ultra
#======================================================
#  Output Reports 
#======================================================
check_design > Report/Sort\.check
report_timing >  Report/Sort\.timing
report_area >  Report/Sort\.area
report_resource >  Report/Sort\.resource

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
write -format verilog -output Sort\_SYN.v -hierarchy
write_sdf -version 3.0 -context verilog -load_delay cell Sort\_SYN.sdf -significant_digits 6

#======================================================
#  Finish and Quit
#======================================================
report_area
report_timing
exit
