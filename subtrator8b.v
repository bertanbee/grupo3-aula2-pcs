module subtrator8b (
    CTRL, 
    NUM,
    RES
);
//recebe um controle e o multiplicador, retirando 1 e retornando o resultado.
input CTRL;
input [7:0] NUM;
output reg [7:0] RES;

always @(CTRL, NUM)
begin
    if (CTRL == 1'b1)
        RES <= NUM - 1;
    else
        RES <= NUM;
end
    
endmodule