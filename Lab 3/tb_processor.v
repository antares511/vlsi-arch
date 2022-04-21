`include "processor.v"

module tb ();

    reg clk;

    processor uut (.clock(clk));

    always #10 clk = ~clk;

    initial #1500 $finish;

    initial begin
        //Initialise Registers. Set to 0 if not specified
        uut.pc          = 16'h0000;
        uut.r[0]        = 16'h0000;
        uut.r[1]        = 16'h0001;
        uut.r[2]        = 16'hAAAA;
        uut.r[3]        = 16'h5555;
        uut.r[4]        = 16'h0000;
        uut.r[5]        = 16'h0000;
        uut.r[6]        = 16'h0000;
        uut.r[7]        = 16'h0010;
        uut.r[8]        = 16'h0010;
        uut.r[9]        = 16'h0011;
        uut.r[10]       = 16'h000A;
        uut.r[11]       = 16'h0000;
        uut.r[12]       = 16'h0000;
        uut.r[13]       = 16'h0000;
        uut.r[14]       = 16'h0000;
        uut.r[15]       = 16'h001F;

        //Initialise Memory
        uut.m[0]    = 16'h4497;
        uut.m[1]    = 16'h0047;
        uut.m[2]    = 16'h44D7;
        uut.m[3]    = 16'h248F;
        uut.m[4]    = 16'h24CF;
        uut.m[5]    = 16'h04E8;
        uut.m[6]    = 16'h0001;
        uut.m[7]    = 16'h6419;
        uut.m[8]    = 16'h601A;
        uut.m[9]    = 16'h0047;
        uut.m[10]   = 16'h234F;
        uut.m[11]   = 16'h230F;
        uut.m[12]   = 16'h188C;
        uut.m[13]   = 16'h1CCD;
        uut.m[14]   = 16'h08C2;
        uut.m[15]   = 16'h1083;

        uut.irf = uut.m[uut.pc]; //Sending intruction to irf
        uut.instruction_decode(); //Decoding
        uut.TY = 2'b00; //To select next instruction from IB
        uut.pc = uut.pc + 16'h0001; //Increment PC
        uut.ire = uut.irf; //IRF -> IRE
        uut.set_rx_ry(); //Set Rx and Ry index
    end

    initial begin
        clk <= 0;

        //Testing functionality
        $monitor($time,"ire = %h, stack pointer = %h, t1 = %h, flags C V Z N = %b %b %b %b", uut.ire, uut.r[15], uut.t1, uut.flag_c, uut.flag_v, uut.flag_z, uut.flag_n);
    end

endmodule