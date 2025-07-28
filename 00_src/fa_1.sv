module fa_1(
    input  logic a,
    input  logic b,
    input  logic cin,
    output logic s,
    output logic cout
);

    logic  p;
    assign p    = a ^ b;
    assign s    = p ^ cin;
    assign cout = (p & cin) | (a & b);

endmodule