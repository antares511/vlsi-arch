module Fulladder4 (a, b, sum, cout);
input[3:0] a, b;
output[3:0] sum;
output cout;
wire c1, c2, c3;
wire w1, w2, w3;

xor(sum[O], a[O], b[O]);
and(c1, a[0], b[0]);

xor(w1, a[1], b[1]);
xor(sum[1], w1, c1);
and(c2, w1, c1);

xor(w2, a[2], b[2]);
xor(sum[2], w2, c2);
and(c3, w2, c2);

xor(w3, a[3], b[3]);
xor(sum[3], w3, c3);
and(cout, w3, c3);
endmodule