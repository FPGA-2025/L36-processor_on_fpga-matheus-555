module ALU_Control (
    input wire is_immediate_i,
    input wire [1:0] ALU_CO_i,
    input wire [6:0] FUNC7_i,
    input wire [2:0] FUNC3_i,
    output reg [3:0] ALU_OP_o
);

    // insira seu código aqui

    // Definição dos opcodes da ALU
    localparam ALU_OP_AND             = 4'b0000;
    localparam ALU_OP_OR              = 4'b0001;
    localparam ALU_OP_XOR             = 4'b1000;
    localparam ALU_OP_NOR             = 4'b1001;
    localparam ALU_OP_SUM             = 4'b0010;
    localparam ALU_OP_SUB             = 4'b1010;
    localparam ALU_OP_EQUAL           = 4'b0011;
    localparam ALU_OP_GREATER_EQUAL   = 4'b1100;
    localparam ALU_OP_GREATER_EQUAL_U = 4'b1101;
    localparam ALU_OP_SLT             = 4'b1110;
    localparam ALU_OP_SLT_U           = 4'b1111;
    localparam ALU_OP_SHIFT_LEFT      = 4'b0100;
    localparam ALU_OP_SHIFT_RIGHT     = 4'b0101;
    localparam ALU_OP_SHIFT_RIGHT_A   = 4'b0111;
    
    // Definição do Grupo de instruções
    localparam LOAD_STORE = 2'b00;
    localparam BRANCH     = 2'b01;
    localparam ALU        = 2'b10;

    
    // Definição das instruções FUNCT3 apenas
    localparam ALU_CONTROL_OP_BEQ  = 3'b000;
    localparam ALU_CONTROL_OP_BNE  = 3'b001;
    localparam ALU_CONTROL_OP_BLT  = 3'b100;
    localparam ALU_CONTROL_OP_BGE  = 3'b101;
    localparam ALU_CONTROL_OP_BLTU = 3'b110;
    localparam ALU_CONTROL_OP_BGEU = 3'b111;

    // Definição das instruções FUNCT7 COM FUNCT3
    //  bit09  bit08  bit07  bit06  bit05  bit04  bit03  bit02  bit01  bit00
    // [FUNCT7 FUNCT7 FUNCT7 FUNCT7 FUNCT7 FUNCT7 FUNCT7 FUNCT3 FUNCT3 FUNCT3]
    localparam ALU_CONTROL_OP_ADD  = 10'b0000000000;
    localparam ALU_CONTROL_OP_ADDI = 10'bxxxxxxx000;
    localparam ALU_CONTROL_OP_SUB  = 10'b0100000000;
    localparam ALU_CONTROL_OP_AND  = 10'b0000000111;
    localparam ALU_CONTROL_OP_OR   = 10'B0000000110;
    localparam ALU_CONTROL_OP_XOR  = 10'b0000000100;
    localparam ALU_CONTROL_OP_SLL  = 10'b0000000001;
    localparam ALU_CONTROL_OP_SRL  = 10'b0000000101;
    localparam ALU_CONTROL_OP_SRA  = 10'b0100000101;
    localparam ALU_CONTROL_OP_SLT  = 10'b0000000010;
    localparam ALU_CONTROL_OP_SLTU = 10'b0000000011;

    always @(*) begin
        case (ALU_CO_i)
            LOAD_STORE: begin
                ALU_OP_o = ALU_OP_SUM;
            end

            BRANCH: begin
                case (FUNC3_i)
                    ALU_CONTROL_OP_BNE : ALU_OP_o = ALU_OP_EQUAL;
                    ALU_CONTROL_OP_BLT : ALU_OP_o = ALU_OP_GREATER_EQUAL;
                    ALU_CONTROL_OP_BLTU: ALU_OP_o = ALU_OP_GREATER_EQUAL_U;
                    ALU_CONTROL_OP_BGE : ALU_OP_o = ALU_OP_SLT;
                    ALU_CONTROL_OP_BGEU: ALU_OP_o = ALU_OP_SLT_U;
                    default            : ALU_OP_o = ALU_OP_SUB;
                endcase
            end

            ALU: begin
                case (FUNC3_i)
                    ALU_CONTROL_OP_ADD[2:0],
                    ALU_CONTROL_OP_ADDI[2:0],
                    ALU_CONTROL_OP_SUB[2:0]: begin
                        ALU_OP_o = (is_immediate_i || FUNC7_i == ALU_CONTROL_OP_ADD[9:3]) ? ALU_OP_SUM : /*ADDI / ADD*/
                                    (FUNC7_i == ALU_CONTROL_OP_SUB[9:3])                  ? ALU_OP_SUB :
                                    ALU_OP_o;
                    end

                    ALU_CONTROL_OP_AND[2:0]: ALU_OP_o = ALU_OP_AND;
                    ALU_CONTROL_OP_OR[2:0] : ALU_OP_o = ALU_OP_OR;
                    ALU_CONTROL_OP_XOR[2:0]: ALU_OP_o = ALU_OP_XOR;
                    ALU_CONTROL_OP_SLL[2:0]: ALU_OP_o = ALU_OP_SHIFT_LEFT;
                    ALU_CONTROL_OP_SRA[2:0]: begin
                        ALU_OP_o = (FUNC7_i == ALU_CONTROL_OP_SRL[9:3]) ? ALU_OP_SHIFT_RIGHT   :
                                   (FUNC7_i == ALU_CONTROL_OP_SRA[9:3]) ? ALU_OP_SHIFT_RIGHT_A :
                                   ALU_OP_o;
                    end
                    ALU_CONTROL_OP_SLT[2:0]:  ALU_OP_o  = ALU_OP_SLT;
                    ALU_CONTROL_OP_SLTU[2:0]: ALU_OP_o  = ALU_OP_SLT_U;
                    default: ALU_OP_o  = ALU_OP_o;
                endcase
            end

            default: begin
            end
        endcase
    end
endmodule
