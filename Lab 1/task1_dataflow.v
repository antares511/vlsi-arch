module ppgen4x1 (mxin, myin, ppout);
input[3:0] mxin;
input myin;
output[3:0] ppout;

assign ppout[O] = mxin[O] & myin;
assign ppout[1] = mxin[1] & myin;
assign ppout[2] = mxin[2] & myin;
assign ppout[3] = mxin[3] & myin;
endmodule