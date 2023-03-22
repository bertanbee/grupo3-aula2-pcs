module moduleName ();
    reg [7:0] A, B;
    reg CLK, RESET;
    wire [7:0] PR;

    index UUT (.A(A), .B(B), .CLK(CLK), .RESET(RESET), .PR(PR));

    always #10 CLK = ~CLK;
    initial begin
        CLK = 0;
        RESET = 1;
        A = 8'd3;
        B = 8'd4;
        #10
        RESET = 0;
        #1000
        $display("%b", PR);
        $finish;
    end
endmodule