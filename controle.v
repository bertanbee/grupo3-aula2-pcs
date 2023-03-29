`include "controle.v"
`include "rom.v"
`include "addsub.v"

module multiplicador8b (
    START, CLK, A, B,
    DONE, RES
);
    /*
        CONFIGURACAO INICIAL
    */
    // sinal para a unidade de controle iniciar a multiplicacao
    input START;
    // este e o clock universao do circuito
    input CLK;
    // esses sao os numeros a serem multiplicados, cada um de 8 bits
    input [7:0] A, B;

    // sinal de que a multiplicacao acabou
    output DONE;
    // resposta, ela e guardada em um registrador e pode ser reutilizado
    // recebe diretamente os resultados das somas
    output reg [15:0] RES;

    /* 
        REGISTRADORES
    */
    // O registrador 1 recebe os numeros a serem multiplicados na configuracao
    // [Al,Bl, Ah, Bh], sendo l para low-bits e h para high-bits 
    // ele tambem possui um multiplexador que escolhe outras entradas pertinentes
    reg [15:0] REG1;
    // O registrador 2 recebe os resultados das multiplicacoes da ROM
    reg [15:0] REG2;

    /*
        WIRES DE CONTROLE
    */
    // controles de load de cada um dos registradores
    wire LOAD_REG1;
    wire LOAD_REG2;
    wire LOAD_REG3;
    // seta a operacao realizada pelo somador/subtrator, uma mini ALU
    wire OP;

    /*
        WIRES COM RESULTADOS
    */
    // wire com o resultado da multiplicacao da ROM
    wire [9:0] RESULTADO_ROM;
    // wire com o resultado da soma/subtracao
    wire [15:0] RESULTADO_SOMA_SUB;

    /*
        CONTROLES MUX
    */
    // controla o multiplexador do que sera escrito no registrador 1 
    wire [3:0] MUX_CONTROL_LOAD_REG1;
    // controla o mux do que entra na mini ALU
    // ARRUMAR BITS
    wire [] MUX_CONTROL_SUM_SUB;
    // controla o mux dos dados que entram na ROM
    wire [] MUX_CONTROL_ROM;

    /*
        WIRES COM RESULTADOS DOS MUX
    */
    wire [15:0] MUX_REG1_RESULT;
    wire [15:0] MUX_ROM_RESULT;
    wire [15:0] MUX_ADDSUB_RESULT;
    
    /*
        DECLARACAO DE UNIDADES EXTERNAS
    */
    // Soma e subtracao
    addsub addsub (.data1(MUX_ADDSUB_RESULT[0:7]), .data2(MUX_ADDSUB_RESULT[8:15]), .add_sub(OP),
                   .clk(CLK), .resultado(RESULTADO_SOMA_SUB));
    // ROM que multiplica 2 numeros de 5 bits
    rom_multiplicador rom_multiplicador (.Fatores(MUX_ROM_RESULT), .Produto(RESULTADO_ROM));
    // Unidade de controle do multiplicador
    controle controle (.clk(CLK), .start(START), .load_reg1(LOAD_REG1), .load_reg2(LOAD_REG2),
                       .load_reg3(LOAD_REG3), .mux_load_reg1(MUX_CONTROL_LOAD_REG1),
                       .mux_control_sum_sub(MUX_CONTROL_SUM_SUB), .mux_control_rom(MUX_CONTROL_ROM));
    /*
        Logica do circuito
    */
    always @(posedge CLK or posedge START) begin
        // load do REG1
        if (LOAD_REG1 == 1'b1)
            REG1 <= MUX_REG1_RESULT;
        if (LOAD_REG2 == 1'b1)
            REG2 <= MUX_ROM_RESULT;
        if (LOAD_REG3 == 1'b1)
            REG3 <= MUX_ADDSUB_RESULT;
        
        // logica mux do registrador 1
        // logica mux do somador/subtrator
        // logica mux da ROM
    end
    
endmodule
