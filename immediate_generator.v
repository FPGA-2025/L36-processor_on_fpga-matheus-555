module Immediate_Generator (
    input wire [31:0] instr_i,  // Entrada: Instrução
    output reg [31:0] imm_o     // Saída: Imediato extraído da instrução
);


    localparam LW_OPCODE        = 7'b0000011;
    localparam SW_OPCODE        = 7'b0100011;
    localparam JAL_OPCODE       = 7'b1101111;
    localparam LUI_OPCODE       = 7'b0110111;
    localparam JALR_OPCODE      = 7'b1100111;
    localparam AUIPC_OPCODE     = 7'b0010111;
    localparam BRANCH_OPCODE    = 7'b1100011;
    localparam IMMEDIATE_OPCODE = 7'b0010011;

    always @(*) begin
        case (instr_i[6:0])
            LW_OPCODE:        imm_o = {{20{instr_i[31]}}, instr_i[31:20]};
            SW_OPCODE:        imm_o = {{20{instr_i[31]}}, instr_i[31:25], instr_i[11:7]};
            JAL_OPCODE:       imm_o = {{11{instr_i[31]}}, instr_i[31], instr_i[19:12], instr_i[20], instr_i[30:21], 1'b0};
            LUI_OPCODE:       imm_o = {instr_i[31:12], 12'b0}; // Equivalente -> instr_i[31:12]<<12; 
            JALR_OPCODE:      imm_o = {{20{instr_i[31]}}, instr_i[31:20]};
            AUIPC_OPCODE:     imm_o = {instr_i[31:12], 12'b0};
            BRANCH_OPCODE:    imm_o = {{19{instr_i[31]}}, instr_i[31], instr_i[7], instr_i[30:25], instr_i[11:8], 1'b0};
            IMMEDIATE_OPCODE: imm_o = {{20{instr_i[31]}}, instr_i[31:20]};
            default:          imm_o = 32'b0;
        endcase
    end
    
endmodule