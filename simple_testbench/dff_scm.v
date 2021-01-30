module dff_scm (
        input  reset_n,
        input  clk,
        input  in,
        output out,
        output posEdgeStr,
        output negEdgeStr
    );

    parameter DEPTH = 1;


    generate
        if (DEPTH == 0) begin

            reg dff_reg;
            always @(posedge clk or negedge reset_n)
            if (~reset_n) dff_reg <= 0;
            else          dff_reg <= in;

            assign posEdgeStr = ( in & ~dff_reg);
            assign negEdgeStr = (~in &  dff_reg);
            assign out        =   in;

        end
        else
        begin

            reg [DEPTH:0] dff_reg;
            always @(posedge clk or negedge reset_n)
                if (~reset_n) dff_reg <= 0;
                else          dff_reg <= {dff_reg[DEPTH-1:0], in};

            assign posEdgeStr = ( dff_reg[DEPTH-1] & ~dff_reg[DEPTH]);
            assign negEdgeStr = (~dff_reg[DEPTH-1] &  dff_reg[DEPTH]);
            assign out        =   dff_reg[DEPTH-1];

        end
    endgenerate

endmodule
