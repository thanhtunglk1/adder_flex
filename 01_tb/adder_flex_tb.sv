`timescale 1ns / 1ps

module adder_flex_tb;
    // Tham số và biến
    parameter WIDTH = 10;
    parameter CLK_PERIOD = 10; // Chu kỳ clock 10ns

    // Đầu vào
    logic [WIDTH-1:0] i_a;
    logic [WIDTH-1:0] i_b;
    logic i_cin;
    // Đầu ra
    logic [WIDTH-1:0] o_s;
    logic o_cout;
    // Kết quả mong đợi
    logic [WIDTH-1:0] expected_s;
    logic expected_cout;

    // Khởi tạo module adder_flex
    adder_flex #(
        .WIDTH(WIDTH)
    ) uut (
        .i_a(i_a),
        .i_b(i_b),
        .i_cin(i_cin),
        .o_s(o_s),
        .o_cout(o_cout)
    );

    // Clock generation (dùng để đồng bộ nếu cần)
    logic clk;
    initial begin
        clk = 0;
        forever #(CLK_PERIOD/2) clk = ~clk;
    end

    // Hàm kiểm tra kết quả
    task check_result;
        input [WIDTH-1:0] exp_s;
        input exp_cout;
        begin
            if (o_s !== exp_s || o_cout !== exp_cout) begin
                $display("ERROR at time %9t: i_a=%b, i_b=%b, i_cin=%b", $time, i_a, i_b, i_cin);
                $display("  Expected: o_s=%b, o_cout=%b", exp_s, exp_cout);
                $display("  Got:      o_s=%b, o_cout=%b", o_s, o_cout);
                $stop;
            end else begin
                $display("PASS at time %9t: i_a=%b, i_b=%b, i_cin=%b, o_s=%b, o_cout=%b",
                         $time, i_a, i_b, i_cin, o_s, o_cout);
            end
        end
    endtask

    // Kịch bản kiểm tra
    initial begin
        // Khởi tạo đầu vào
        i_a = 0;
        i_b = 0;
        i_cin = 0;

        // Đợi một chút để ổn định
        #10;

        // Test case 1: Cộng 0 + 0 với carry-in = 0
        i_a = 0;
        i_b = 0;
        i_cin = 0;
        {expected_cout, expected_s} = i_a + i_b + i_cin;
        #10;
        check_result(expected_s, expected_cout);

        // Test case 2: Cộng 0 + 0 với carry-in = 1
        i_a = 0;
        i_b = 0;
        i_cin = 1;
        {expected_cout, expected_s} = i_a + i_b + i_cin;
        #10;
        check_result(expected_s, expected_cout);

        // Test case 3: Cộng giá trị biên (tất cả 1)
        i_a = {WIDTH{1'b1}}; // Tất cả bit là 1
        i_b = {WIDTH{1'b1}};
        i_cin = 0;
        {expected_cout, expected_s} = i_a + i_b + i_cin;
        #10;
        check_result(expected_s, expected_cout);

        // Test case 4: Cộng giá trị biên với carry-in = 1
        i_a = {WIDTH{1'b1}};
        i_b = {WIDTH{1'b1}};
        i_cin = 1;
        {expected_cout, expected_s} = i_a + i_b + i_cin;
        #10;
        check_result(expected_s, expected_cout);

        // Test case 5: Cộng ngẫu nhiên
        repeat(10) begin
            i_a = $random;
            i_b = $random;
            i_cin = $random;
            {expected_cout, expected_s} = i_a + i_b + i_cin;
            #10;
            check_result(expected_s, expected_cout);
        end

        // Test case 6: Cộng số nhỏ với số lớn
        i_a = 1;
        i_b = {WIDTH{1'b1}};
        i_cin = 0;
        {expected_cout, expected_s} = i_a + i_b + i_cin;
        #10;
        check_result(expected_s, expected_cout);

        // Kết thúc mô phỏng
        $display("All tests passed!");
        $finish;
    end
endmodule