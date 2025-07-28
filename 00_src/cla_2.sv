module cla_2 (
    input  logic [1:0] a    ,
    input  logic [1:0] b    ,
    input  logic       cin  ,
    output logic [1:0] s    ,
    output logic       cout
);

    logic [1:0] p, g;
    logic [2:0] c;

    always_comb begin : proc_cla_cell
        p = a ^ b; // Propagate
        g = a & b; // Generate    
    end
    
    always_comb begin : proc_carry_generation_logic
        c[0] = cin;
        c[1] = g[0] | (p[0] & c[0]); 
        c[2] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & c[0]);      
    end

    assign s    = p ^ c[1:0]; // Sum
    assign cout = c[2];
   
endmodule