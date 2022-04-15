module Fulladder1(a, b, cin, cout, sum);
    input a, b, cin;
    output reg cout, sum;
    always @ (a or b or cin)
        begin
            sum = a ^ b ^ cin;
            cout = a & b | b & cin | cin & a;
        end
endmodule

module Fulladder4(a, b, sum, cout);
    input [3:0] a;
    input [3:0] b;
    output cout;
    output [3:0] sum;
    wire d,e,f;

    Fulladder1 f1 (a[0], b[0], 1'b0, d, sum[0]);
    Fulladder1 f2 (a[1], b[1], d, e, sum[1]);
    Fulladder1 f3 (a[2], b[2], e, f, sum[2]);
    Fulladder1 f4 (a[3], b[3], f, cout, sum[3]);
endmodule