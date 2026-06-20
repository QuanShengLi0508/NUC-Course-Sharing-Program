`timescale 1ns/1ns

module decode47_tb;
    reg [3:0] input_bcd;
    wire a, b, c, d, e, f, g;
    
    // 实例化被测试模块 - 修正了实例化语法
    decode47 uut(
        .a(a), 
        .b(b), 
        .c(c), 
        .d(d), 
        .e(e), 
        .f(f), 
        .g(g),
        .D3(input_bcd[3]), 
        .D2(input_bcd[2]), 
        .D1(input_bcd[1]), 
        .D0(input_bcd[0])
    );
    
    // 生成测试激励
    initial begin
        $monitor("Time=%0t, BCD=%b, Segments={a=%b, b=%b, c=%b, d=%b, e=%b, f=%b, g=%b}", 
                 $time, input_bcd, a, b, c, d, e, f, g);
        
        // 测试所有可能的输入
        input_bcd = 0;
        repeat(16) begin
            #10 input_bcd = input_bcd + 1;
        end
        
        #10 $finish;
    end
    
    // 生成波形文件
    initial begin
        $dumpfile("decode47_tb.vcd");
        $dumpvars(0, decode47_tb);
    end
    
endmodule