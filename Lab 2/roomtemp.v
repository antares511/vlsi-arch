module room_temp (temp, ac, fan, heater, all_off, clk, init, q);

    input [5:0] temp; //6-bit temp input
    input clk, init;

    output reg ac, fan, heater, all_off;
    reg [3:0] d;
    output wire [3:0] q;
    output reg [2:0] temp_range;


    dff_4 dff (.clk(clk), .d(d), .q(q), .rst(init));

    //ranges defined according to the definitions given in the problem statement
    always @ (*) begin
        if (temp < 15) begin
            temp_range = 3'b000;
        end
        else if (temp >= 15 & temp <= 18) begin
            temp_range = 3'b001;
        end
        else if (temp > 18 & temp < 22) begin
            temp_range = 3'b010;
        end
        else if (temp == 22) begin
            temp_range = 3'b011;
        end
        else if (temp == 23) begin
            temp_range = 3'b100;
        end
        else if (temp > 23 & temp <= 27) begin
            temp_range = 3'b101;
        end
        else if (temp > 27) begin
            temp_range = 3'b110;
        end
        
        ac = q[3];
        fan = q[2];
        heater = q[1];
        all_off = q[0];
    end

    always @ (temp) begin

        case (q)
            4'b0001: //all off state
            begin
                case (temp_range)
                3'b000: d = 4'b0010; //temp < 15, heater on
                3'b001: d = 4'b0001; //temp >= 15 & temp <= 18, all off
                3'b010: d = 4'b0001; //temp > 18 & temp < 22, all off
                3'b011: d = 4'b0001; //temp == 22, all off
                3'b100: d = 4'b0001; //temp == 23, all off
                3'b101: d = 4'b0100; //temp > 23 & temp <= 27, fan on
                3'b110: d = 4'b1000; //temp > 27, ac on
                endcase
            end
            
            4'b0010: //heater is on
            begin
                case (temp_range)
                3'b000: d = 4'b0010; //temp < 15, heater on
                3'b001: d = 4'b0010; //temp >= 15 & temp <= 18, heater on
                3'b010: d = 4'b0001; //temp > 18 & temp < 22, all off
                3'b011: d = 4'b0001; //temp == 22, all off
                3'b100: d = 4'b0001; //temp == 23, all off
                3'b101: d = 4'b0100; //temp > 23 & temp <= 27, fan on
                3'b110: d = 4'b1000; //temp > 27, ac on
                endcase
            end
            
            4'b0100: //fan is on
            begin
                case (temp_range)
                3'b000: d = 4'b0010; //temp < 15, heater on
                3'b001: d = 4'b0001; //temp >= 15 & temp <= 18, all off
                3'b010: d = 4'b0001; //temp > 18 & temp < 22, all off
                3'b011: d = 4'b0100; //temp == 22, fan remains on
                3'b100: d = 4'b0100; //temp == 23, fan remains on
                3'b101: d = 4'b0100; //temp > 23 & temp <= 27, fan remains on
                3'b110: d = 4'b1000; //temp > 27, ac on
                endcase
            end
            
            4'b1000:  //ac is on
            begin
                case (temp_range)
                3'b000: d = 4'b0010; //temp < 15, heater on
                3'b001: d = 4'b0001; //temp >= 15 & temp <= 18, all off
                3'b010: d = 4'b0001; //temp > 18 & temp < 22, all off
                3'b011: d = 4'b0100; //temp == 22, ac off, fan on
                3'b100: d = 4'b1000; //temp == 23, ac remains on
                3'b101: d = 4'b1000; //temp > 23 & temp <= 27, ac remains on
                3'b110: d = 4'b1000; //temp > 27, ac remains on
                endcase 
            end
        
        endcase
    end
endmodule

module dff_4 (clk, d, q, rst);
    input clk, rst;
    input [3:0] d;
    output reg [3:0] q;

    always @ (posedge clk or negedge rst)
        if (!rst)
            q <= 4'b0000;
        else
            q <= d;
endmodule