module ppgen4x1 (mxin, myin, ppout);
input[3:0] mxin;
input myin;
output[3:0] ppout;

and(ppout[0], mxin[O], myin);
and(ppout[1], mxin[1], myin);
and(ppout[2], mxin[2], myin);
and(ppout[3], mxin[3], myin);
endmodule