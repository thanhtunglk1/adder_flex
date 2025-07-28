module cla_4 (
    input  logic [3:0] a    ,
    input  logic [3:0] b    ,
    input  logic       cin  ,
    output logic [3:0] s    ,
    output logic       cout
);

    logic [3:0] p, g;
    logic [4:0] c;

    always_comb begin : proc_cla_cell
        p = a ^ b; // Propagate
        g = a & b; // Generate    
    end
    
    always_comb begin : proc_carry_generation_logic
        c[0] = cin;
        c[1] = g[0] | (p[0] & c[0]);
        c[2] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & c[0]);
        c[3] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & c[0]);
        c[4] = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]) | (p[3] & p[2] & p[1] & p[0] & c[0]);
    end

    assign s    = p ^ c[3:0]; // Sum
    assign cout = c[4];
   
endmodule