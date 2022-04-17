module state_rtl(clock);
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

    //ALU: 00: Add 0; 01: Add +1; 10: Add -1; 11: Contents from A and B buses

    always @ (posedge clock) begin
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
                if(flag_z = 1)
                    bc_addr = brzz2;
                else if (flag_z = 0)
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
                memory(read)
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
endmodule