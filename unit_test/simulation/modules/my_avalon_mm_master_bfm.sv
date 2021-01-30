`ifndef _MY_AVALON_MM_MASTER_BFM_
`define _MY_AVALON_MM_MASTER_BFM_

import verbosity_pkg::*;
import avalon_mm_pkg::*;

module my_avalon_mm_master_bfm #(
        parameter AV_ADDRESS_W               = 32, // Address width in bits
        parameter AV_SYMBOL_W                = 8,  // Data symbol width in bits
        parameter AV_NUMSYMBOLS              = 4,  // Number of symbols per word
        parameter AV_BURSTCOUNT_W            = 3,  // Burst port width in bits
        parameter AV_READRESPONSE_W          = 8,
        parameter AV_WRITERESPONSE_W         = 8,

        parameter USE_READ                   = 1,  // Use read pin on interface
        parameter USE_WRITE                  = 1,  // Use write pin on interface
        parameter USE_ADDRESS                = 1,  // Use address pins on interface
        parameter USE_BYTE_ENABLE            = 1,  // Use byte_enable pins on interface
        parameter USE_BURSTCOUNT             = 1,  // Use burstcount pin on interface
        parameter USE_READ_DATA              = 1,  // Use readdata pin on interface
        parameter USE_READ_DATA_VALID        = 1,  // Use readdatavalid pin on interface
        parameter USE_WRITE_DATA             = 1,  // Use writedata pin on interface
        parameter USE_BEGIN_TRANSFER         = 1,  // Use begintransfer pin on interface
        parameter USE_BEGIN_BURST_TRANSFER   = 1,  // Use beginbursttransfer pin on interface
        parameter USE_WAIT_REQUEST           = 1,  // Use waitrequest pin on interface
        parameter USE_ARBITERLOCK            = 0,  // Use arbiterlock pin on interface
        parameter USE_LOCK                   = 0,  // Use lock pin on interface
        parameter USE_DEBUGACCESS            = 0,  // Use debugaccess pin on interface
        parameter USE_TRANSACTIONID          = 0,  // Use transactionid interface pin
        parameter USE_WRITERESPONSE          = 0,  // Use write response interface pins
        parameter USE_READRESPONSE           = 0,  // Use read response interface pins
        parameter USE_CLKEN                  = 0,  // Use NTCM interface pins
        parameter AV_REGISTERINCOMINGSIGNALS = 0,  // Indicate that waitrequest is come from register

        parameter AV_FIX_READ_LATENCY        = 0,  // Fixed read latency in cycles
        parameter AV_MAX_PENDING_READS       = 0,  // Number of pending read transactions
        parameter AV_MAX_PENDING_WRITES      = 0,  // Number of pending write transactions

        parameter AV_BURST_LINEWRAP          = 0,
        parameter AV_BURST_BNDR_ONLY         = 0,  // Assert Addr alignment
        parameter AV_CONSTANT_BURST_BEHAVIOR = 1,  // Address, burstcount, transactionid and
                                                   // avm_writeresponserequest need to be held constant
                                                   // in burst transaction
        parameter AV_READ_WAIT_TIME          = 0,  // Fixed wait time cycles when
        parameter AV_WRITE_WAIT_TIME         = 0,  // USE_WAIT_REQUEST is 0

        parameter REGISTER_WAITREQUEST       = 0,  // Waitrequest is registered at the slave
        parameter VHDL_ID                    = 0,   // VHDL BFM ID number

        localparam MAX_BURST_SIZE            = USE_BURSTCOUNT ? 2**(AV_BURSTCOUNT_W-1) : 1,
        localparam AV_DATA_W                 = AV_SYMBOL_W * AV_NUMSYMBOLS,
        localparam AV_TRANSACTIONID_W        = 8
    ) (
        input                                                clk,
        input                                                reset,   // active high
        // =head2 Avalon Master Interface
        input                                                avm_waitrequest,
        input                                                avm_readdatavalid,
        input  [(AV_SYMBOL_W*AV_NUMSYMBOLS)-1:0]             avm_readdata,
        output                                               avm_write,
        output                                               avm_read,
        output [(AV_ADDRESS_W)-1:0]                          avm_address,
        output [(AV_NUMSYMBOLS)-1:0]                         avm_byteenable,
        output [(AV_BURSTCOUNT_W)-1:0]                       avm_burstcount,
        output                                               avm_beginbursttransfer,
        output                                               avm_begintransfer,
        output [(AV_SYMBOL_W*AV_NUMSYMBOLS)-1:0]             avm_writedata,
        output                                               avm_arbiterlock,
        output                                               avm_lock,
        output                                               avm_debugaccess,
        output [(AV_TRANSACTIONID_W)-1:0]                    avm_transactionid,
        input  [(AV_READRESPONSE_W)-1:0]                     avm_readresponse,
        input  [(AV_TRANSACTIONID_W)-1:0]                    avm_readid,
        output                                               avm_writeresponserequest,
        input                                                avm_writeresponsevalid,
        input  [(AV_WRITERESPONSE_W)-1:0]                    avm_writeresponse,
        input  [(AV_TRANSACTIONID_W)-1:0]                    avm_writeid,
        input  [1:0]                                         avm_response,
        output                                               avm_clken
    );

    altera_avalon_mm_master_bfm #(
            .AV_ADDRESS_W               (AV_ADDRESS_W),
            .AV_SYMBOL_W                (AV_SYMBOL_W),
            .AV_NUMSYMBOLS              (AV_NUMSYMBOLS),
            .AV_BURSTCOUNT_W            (AV_BURSTCOUNT_W),
            .AV_READRESPONSE_W          (AV_READRESPONSE_W),
            .AV_WRITERESPONSE_W         (AV_WRITERESPONSE_W),
            .USE_READ                   (USE_READ),
            .USE_WRITE                  (USE_WRITE),
            .USE_ADDRESS                (USE_ADDRESS),
            .USE_BYTE_ENABLE            (USE_BYTE_ENABLE),
            .USE_BURSTCOUNT             (USE_BURSTCOUNT),
            .USE_READ_DATA              (USE_READ_DATA),
            .USE_READ_DATA_VALID        (USE_READ_DATA_VALID),
            .USE_WRITE_DATA             (USE_WRITE_DATA),
            .USE_BEGIN_TRANSFER         (USE_BEGIN_TRANSFER),
            .USE_BEGIN_BURST_TRANSFER   (USE_BEGIN_BURST_TRANSFER),
            .USE_WAIT_REQUEST           (USE_WAIT_REQUEST),
            .USE_ARBITERLOCK            (USE_ARBITERLOCK),
            .USE_LOCK                   (USE_LOCK),
            .USE_DEBUGACCESS            (USE_DEBUGACCESS),
            .USE_TRANSACTIONID          (USE_TRANSACTIONID),
            .USE_WRITERESPONSE          (USE_WRITERESPONSE),
            .USE_READRESPONSE           (USE_READRESPONSE),
            .USE_CLKEN                  (USE_CLKEN),
            .AV_REGISTERINCOMINGSIGNALS (AV_REGISTERINCOMINGSIGNALS),
            .AV_FIX_READ_LATENCY        (AV_FIX_READ_LATENCY),
            .AV_MAX_PENDING_READS       (AV_MAX_PENDING_READS),
            .AV_MAX_PENDING_WRITES      (AV_MAX_PENDING_WRITES),
            .AV_BURST_LINEWRAP          (AV_BURST_LINEWRAP),
            .AV_BURST_BNDR_ONLY         (AV_BURST_BNDR_ONLY),
            .AV_CONSTANT_BURST_BEHAVIOR (AV_CONSTANT_BURST_BEHAVIOR),
            .AV_READ_WAIT_TIME          (AV_READ_WAIT_TIME),
            .AV_WRITE_WAIT_TIME         (AV_WRITE_WAIT_TIME),
            .REGISTER_WAITREQUEST       (REGISTER_WAITREQUEST),
            .VHDL_ID                    (VHDL_ID)
        ) mstr (
            .*
        );
// `define MSTR testbench.avalon_master_rtx

    function automatic void set_and_push_command (
        input Request_t request     = REQ_WRITE,
        input [AV_DATA_W-1:0]    addr        = 0,
        input [AV_DATA_W-1:0]    data        = 0,
        input [AV_NUMSYMBOLS-1:0]     byte_enable = '1
        );

        begin
            mstr.set_command_request(request);
            mstr.set_command_address(addr);
            mstr.set_command_byte_enable(byte_enable, 0);

            if (request == REQ_WRITE)
            begin
               mstr.set_command_data(data, 0);
            end

            mstr.push_command();
        end
    endfunction : set_and_push_command


    //this task pops the response received by master BFM from queue
    task master_pop_and_get_response (
        output Request_t request,
        output [AV_DATA_W-1:0]    addr,
        output [AV_DATA_W-1:0]    data
        );

        begin
            mstr.pop_response();
            request = Request_t' (mstr.get_response_request());
            addr = mstr.get_response_address();
            data = mstr.get_response_data(0);
        end
    endtask


    task master_read_all_responses ();
        Request_t    request;
        logic [AV_DATA_W-1:0] addr;
        logic [AV_DATA_W-1:0] data;

        begin
            @mstr.signal_all_transactions_complete;
            while (mstr.get_response_queue_size() > 0) begin
                master_pop_and_get_response(.request(request), .addr(addr), .data(data));
                $display("req = %1d;\t addr: 0x%08X;\t data = 0x%08X", request, addr, data);
            end
        end
    endtask
endmodule // my_avalon_mm_master_bfm

`endif
