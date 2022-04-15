`include "task2_gate.v"

module Fulladder4_tb;

    reg [3:0] a,b;
    wire [3:0] sum;
    wire cout;

    Fulladder4 uut (a, b, sum, cout);

    initial 
        begin
            $dumpfile("task2_gate.vcd");
            $dumpvars(0, Fulladder4_tb);
            $monitor($time, "a =  %4b, b = %4b, sum = %4b, cout = %b", a, b, sum, cout);

            a = 4'b0000; b = 4'b0111;
            #5 a = 4'b0101; b = 4'b1001;
            #5 a = 4'b1011; b = 4'b0100;
            #5 a = 4'b0111; b = 4'b1111;
            #5 a = 4'b1100; b = 4'b1010;
        end
endmodule