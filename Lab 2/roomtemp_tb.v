`include "roomtemp.v"

module tb;

reg [5:0] in;
reg rst;
reg clock;
wire ac, fan, heater, all_off;
wire [3:0] state;

room_temp temp_control (.temp(in), .clk(clock), .ac(ac), .fan(fan), .heater(heater), .all_off(all_off), .init(rst), .q(state));

always #5 clock = ~clock;

initial begin
    $dumpfile("roomtemp.vcd");
    $dumpvars(0, tb);
    $monitor($time, "Temperature = %2d, AC = %b, Heater = %b, Fan = %b, State = %4b", in, ac, heater, fan, state);

    clock = 1'b0;
    rst = 1'b1;
     
    #2 rst = 1'b0;
    temp_control.d = 4'b0001;
    #4 rst = 1'b1;

    #10 in = 6'd17;
    #10 in = 6'd10;
    #10 in = 6'd17;
    #10 in = 6'd23;
    #10 in = 6'd25;
    #10 in = 6'd23;
    #10 in = 6'd22;
    #10 in = 6'd21;
    #10 in = 6'd25;
    #10 in = 6'd28;
    #10 in = 6'd23;
    #10 in = 6'd22;
    #10 in = 6'd13;
    #10 in = 6'd30;
    #10 in = 6'd20;
    
    #10 $finish;
end
endmodule