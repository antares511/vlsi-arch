

module execution();

    parameter abdm1 = 5'b00000;
    parameter abdm2 = 5'b00001;
    parameter abdm3 = 5'b00010;
    parameter abdm4 = 5'b00011;
    parameter adrm1 = 5'b00100;
    parameter brzz1 = 5'b00101;
    parameter brzz2 = 5'b00110;
    parameter brzz3 = 5'b00111;
    parameter ldrm1 = 5'b01000;
    parameter ldrm2 = 5'b01001;
    parameter strm1 = 5'b01010;
    parameter test1 = 5'b01011;
    parameter oprm1 = 5'b01100;
    parameter oprm2 = 5'b01101;
    parameter ldrr1 = 5'b01110;
    parameter strr1 = 5'b01111;
    parameter popr1 = 5'b10000;
    parameter popr2 = 5'b10001;
    parameter push1 = 5'b10010;
    parameter push2 = 5'b10011;
    parameter oprr1 = 5'b10100;
    parameter oprr2 = 5'b10101;



    reg [15:0] r [0:15];
    reg [15:0] t [0:1];
    reg [15:0] m [0:31];
    reg [15:0] a, b, eab, edb;
    reg [15:0] pc, ao, di, do, irf, ire;
    reg [4:0] ib, sb, bc, db;

    reg error;

    task alu;    
        input b_kbar;
        input [1:0] k;
        output [15:0] c;

        begin  
            case(b_kbar)
            1'b1: begin
                case(ire[12:10])
                3'b000: c = a + b;  
                3'b001: c = a - b;
                3'b010: c = a & b;
                3'b011: c = ~(a & b);
                3'b100: c = a | b;
                3'b101: c = ~(a | b);
                3'b110: c = a ^ b;
                3'b111: c = ~(a ^ b);
                endcase
            end
            1'b0: begin
                case(ire[12:10])
                3'b000: c = a + k;  
                3'b001: c = a - k;
                3'b010: c = a & k;
                3'b011: c = ~(a & k);
                3'b100: c = a | k;
                3'b101: c = ~(a | k);
                3'b110: c = a ^ k;
                3'b111: c = ~(a ^ k);
                endcase
            end
            endcase
        end

    endtask

    task mem;
        
        input r_wbar;

        begin
            case(r_wbar)
            1'b1: edb = m[eab];
            1'b0: m[eab] = edb;
            endcase
        end

    endtask

    task instruction_decode;
        
        case(ire[5:4])
        2'b00: begin 
            casex(ire[15:10]) 
            6'b000xxx: ib = oprr1;
            6'b001000: ib = popr1;
            6'b001001: ib = push1;
            6'b010000: ib = ldrr1;
            6'b010001: ib = strr1;
            default: error = 1'b1;
            endcase
        end
        2'b01: begin
            casex (ire[15:10])
            6'b000xxx: begin ib = adrm1; sb = oprm1; end
            6'b001001: ib = push1;
            6'b001000: ib = popr1;
            6'b010000: begin ib = adrm1; sb = ldrm1; end   
            6'b010001: begin ib = adrm1; sb = strm1; end
            6'b011000: begin ib = adrm1; sb = brzz1; end
            6'b011001: begin ib = adrm1; sb = test1; end  
            default: error = 1'b1;   
            endcase
        end    
            
        2'b10: begin
            casex (ire[15:10])
            6'b000xxx: begin ib = abdm1; sb = oprm1; end
            6'b001001: ib = push1;
            6'b001000: ib = popr1;
            6'b010000: begin ib = abdm1; sb = ldrm1; end   
            6'b010001: begin ib = abdm1; sb = strm1; end
            6'b011001: begin ib = abdm1; sb = test1; end
            default: error = 1'b1;
            endcase
        end

        default: error = 1'b1;

        endcase
    
    endtask

endmodule
