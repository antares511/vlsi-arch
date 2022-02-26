module Fulladder1(a, b, cin, cout, sum);
input a, b, cin;
output cout, sum;
reg cout_reg, sum_reg;
always @ (a or b or cin)
begin
    sum_reg = a ^ b ^ cin;
    cout_reg = a & b | b & cin | cin & a;
end
assign cout = cout_reg;
assign sum = sum_reg;
endmodule

module Fulladder4(a, b, cout, sum);
input [3:0] a;
input [3:0] b;
output cout;
output [3:0] sum;
wire d,e,f;

Fulladder1 f1 (a[0], b[0], 1'bO, d, sum[0]);
Fulladder1 f2 (a[1], b[1], d, e, sum[1]);
Fulladder1 f3 (a[2], b[2], e, f, sum[2]);
Fulladder1 f4 (a[3], b[3], f, cout, sum[3]);
endmodule
