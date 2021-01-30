transcript off

onerror {global errorInfo; echo $errorInfo; abort}

set WORK_PREFIX [expr {[file tail [pwd]] == "modelsim"} ? {".."} : {"."}]
set SIM_INC ""

if {[file exists "$WORK_PREFIX/modelsim/rtl_work"]} {
	vdel -lib "$WORK_PREFIX/modelsim/rtl_work" -all
}
vlib "$WORK_PREFIX/modelsim/rtl_work"
vmap work "$WORK_PREFIX/modelsim/rtl_work"


# Compile Project
proc compile_proj {} {
	variable WORK_PREFIX
	variable SIM_INC

	set PROJECT_DIR "$WORK_PREFIX/.."
	set MODULES_DIR "$PROJECT_DIR/modules"
	set PROJ_INC [join [list "" "$MODULES_DIR" "$PROJECT_DIR"] "+"]
	append SIM_INC $PROJ_INC

	vlog -sv -work work +incdir$PROJ_INC [list "$PROJECT_DIR/dff_scm.v"]
}

# recompile all: project, libraries and testbench
proc ra    {} {global WORK_PREFIX; do $WORK_PREFIX/run_standalone.do}

# run 
compile_proj
do $WORK_PREFIX/run_quartus.do