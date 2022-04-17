`include "processor.v"

module tb ();

    reg clk;

    execution uut (.clock(clk));

    always #10 clk = ~clk;

    initial #170 $finish;

    initial begin
        clk <= 0;
        uut.m[0] = 16'hfff;
        uut.ao = 16'hffff;

        //Testing register read and write functionality
        $monitor($time,"mem = %16b, edb = %16b ", uut.m[0], uut.edb);
        #10 uut.r_wbar = 1'b1; uut.ao = 16'h0000;
        #20 uut.r_wbar = 1'b0; uut.edb = 16'h1234;
    end

endmodule
