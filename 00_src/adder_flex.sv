module adder_flex #(
    parameter WIDTH = 8
)(
    input  logic [WIDTH - 1:0] i_a   ,
    input  logic [WIDTH - 1:0] i_b   ,
    input  logic               i_cin ,
    output logic [WIDTH - 1:0] o_s   ,
    output logic               o_cout
);

    localparam QUOTIENT  = (WIDTH + 3)/4;
    localparam REMAINDER = WIDTH - (QUOTIENT - 1)*4;
    
    logic [QUOTIENT - 1:0] carry;

    genvar i;
    generate
        if(WIDTH == 1) begin
            fa_1 add (
                .a   (i_a),
                .b   (i_b),
                .cin (i_cin),
                .s   (o_s),
                .cout(o_cout)
            );
        end else if(WIDTH == 2) begin
            cla_2 add (
                .a   (i_a),
                .b   (i_b),
                .cin (i_cin),
                .s   (o_s),
                .cout(o_cout)
            );
        end else if(WIDTH == 3) begin
            cla_3 add (
                .a   (i_a),
                .b   (i_b),
                .cin (i_cin),
                .s   (o_s),
                .cout(o_cout)
            );
        end else if(WIDTH == 4) begin
            cla_4 add (
                .a   (i_a),
                .b   (i_b),
                .cin (i_cin),
                .s   (o_s),
                .cout(o_cout)
            );
        end else begin
            assign carry[0] = i_cin;

            for(i = 0; i < QUOTIENT - 1; i++) begin
                cla_4 add4 (
                .a   (i_a[(i*4) +:4]),
                .b   (i_b[(i*4) +:4]),
                .cin (carry[i]),
                .s   (o_s[(i*4) +:4]),
                .cout(carry[i + 1])
            );
            end

            if(REMAINDER == 1) begin
                fa_1 add (
                    .a   (i_a[WIDTH - 1]),
                    .b   (i_b[WIDTH - 1]),
                    .cin (carry[QUOTIENT - 1]),
                    .s   (o_s[WIDTH - 1]),
                    .cout(o_cout)
                );
            end else if(REMAINDER == 2) begin
                cla_2 add (
                    .a   (i_a[WIDTH - 1:WIDTH - 2]),
                    .b   (i_b[WIDTH - 1:WIDTH - 2]),
                    .cin (carry[QUOTIENT - 1]),
                    .s   (o_s[WIDTH - 1:WIDTH - 2]),
                    .cout(o_cout)
                );
            end else if(REMAINDER == 3) begin
                cla_3 add (
                    .a   (i_a[WIDTH - 1:WIDTH - 3]),
                    .b   (i_b[WIDTH - 1:WIDTH - 3]),
                    .cin (carry[QUOTIENT - 1]),
                    .s   (o_s[WIDTH - 1:WIDTH - 3]),
                    .cout(o_cout)
                );
            end else if(REMAINDER == 4) begin
                cla_4 add (
                    .a   (i_a[WIDTH - 1:WIDTH - 4]),
                    .b   (i_b[WIDTH - 1:WIDTH - 4]),
                    .cin (carry[QUOTIENT - 1]),
                    .s   (o_s[WIDTH - 1:WIDTH - 4]),
                    .cout(o_cout)
                );
            end
        end  
    endgenerate

endmodule

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