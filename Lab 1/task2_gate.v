module Fulladder4 (a, b, sum, cout);
input[3:0] a, b;
output[3:0] sum;
output cout;
wire c1, c2, c3;
wire[9:0] w;

xor(sum[O], a[O], b[O]);
and(c1, a[0], b[0]);

xor(sum[1], a[1], b[1], c1);
and(w[1], a[1], b[1]);
and(w[2], b[1], c1);
and(w[3], c1, a[1]);
or(c2, w[1], w[2], w[3]);

xor(sum[2], a[2], b[2], c2);
and(w[4], a[2], b[2]);
and(w[5], b[2], c2);
and(w[6], c2, a[2]);
or(c3, w[4], w[5], w[6]);

xor(sum[3], a[3], b[3], c3);
and(w[7], a[3], b[3]);
and(w[8], b[3], c3);
and(w[9], c3, a[3]);
or(cout, w[7], w[8], w[9]);
endmodule