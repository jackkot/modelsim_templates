`ifndef _MY_FUNCTIONS_PKG_
`define _MY_FUNCTIONS_PKG_

import verbosity_pkg::*;
import avalon_mm_pkg::*;

package my_functions_pkg;

    task automatic delay;
        ref   logic   clk;
        input int     forClocks;

        for (int i=0; i<forClocks; i++) @(posedge clk);
    endtask

endpackage : my_functions_pkg

`endif
