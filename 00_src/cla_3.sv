module cla_3 (
    input  logic [2:0] a    ,
    input  logic [2:0] b    ,
    input  logic       cin  ,
    output logic [2:0] s    ,
    output logic       cout
);

    logic [2:0] p, g;
    logic [3:0] c;

    always_comb begin : proc_cla_cell
        p = a ^ b; // Propagate
        g = a & b; // Generate    
    end
    
    always_comb begin : proc_carry_generation_logic
        c[0] = cin;
        c[1] = g[0] | (p[0] & c[0]);
        c[2] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & c[0]);
        c[3] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & c[0]);
        
    end

    assign s    = p ^ c[2:0]; // Sum
    assign cout = c[3];
   
endmodule