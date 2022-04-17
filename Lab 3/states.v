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

    always @ (posedge clock) begin
        case(state)
            abdm1: //abdm1
            begin
                a = pc;
                ao = a;
                //alu(k+1, unsign_add);
                //memory(read);
                di = edb;
            end

            abdm2: //abdm2
            begin
                a = t1;
                pc = a;
            end

            abdm3: //abdm3
            begin
                b = di;
                a = r[ry];
                //alu(ab, unsign_add);
            end

            abdm4: //abdm4
            begin
                a = t1;
                ao = a;
                t2 = a;
                
            end

            adrm1: //adrm1
            begin
                b = r[ry];
                ao = b;
                t2 = b;
                //memory(read);
                di = edb;
            end

            brzz1: //brzz1
            begin
                a = r[ry];
                ao = a;
                //alu(k+1, unsign_add);
                //memory(read);
                irf = edb;
            end

            brzz2: //brzz2
            begin
                ire = irf;
                b = t1;
                pc = b;
            end

            brzz3: //brzz3
            begin
                a = pc;
                ao = a;
                //alu(k+1, unsign_add);
                //memory(read);
                irf = edb;
            end

            ldrm1: //ldrm1
            begin
                b = di;
                r[rx] = b;
                t2 = b;
                a = pc;
                ao = a;
                //alu(k+1, unsign_add);
                //memory(read);
                irf = edb;
            end

            ldrm2: //ldrm2
            begin
                ire = irf;
                b = t1;
                pc = b;
                a = t2;
                //alu(k0, signed_add);
            end

            strm1: //strm1
            begin
                a = r[rx];
                b = t2;
                ao = b;
                do = a;
                //memory(write);
                //alu(k0, signed_add);
            end

            test1: //test1
            begin
                b = di;
                t2 = b;
                a = pc;
                ao = a;
                //memory(read)
                irf = edb;
                //alu(k+1, unsigned_add);
            end

            oprm1: //oprm1
            begin
                b = di;
                a = r[rx];
                //alu(ab, operation);
            end

            oprm2: //oprm2
            begin
                a = t1;
                b = t2;
                ao = b;
                do = a;
                //memory(write);
            end

            ldrr1: //ldrr1
            begin
                a = pc;
                b = r[ry];
                ao = a;
                r[rx] = b;
                t2 = b;
                //memory(read);
                irf = edb;
                //alu(k+1, unsigned_add);
            end

            strr1: //strr1
            begin
                a = pc;
                b = r[rx];
                ao = a;
                r[ry] = b;
                t2 = b;
                //memory(read);
                irf = edb;
                //alu(k+1, unsigned_add);
            end

            popr1: //popr1
            begin
                a = r[ry];
                ao = a;
                //memory(read);
                di = edb;
                //alu(k+1, unsigned_add);
            end

            popr2: //popr2
            begin
                b = di;
                a = t1;
                r[rx] = b;
                r[ry] = a;
            end

            push1: //push1
            begin
                a = r[ry];
                //alu(k-1, unsigned_add);
            end

            push2: //push2
            begin
                a = r[rx];
                b = t1;
                ao = b;
                do = a;
                r[ry] = b;
                //memory(write);
            end

            oprr1: //oprr1
            begin
                a = r[rx];
                b = r[ry];
                //alu(ab, operation_s);
            end

            oprr2: //oprr2
            begin
                a = pc;
                b = t1;
                r[ry] = b;
                ao = a;
                //memory(read);
                irf = edb;
                //alu(k+1, unsigned_add);
            end
        endcase
    end
endmodule