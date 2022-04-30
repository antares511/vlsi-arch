module cash_register(clock, barcode, reset_b, cancel_b, end_b, amount);
    input clock, reset_b, cancel_b, end_b;
    input [15:0] barcode;

    reg [1:0] state;
    reg [1:0] next_state;
    reg carry;

    parameter S0 = 2'b00, S1 = 2'b01, S2 = 2'b10, S3 = 2'b11;

    output reg [15:0] amount;

    always @ (posedge reset_b or posedge end_b or posedge cancel_b) begin
        if(reset_b)
            next_state = S0;
        else if(end_b)
            next_state = S3;
        else if(cancel_b)
            next_state = S2;
        else
            next_state = S1;
    end

    always @ (posedge clock) begin

        state = next_state;

        case(state)
            S0: begin
                    amount = 16'd0;
                    next_state = S1;
                end
            S1: begin
                    adder(1'b0);
                end
            S2: begin
                    adder(1'b1);
                    next_state = S1;
                end
            S3: begin
                    $display("Total amount = %d", amount);
                    $finish;
                end
        endcase
    end

    task adder;
        input control;

        begin
            case(control)
                1'b0: {carry, amount} = amount + barcode;
                1'b1: {carry, amount} = amount - barcode;
            endcase
        end
    endtask

endmodule