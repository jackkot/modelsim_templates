module testbench;
    timeunit 1ns;
    timeprecision 1ns;

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

    
    initial begin
        // initiate variables
        in = 0;

        #1 wait(reset_n == 1);
        delay(clk, 1);
        
        // testbench starts here
        in = 1;

        delay(clk, 10);
        in = 0;

        wait(out == 0);
        delay(clk, 1);

        // testbench ends

        delay(clk, 2);
        $stop;
    end
        
endmodule
