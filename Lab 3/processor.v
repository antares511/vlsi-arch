module processor(clock);
    
    input clock;
    reg [15:0] r [0:15];                                //registers        
    reg [15:0] t [0:1];                                 //temporary registers
    reg [15:0] pc, ao, di, do, irf, ire;                //other registers
    reg [15:0] mem [0:31];                              //Data Memory
    wire [15:0] k;
    wire [15:0] a, b, eab, edb;                         //Buses
    

    //INTERMEDIATE WIRES
    wire [15:0] wr_r_in, wr_r_inf [0:15];               //in refers to data before after mux, before switch, inf refers to data at input of reg
    wire [15:0] wr_t1_in, wr_t1_inf;
    wire [15:0] wr_t2_in, wr_t2_inf;                    
    wire [15:0] wr_pc_in, wr_pc_inf;                    
    wire [15:0] wr_ao_in, wr_ao_inf; 
    wire [15:0] ALU_in_2;
    
    
    //CONTROL SIGNALS
    wire [15:0] wr_r_a_b, wr_r, rd_r_a, rd_r_b;         //read and write signals for registers, a_b is 1 for a
    wire [1:0] rd_t_a, rd_t_b;                          //read signals for temporary registers
    wire rd_pc, rd_di, rd_ao, rd_do;                    //more read signals                                       
    wire wr_t1, wr_t2, wr_t2_a_b;                       //write signals for temporary registers
   
    wire [2:0] alu_op;                                  //ALU function
    wire [1:0] k_val;                                   //Value of k
    wire ALU_in_2_sel;                                  //Chooses input as bus b or constant k
    wire wr_irf, wr_ire, wr_di, wr_do, wr_pc, wr_pc_a_b, wr_ao, wr_ao_a_b;    //write control signals
    
    
    //COMBINATIONAL READ AND WRITE LOGIC
    //Write input before switch
    assign wr_r_in[0] = wr_r_a_b[0] ? a : b;
    assign wr_r_in[1] = wr_r_a_b[1] ? a : b;
    assign wr_r_in[2] = wr_r_a_b[2] ? a : b;
    assign wr_r_in[3] = wr_r_a_b[3] ? a : b;
    assign wr_r_in[4] = wr_r_a_b[4] ? a : b;
    assign wr_r_in[5] = wr_r_a_b[5] ? a : b;
    assign wr_r_in[6] = wr_r_a_b[6] ? a : b;
    assign wr_r_in[7] = wr_r_a_b[7] ? a : b;
    assign wr_r_in[8] = wr_r_a_b[8] ? a : b;
    assign wr_r_in[9] = wr_r_a_b[9] ? a : b;
    assign wr_r_in[10] = wr_r_a_b[10] ? a : b;
    assign wr_r_in[11] = wr_r_a_b[11] ? a : b;
    assign wr_r_in[12] = wr_r_a_b[12] ? a : b;
    assign wr_r_in[13] = wr_r_a_b[13] ? a : b;
    assign wr_r_in[14] = wr_r_a_b[14] ? a : b;
    assign wr_r_in[15] = wr_r_a_b[15] ? a : b;
    
    assign wr_t2_in = wr_t2_a_b ? a : b;
    assign wr_pc_in = wr_pc_a_b ? a : b;
    assign wr_ao_in = wr_ao_a_b ? a : b;

    //Actual write input
    assign wr_r_inf[0] = wr_r[0] ? wr_r_in[0] : wr_r_inf[0];
    assign wr_r_inf[1] = wr_r[1] ? wr_r_in[1] : wr_r_inf[1];
    assign wr_r_inf[2] = wr_r[2] ? wr_r_in[2] : wr_r_inf[2];
    assign wr_r_inf[3] = wr_r[3] ? wr_r_in[3] : wr_r_inf[3];
    assign wr_r_inf[4] = wr_r[4] ? wr_r_in[4] : wr_r_inf[4];
    assign wr_r_inf[5] = wr_r[5] ? wr_r_in[5] : wr_r_inf[5];
    assign wr_r_inf[6] = wr_r[6] ? wr_r_in[6] : wr_r_inf[6];
    assign wr_r_inf[7] = wr_r[7] ? wr_r_in[7] : wr_r_inf[7];
    assign wr_r_inf[8] = wr_r[8] ? wr_r_in[8] : wr_r_inf[8];
    assign wr_r_inf[9] = wr_r[9] ? wr_r_in[9] : wr_r_inf[9];
    assign wr_r_inf[10] = wr_r[10] ? wr_r_in[10] : wr_r_inf[10];
    assign wr_r_inf[11] = wr_r[11] ? wr_r_in[11] : wr_r_inf[11];
    assign wr_r_inf[12] = wr_r[12] ? wr_r_in[12] : wr_r_inf[12];
    assign wr_r_inf[13] = wr_r[13] ? wr_r_in[13] : wr_r_inf[13];
    assign wr_r_inf[14] = wr_r[14] ? wr_r_in[14] : wr_r_inf[14];
    assign wr_r_inf[15] = wr_r[15] ? wr_r_in[15] : wr_r_inf[15];
    
    assign wr_t1_inf = wr_t1 ? wr_t1_in : wr_t1_inf;
    assign wr_t2_inf = wr_t2 ? wr_t2_in : wr_t2_inf;
    assign wr_pc_inf = wr_pc ? wr_pc_in : wr_pc_inf;
    assign wr_ao_inf = wr_ao ? wr_ao_in : wr_ao_inf;
    
    assign wr_do_in = wr_do ? b : wr_do_in;
    assign wr_di_in = wr_di ? edb : wr_di_in;
    assign wr_ire_in = wr_ire ? irf : wr_ire_in;
    assign wr_irf_in = wr_irf ? edb : wr_irf_in;

    //Choosing ALU input
    assign ALU_in_2 = ALU_in_2_sel ? k : b ; 

    //instantiating ALU
    ALU alu (.InA(a), .InB(ALU_in_2), .Op(alu_op), .Out(wr_t1_in));

    //Assigning inputs to bus A
    assign a = rd_r_a[0] ? r[0] : 16'hzzzz;
    assign a = rd_r_a[1] ? r[1] : 16'hzzzz;
    assign a = rd_r_a[2] ? r[2] : 16'hzzzz;
    assign a = rd_r_a[3] ? r[3] : 16'hzzzz;
    assign a = rd_r_a[4] ? r[4] : 16'hzzzz;
    assign a = rd_r_a[5] ? r[5] : 16'hzzzz;
    assign a = rd_r_a[6] ? r[6] : 16'hzzzz;
    assign a = rd_r_a[7] ? r[7] : 16'hzzzz;
    assign a = rd_r_a[8] ? r[8] : 16'hzzzz;
    assign a = rd_r_a[9] ? r[9] : 16'hzzzz;
    assign a = rd_r_a[10] ? r[10] : 16'hzzzz;
    assign a = rd_r_a[11] ? r[11] : 16'hzzzz;
    assign a = rd_r_a[12] ? r[12] : 16'hzzzz;
    assign a = rd_r_a[13] ? r[13] : 16'hzzzz;
    assign a = rd_r_a[14] ? r[14] : 16'hzzzz;
    assign a = rd_r_a[15] ? r[15] : 16'hzzzz;
    
    assign a = rd_t_a[0] ? t[0] : 16'hzzzz;
    assign a = rd_t_a[1] ? t[1] : 16'hzzzz;
    
    assign a = rd_pc ? pc : 16'hzzzz;


    //Assigning inputs to bus B
    assign b = rd_r_b[0] ? r[0] : 16'hzzzz;
    assign b = rd_r_b[1] ? r[1] : 16'hzzzz;
    assign b = rd_r_b[2] ? r[2] : 16'hzzzz;
    assign b = rd_r_b[3] ? r[3] : 16'hzzzz;
    assign b = rd_r_b[4] ? r[4] : 16'hzzzz;
    assign b = rd_r_b[5] ? r[5] : 16'hzzzz;
    assign b = rd_r_b[6] ? r[6] : 16'hzzzz;
    assign b = rd_r_b[7] ? r[7] : 16'hzzzz;
    assign b = rd_r_b[8] ? r[8] : 16'hzzzz;
    assign b = rd_r_b[9] ? r[9] : 16'hzzzz;
    assign b = rd_r_b[10] ? r[10] : 16'hzzzz;
    assign b = rd_r_b[11] ? r[11] : 16'hzzzz;
    assign b = rd_r_b[12] ? r[12] : 16'hzzzz;
    assign b = rd_r_b[13] ? r[13] : 16'hzzzz;
    assign b = rd_r_b[14] ? r[14] : 16'hzzzz;
    assign b = rd_r_b[15] ? r[15] : 16'hzzzz;
    
    assign b = rd_t_b[0] ? t[0] : 16'hzzzz;
    assign b = rd_t_b[1] ? t[1] : 16'hzzzz;
    
    assign b = rd_pc ? pc : 16'hzzzz;
    assign b = rd_di ? di : 16'hzzzz;
    
    //Assigning inputs to EAB and EDB
    assign eab = rd_ao ? ao : 16'hzzzz;
    assign edb = rd_do ? do : 16'hzzzz;
    
    //Accessing memory
    assign edb = rd_ao ? mem[eab] : edb;

    //Setting k val
    assign k = k_val[1] ? 16'hffff : (k_val[0] ? 16'h0001 : 16'h0000) ;

    //Clocked register transfers
    always @ (posedge clock) begin
    
        r[0] <= wr_r_inf[0];
        r[1] <= wr_r_inf[1];
        r[2] <= wr_r_inf[2];
        r[3] <= wr_r_inf[3];
        r[4] <= wr_r_inf[4];
        r[5] <= wr_r_inf[5];
        r[6] <= wr_r_inf[6];
        r[7] <= wr_r_inf[7];
        r[8] <= wr_r_inf[8];
        r[9] <= wr_r_inf[9];
        r[10] <= wr_r_inf[10];
        r[11] <= wr_r_inf[11];
        r[12] <= wr_r_inf[12];
        r[13] <= wr_r_inf[13];
        r[14] <= wr_r_inf[14];
        r[15] <= wr_r_inf[15];

        t[0] <= wr_t1_inf;
        t[1] <= wr_t2_inf;

        pc <= wr_pc_inf;
        ao <= wr_ao_inf;
        di <= wr_di_in;
        do <= wr_do_in;
        irf <= wr_irf_in;
        ire <= wr_ire_in;

    end


endmodule

module ALU (InA, InB, Op, Out);

    input [15:0] InA, InB;
    input [2:0] Op;
    output [15:0] Out;

    wire [15:0] ALU_Xnor, ALU_Xor, ALU_Nor, ALU_Or, ALU_Nand, ALU_And, ALU_AddSub, InB2;
    wire signB;

    assign sub = (~(Op[2]) & ~(Op[1]) & Op[0]) ;

    assign InB2 = {16{sub}}^(InB) + {15'h0000, sub};
    

    assign ALU_Xnor = ~(InA^InB);
    assign ALU_Xor = (InA^InB);
    assign ALU_Nor = ~(InA|InB);
    assign ALU_Or = (InA|InB);
    assign ALU_Nand = ~(InA&InB);
    assign ALU_And = (InA&InB);
    assign ALU_AddSub = InA + InB2;
            
    assign Out = Op[2] ? ( Op[1] ? ( Op[0] ? (ALU_Xnor) : (ALU_Xor) ) : ( Op[0] ? (ALU_Nor) : (ALU_Or) ) ) : ( Op[1] ? ( Op[0] ? (ALU_Nand) : (ALU_And) ) : ( ALU_AddSub ) ) ;


endmodule
    
