`include "task1_gate.v"

module ppgen4x1_tb;
    reg [3:0] mxin;
    reg myin;
    wire [3:0] out;

    ppgen4x1 uut (mxin, myin, out);

    initial
        begin
            $dumpfile("task1_gate.vcd");
            $dumpvars(0, ppgen4x1_tb);
            $monitor($time, " mxin = %4b, myin = %b, out = %4b", mxin, myin, out); 

            mxin = 4'b1001; myin = 1'b1;
            #5 mxin = 4'b1001; myin = 1'b0;
            #5 mxin = 4'b1010; myin = 1'b1;
            #5 mxin = 4'b1011; myin = 1'b0;
            #5 mxin = 4'b1101; myin = 1'b1;
        end
endmodule