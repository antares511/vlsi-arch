module ppgen4x1 (mxin, myin, ppout);
    input [3:0] mxin;
    input myin;
    output reg [3:0] ppout;
    always @ (mxin or myin)
        begin
            case (myin)
                1'b1 : ppout = mxin;
                1'b0 : ppout = 4'b0;
            endcase
        end
endmodule