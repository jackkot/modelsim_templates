`define SVUNIT_TIMEOUT 1000*1000 /*ns*/
`include "svunit_defines.svh"

module xxx_unit_test;
    timeunit 1ns;
    timeprecision 1ns;

	import svunit_pkg::svunit_testcase;

	string name = "xxx_ut";
	svunit_testcase svunit_ut;


	//===================================
	// This is the UUT that we're 
	// running the Unit Tests on
	//===================================

    import verbosity_pkg::*;

    initial set_verbosity(VERBOSITY_WARNING);
    
    /* Instantionate your DUT */

    event _event;
    int _event_n = 0;
    always @(_event) _event_n <= _event_n + 1;

	//===================================
	// Build
	//===================================
	function void build();
		svunit_ut = new(name);
	endfunction


	//===================================
	// Setup for running the Unit Tests
	//===================================
	task setup();
		svunit_ut.setup();
		/* Place Setup Code Here */

        /* Setup code */

        -> _event;
	endtask


	//===================================
	// Here we deconstruct anything we 
	// need after running the Unit Tests
	//===================================
	task teardown();
		svunit_ut.teardown();
		/* Place Teardown Code Here */

	endtask


	//===================================
	// All tests are defined between the
	// SVUNIT_TESTS_BEGIN/END macros
	//
	// Each individual test must be
	// defined between `SVTEST(_NAME_)
	// `SVTEST_END
	//
	// i.e.
	//   `SVTEST(mytest)
	//     <test code>
	//   `SVTEST_END
	//===================================

	`SVUNIT_TESTS_BEGIN

	`SVTEST(test_name_1)
        
        /* Testbench code */
        `FAIL_UNLESS(0 == 0);

        delay(clk, 5);

	`SVTEST_END


	`SVTEST(test_name_2)

        /* Testbench code */
        `FAIL_UNLESS(1 == 1);

        delay(clk, 5);

	`SVTEST_END

	`SVUNIT_TESTS_END
    
endmodule
