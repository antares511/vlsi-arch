`include "cash.v"

module tb();
    reg clock;
    reg reset_b, cancel_b, end_b;
    reg [15:0] barcode;
    wire [15:0] amount;

    cash_register uut(.clock(clock), .reset_b(reset_b), .cancel_b(cancel_b), .end_b(end_b), .barcode(barcode), .amount(amount));

    always #10 clock = ~clock;

    initial begin
        $dumpfile("cash_register.vcd");
        $dumpvars(0, tb);

        $monitor($time, "Amount = %h, state = %2b", amount, uut.state);

        clock = 1'b0;
        
        #1 reset_b = 1'b1; //1
        #1 reset_b = 1'b0; //2

        #20 barcode = 16'h000A; //22
        #20 barcode = 16'h00A0; //42
        #20 barcode = 16'h0008; //62
        
        #15 cancel_b = 1'b1; //77
        #1 cancel_b = 1'b0; //78

        #1 barcode = 16'h000A; //79

        #15 end_b = 1'b1; //94
        #1 end_b = 1'b0; //95
        
        #20 $finish;
    end
endmodule