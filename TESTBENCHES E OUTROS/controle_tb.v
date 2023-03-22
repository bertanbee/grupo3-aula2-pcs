module controle_tb ();
    reg [7:0] AR;
    reg RESET, CLK;
    wire SAIDA, LOAD;

    integer errors, i;

    controle UUT(.AR(AR), .RESET(RESET), .LOAD(LOAD), .CLK(CLK), .SAIDA(SAIDA));

    task Check;
        input [1:0] expect;
        begin
            $display("Saída: %b e Load: %b", SAIDA, LOAD);
            if (expect !== {SAIDA, LOAD}) $display("Erro! expect %b !== %b saida", expect, {SAIDA, LOAD});
        end
    endtask

    always #5 CLK <= ~CLK;

    initial begin
        errors = 0;
        CLK = 0;
        RESET = 1;
        // o tempo #10 garante que o clock vai fazer a onda :D
        #10

        // aqui verifica se o reset esta fazendo ficar
        // no primeiro estado.
        // a sequencia eh {SAIDA, LOAD}
        Check(2'b01);
        #10
        RESET = 0;
        AR = 8'd0;
        #10
        // agora, o estado deve ser de soma, porque AR e zero
        Check(2'b10);
        #10
        for (i = 1; i < 8'b11111111; i = i + 1) begin
            #10
            AR = i;
            #10
            Check(2'b00);
        end
        $finish;
    end


endmodule