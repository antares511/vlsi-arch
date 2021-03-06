module execution(clock);

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

    parameter write = 1'b0;
    parameter read = 1'b1;

    parameter IB = 2'b00;
    parameter SB = 2'b01;
    parameter BC = 2'b10;
    parameter DB = 2'b11;

    input clock;

    reg [15:0] r [0:15];
    reg [15:0] t1, t2;
    reg [15:0] m [0:31];
    reg [15:0] a, b, eab, edb;
    reg [15:0] pc, ao, di, do, irf, ire;
    reg [4:0] ib_addr, sb_addr, bc_addr, db_addr, state, next_state;
    reg [3:0] rx, ry;
    reg [1:0] TY;
    
    reg error, flag_v, flag_n, flag_z, flag_c, carry;
    reg [15:0] alu_b;

    //FOR TESTING PURPOSES ONLY
    reg r_wbar;

    always @ (*) begin
        case(TY)
            IB: next_state = ib_addr;
            SB: next_state = sb_addr;
            BC: next_state = bc_addr;
            DB: next_state = db_addr;
        endcase
    end

    always @ (posedge clock) begin

        state = next_state;

        memory(r_wbar);      //FOR TESTING PURPOSES ONLY
    end



    task alu;    
        input [1:0] b_kbar;
        input [2:0] op;
        input set_flag;

        begin  
            case(b_kbar)
            2'b00: alu_b = 16'h0000;
            2'b01: alu_b = 16'h0001;
            2'b10: alu_b = 16'hffff;                
            2'b11: alu_b = b;    
            endcase  
            
            case(op)
            3'b000: {carry, t1} = a + alu_b;  
            3'b001: {carry, t1} = a - alu_b;
            3'b010: t1 = a & alu_b;
            3'b011: t1 = ~(a & alu_b);
            3'b100: t1 = a | alu_b;
            3'b101: t1 = ~(a | alu_b);
            3'b110: t1 = a ^ alu_b;
            3'b111: t1 = ~(a ^ alu_b);
            endcase
           

            if (set_flag == 1'b1) begin
                flag_c = carry;
                flag_v = ~(a[15] ^ alu_b[15]) & (t1[15] ^ (~(a[15] ^ alu_b[15])));
                flag_z = ~|(t1);
                flag_n = t1[15];
            end else 
            {flag_c, flag_v, flag_z, flag_n} = 4'b0000;
        end

    endtask

    task memory;
        
        input r_wbar;

        begin
            case(r_wbar)
            read: edb = m[ao];
            write: m[ao] = edb;
            endcase
        end

    endtask

    task instruction_decode;
        
        case(irf[5:4])
        2'b00: begin 
            casex(irf[15:10]) 
            6'b000xxx: ib_addr = oprr1;
            6'b001000: ib_addr = popr1;
            6'b001001: ib_addr = push1;
            6'b010000: ib_addr = ldrr1;
            6'b010001: ib_addr = strr1;
            default: error = 1'b1;
            endcase
        end
        2'b01: begin
            casex (irf[15:10])
            6'b000xxx: begin ib_addr = adrm1; sb_addr = oprm1; end
            6'b001001: ib_addr = push1;
            6'b001000: ib_addr = popr1;
            6'b010000: begin ib_addr = adrm1; sb_addr = ldrm1; end   
            6'b010001: begin ib_addr = adrm1; sb_addr = strm1; end
            6'b011000: begin ib_addr = adrm1; sb_addr = brzz1; end
            6'b011001: begin ib_addr = adrm1; sb_addr = test1; end  
            default: error = 1'b1;   
            endcase
        end    
            
        2'b10: begin
            casex (irf[15:10])
            6'b000xxx: begin ib_addr = abdm1; sb_addr = oprm1; end
            6'b001001: ib_addr = push1;
            6'b001000: ib_addr = popr1;
            6'b010000: begin ib_addr = abdm1; sb_addr = ldrm1; end   
            6'b010001: begin ib_addr = abdm1; sb_addr = strm1; end
            6'b011001: begin ib_addr = abdm1; sb_addr = test1; end
            default: error = 1'b1;
            endcase
        end

        default: error = 1'b1;

        endcase

    endtask

    task set_rx_ry;
    begin
        rx = ire[9:6];
        ry = ire[3:0];
    end
    endtask

endmodule
