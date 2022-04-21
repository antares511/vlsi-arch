module processor(clock);

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

    always @ (*) begin
        case(TY)
            IB: next_state = ib_addr;
            SB: next_state = sb_addr;
            BC: next_state = bc_addr;
            DB: next_state = db_addr;
        endcase

        if (pc == 16'd16) begin
            error = 1'b1;
        end
    end

    always @ (posedge clock) begin

        if(error == 1'b1) begin
            $display("Error bit is set. Processor Stopped.");
            $finish;
            // code to terminate the program
        end

        state = next_state;

        case(state)
            abdm1: //abdm1
            begin
                a = pc;
                ao = a;
                alu(2'b01, 3'b000, 1'b0);
                memory(read);
                di = edb;

                TY = DB;
                db_addr = abdm2; 
            end

            abdm2: //abdm2
            begin
                a = t1;
                pc = a;

                TY = DB;
                db_addr = abdm3; 
            end

            abdm3: //abdm3
            begin
                b = di;
                a = r[ry];
                alu(2'b11, 3'b000, 1'b0);

                TY = DB;
                db_addr = abdm4; 
            end

            abdm4: //abdm4
            begin
                a = t1;
                ao = a;
                t2 = a;
                
                TY = SB;
            end

            adrm1: //adrm1
            begin
                b = r[ry];
                ao = b;
                t2 = b;
                memory(read);
                di = edb;

                TY = SB;
            end

            brzz1: //brzz1
            begin
                a = r[ry];
                ao = a;
                alu(2'b01, 3'b000, 1'b0);
                memory(read);
                irf = edb;

                instruction_decode();
                TY = BC;
                if(flag_z == 1'b1)
                    bc_addr = brzz2;
                else if (flag_z == 1'b0)
                    bc_addr = brzz3;
            end

            brzz2: //brzz2
            begin
                b = t1;
                pc = b;
                ire = irf;

                set_rx_ry();
                TY = IB;
            end

            brzz3: //brzz3
            begin
                a = pc;
                ao = a;
                alu(2'b01, 3'b000, 1'b0);
                memory(read);
                irf = edb;

                instruction_decode();
                TY = DB;
                db_addr = brzz2;
            end

            ldrm1: //ldrm1
            begin
                b = di;
                r[rx] = b;
                t2 = b;
                a = pc;
                ao = a;
                alu(2'b01, 3'b000, 1'b0);
                memory(read);
                irf = edb;

                instruction_decode();
                TY = DB;
                db_addr = ldrm2;
            end

            ldrm2: //ldrm2
            begin
                b = t1;
                pc = b;
                a = t2;
                alu(2'b00, 3'b000, 1'b1);
                ire = irf;

                set_rx_ry();
                TY = IB;
            end

            strm1: //strm1
            begin
                a = r[rx];
                b = t2;
                ao = b;
                do = a;
                edb = do;
                memory(write);
                alu(2'b00, 3'b000, 1'b1);

                TY = DB;
                db_addr = brzz3;
            end

            test1: //test1
            begin
                b = di;
                t2 = b;
                a = pc;
                ao = a;
                memory(read);
                irf = edb;
                alu(2'b01, 3'b000, 1'b0);

                instruction_decode();
                TY = DB;
                db_addr = ldrm2;
            end

            oprm1: //oprm1
            begin
                b = di;
                a = r[rx];
                alu(2'b11, ire[11:9], 1'b1);

                TY = DB;
                db_addr = oprm2;
            end

            oprm2: //oprm2
            begin
                a = t1;
                b = t2;
                ao = b;
                do = a;
                edb = do;
                memory(write);

                TY = DB;
                db_addr = brzz3;
            end

            ldrr1: //ldrr1
            begin
                a = pc;
                b = r[ry];
                ao = a;
                r[rx] = b;
                t2 = b;
                memory(read);
                irf = edb;
                alu(2'b01, 3'b000, 1'b0);

                instruction_decode();
                TY = DB;
                db_addr = ldrm2;
            end

            strr1: //strr1
            begin
                a = pc;
                b = r[rx];
                ao = a;
                r[ry] = b;
                t2 = b;
                memory(read);
                irf = edb;
                alu(2'b01, 3'b000, 1'b0);

                instruction_decode();
                TY = DB;
                db_addr = ldrm2;
            end

            popr1: //popr1
            begin
                a = r[ry];
                ao = a;
                memory(read);
                di = edb;
                alu(2'b01, 3'b000, 1'b0);

                TY = DB;
                db_addr = popr2;
            end

            popr2: //popr2
            begin
                b = di;
                a = t1;
                r[rx] = b;
                r[ry] = a;

                TY = DB;
                db_addr = brzz3;
            end

            push1: //push1
            begin
                a = r[ry];
                alu(2'b10, 3'b000, 1'b0);

                TY = DB;
                db_addr = push2;
            end

            push2: //push2
            begin
                a = r[rx];
                b = t1;
                ao = b;
                do = a;
                r[ry] = b;
                edb = do;
                memory(write);

                TY = DB;
                db_addr = brzz3;
            end

            oprr1: //oprr1
            begin
                a = r[rx];
                b = r[ry];
                alu(2'b11, ire[11:9], 1'b1);

                TY = DB;
                db_addr = oprr2;
            end

            oprr2: //oprr2
            begin
                a = pc;
                b = t1;
                r[ry] = b;
                ao = a;
                memory(read);
                irf = edb;
                alu(2'b01, 3'b000, 1'b0);

                instruction_decode();
                TY = DB;
                db_addr = brzz2;
            end
        endcase
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
                flag_v = ~(a[15] ^ alu_b[15]) & (t1[15] ^ a[15]);
                flag_z = ~|(t1);
                flag_n = t1[15];
            end
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

        default: begin
            casex(irf[15:10])
            6'b001001: ib_addr = push1;
            6'b001000: ib_addr = popr1;
            default: error = 1'b1;
            endcase
        end
        endcase
    endtask

    task set_rx_ry;
        begin
            rx = ire[9:6];
            ry = ire[3:0];
        end
    endtask

endmodule