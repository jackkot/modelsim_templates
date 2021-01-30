`define SVUNIT_TIMEOUT 1000*1000 /*ns*/
`include "svunit_defines.svh"

module testbench_unit_test;
    timeunit 1ns;
    timeprecision 1ns;

	import svunit_pkg::svunit_testcase;

	string name = "testbench_ut";
	svunit_testcase svunit_ut;


	//===================================
	// This is the UUT that we're 
	// running the Unit Tests on
	//===================================

    import verbosity_pkg::*;
    import my_functions_pkg::*;

    initial set_verbosity(VERBOSITY_WARNING);
    
    parameter DEPTH = 1;

    /*[i]*/ logic        reset_n;
    /*[i]*/ logic        clk;
  
    /*[i]*/ logic        in;
    /*[o]*/ logic        out;
    /*[o]*/ logic        posEdgeStr;
    /*[o]*/ logic        negEdgeStr;

    event up_event, down_event;

    dff_scm #(
            .DEPTH(DEPTH)
        ) DUT (.*);

    altera_avalon_clock_source #(
            .CLOCK_RATE (100)
        ) CLOCK_SOURCE_MAIN (
            /*[o]*/ .clk (clk)
        );

    altera_avalon_reset_source #(
            .ASSERT_HIGH_RESET    (0),
            .INITIAL_RESET_CYCLES (3)
        ) RESET_SOURCE_MAIN (
            /*[o]*/ .reset (reset_n),
            /*[i]*/ .clk   (clk)
        );

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

        in = 0;

        RESET_SOURCE_MAIN.reset_assert();
        delay(clk, 3);
        RESET_SOURCE_MAIN.reset_deassert();        
        delay(clk, 1);

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


    task automatic check_state;
        input logic     o;
        input logic     pe;
        input logic     ne;

        `FAIL_UNLESS(out == o);
        `FAIL_UNLESS(posEdgeStr == pe);
        `FAIL_UNLESS(negEdgeStr == ne);
    endtask

	`SVUNIT_TESTS_BEGIN

	`SVTEST(ten_ticks_len)

        check_state(.o(0), .pe(0), .ne(0));

        fork begin
            delay(clk, 1);
            in = 1;
            ->up_event;

            delay(clk, DEPTH);
            check_state(.o(0), .pe(0), .ne(0));
            
            delay(clk, 1);
            check_state(.o(1), .pe(1), .ne(0));
            
            delay(clk, 1);
            check_state(.o(1), .pe(0), .ne(0));
        end
        begin
            @(up_event);

            delay(clk, 10);
            in = 0;
            ->down_event;

            delay(clk, DEPTH);
            check_state(.o(1), .pe(0), .ne(0));
            
            delay(clk, 1);
            check_state(.o(0), .pe(0), .ne(1));
            
            delay(clk, 1);
            check_state(.o(0), .pe(0), .ne(0));
        end join

        // fork begin
        //     delay(clk, 1);
        //     in = 1;
        //     ->up_event;
        //     delay(clk, 10);
        //     in = 0;
        //     ->down_event;
        // end
        // begin
        //     @(up_event);
        //     delay(clk, DEPTH);
        //     @(posedge clk);
        //     `FAIL_UNLESS(out == 1);
        //     `FAIL_UNLESS(posEdgeStr == 1);
        //     `FAIL_UNLESS(negEdgeStr == 0);

        //     @(posedge clk);

        //     `FAIL_UNLESS(posEdgeStr == 0);
        // end        
        // begin
        //     @(down_event);
        //     delay(clk, DEPTH);

        //     `FAIL_UNLESS(out == 0);
        //     `FAIL_UNLESS(posEdgeStr == 0);
        //     `FAIL_UNLESS(negEdgeStr == 1);
        // end join
        
        delay(clk, 2);

	`SVTEST_END


	`SVTEST(fake_test)

        `FAIL_UNLESS(out == 0);
        `FAIL_UNLESS(posEdgeStr == 0);
        `FAIL_UNLESS(negEdgeStr == 0);
        delay(clk, 5);
                
	`SVTEST_END

	`SVUNIT_TESTS_END
    
endmodule
