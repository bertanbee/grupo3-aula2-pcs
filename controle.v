module controle (
    AR, RESET, CLK, SAIDA, LOAD
);
    // A ASM FOI MODIFICADA PARA FUNCIONAR PARA O CASO
    // NO QUAL AR E 0, O DECISOR E A JUNCAO TROCARAM DE 
    // POSICAO
    input [7:0] AR;
    input RESET, CLK;
    output reg SAIDA, LOAD;

    reg [1:0] ESTADO_ATUAL, PROX_ESTADO;

    // os estados nao estavam nomeados, entao foram dados
    // nomes genericos
    parameter ESTADO1 = 2'b00, ESTADO2 = 2'b01, ESTADOPRONTO = 2'b10;

    // primeiro block serve para verificar o reset e mudar
    // o estado para o proximo estado calculado
    always @(posedge CLK or posedge RESET)
    begin
        if (RESET == 1'b1)
            ESTADO_ATUAL <= ESTADO1;
        else 
            ESTADO_ATUAL <= PROX_ESTADO;
    end

    always @(ESTADO_ATUAL, AR)
    begin
        if (
            (ESTADO_ATUAL === ESTADO1 ||
            ESTADO_ATUAL === ESTADO2) &&
            AR === 8'd0
        )
            PROX_ESTADO <= ESTADO2;

        else
            PROX_ESTADO <= ESTADOPRONTO;
    end

    always @(ESTADO_ATUAL) begin
        case (ESTADO_ATUAL)
            // estado de carregamento
            ESTADO1:
                begin
                    SAIDA <= 1'b0;
                    LOAD <= 1'b1;
                end 
            // estado de soma
            ESTADO2: 
                begin
                    SAIDA <= 1'b1;
                    LOAD <= 1'b0;
                end 
            // estado que terminou a multiplicacao
            ESTADOPRONTO:
                begin
                    SAIDA <= 1'b0;
                    LOAD <= 1'b0;
                end 
        endcase
    end
endmodule