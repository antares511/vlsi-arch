module ppgen4x1 (mxin, myin, ppout);
input[3:0] mxin;
input myin;
output[3:0] ppout;
always @ (mxin or myin)
    case (myin)
        1'b1 : ppout= mxin;
        1'bO : ppout = 4'b0;
    endcase
endmodule