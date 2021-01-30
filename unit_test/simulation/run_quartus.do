transcript off

onerror {global errorInfo; echo $errorInfo; abort}
onbreak {wave zoom full}

# set WORK_PREFIX [file dirname [file normalize [info script]]]
set WORK_PREFIX [expr {[file tail [pwd]] == "modelsim"} ? {".."} : {"."}]
set SIM_INC ""


# Compile Simulation Libraries
proc compile_lib {} {
	variable WORK_PREFIX
	variable SIM_INC

	set ALTERA_SOPC_IP_LIBS "$::env(QUARTUS_ROOTDIR)/../ip/altera/sopc_builder_ip/verification"
	set SVUNIT_LIB "$WORK_PREFIX/modules/svunit_base"
	set SVUNIT_INC [join [list "" $WORK_PREFIX $SVUNIT_LIB "$SVUNIT_LIB/uvm-mock"] "+"]
	append SIM_INC $SVUNIT_INC

	vlog -sv -work work [list "$ALTERA_SOPC_IP_LIBS/lib/verbosity_pkg.sv"]
	vlog -sv -work work [list "$ALTERA_SOPC_IP_LIBS/lib/avalon_mm_pkg.sv"]
	vlog -sv -work work [list "$ALTERA_SOPC_IP_LIBS/lib/avalon_utilities_pkg.sv"]

	vlog -sv -work work [list "$ALTERA_SOPC_IP_LIBS/altera_avalon_clock_source/altera_avalon_clock_source.sv"]
	vlog -sv -work work [list "$ALTERA_SOPC_IP_LIBS/altera_avalon_reset_source/altera_avalon_reset_source.sv"]
	vlog -sv -work work [list "$ALTERA_SOPC_IP_LIBS/altera_avalon_mm_master_bfm/altera_avalon_mm_master_bfm.sv"]
	vlog -sv -work work [list "$ALTERA_SOPC_IP_LIBS/altera_avalon_mm_slave_bfm/altera_avalon_mm_slave_bfm.sv"]

	vlog -sv -work work [list "$WORK_PREFIX/modules/my_functions_pkg.sv"]
	vlog -sv -work work [list "$WORK_PREFIX/modules/my_avalon_mm_master_bfm.sv"]

	vlog -sv -work work +incdir$SVUNIT_INC [list "$SVUNIT_LIB/svunit_pkg.sv"]
	vlog -sv -work work +incdir$SVUNIT_INC [list "$SVUNIT_LIB/testrunner/__testrunner.sv"]
}

# Compile Testbench
proc compile_tb {} {
	variable WORK_PREFIX
	variable SIM_INC

	vlog -sv -work work +incdir$SIM_INC [list "$WORK_PREFIX/test_runner.sv"]
	vlog -sv -work work +incdir$SIM_INC [list "$WORK_PREFIX/testbench_unit_test.sv"]
	# vlog -sv -work work +incdir$SIM_INC [list "$WORK_PREFIX/xxx_unit_test.sv"]
	vsim -wlf "$WORK_PREFIX/modelsim/testbench.wlf" -voptargs="+acc" +nowarn3116 \
		-L work -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclone10lp_ver \
		__testrunner

	view wave
	log -r *
	do "$WORK_PREFIX/wave_cfg.do"
	run -all
}

# save waveform formats
proc save  {} {global WORK_PREFIX; write format wave "$WORK_PREFIX/wave_cfg.do"}
# recompile all: project, libraries and testbench
# define only if not defined earlier
if {[info procs ra] == ""} {
	proc ra    {} {global WORK_PREFIX; do [glob -type f "$WORK_PREFIX/modelsim/*run_msim_rtl*.do"]}
}
# recompile testbench only
proc rb    {} {compile_tb}
# just restart simulation
proc rs    {} {restart; run -all}

# run 
compile_lib
rb