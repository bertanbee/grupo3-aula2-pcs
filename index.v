`include "controle.v"
`include "somador8b.v"
`include "subtrator8b.v"

module index (
    A, B, RESET,
    PR,
    CLK 
);
    input [7:0] A, B;
    input RESET, CLK;
    output reg [7:0] PR;

    reg [7:0] AR, BR;

    wire [7:0] RES_SUB, RES_SUM;
    wire SAID, LOAD;
    
    controle controle (.CLK(CLK), .RESET(RESET), .SAIDA(SAIDA), .LOAD(LOAD));
    somador8b somador8b (.CTRL(SAIDA), .NUM1(BR), .NUM2(PR), .RES(RES_SUM));
    subtrator8b subtrator8b (.CTRL(SAIDA), .NUM(AR), .RES(RES_SUB));

    always @(posedge CLK)
    begin
        if (LOAD === 1'b1)
            begin
                AR <= B;
                BR <= A;
                PR <= 8'b0;
            end
        else    
            begin
                PR <= RES_SUM;
                AR <= RES_SUB;
            end
    end
endmodule