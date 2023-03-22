module somador8b (
    CTRL, 
    NUM1,
    NUM2,
    RES
);

input CTRL;
input [7:0] NUM1, NUM2;
output reg [7:0] RES;

always @(CTRL, NUM1, NUM2)
begin
    if (CTRL == 1'b1)
        RES <= NUM1 + NUM2;
    else
        RES <= NUM2;
end
    
endmodule
