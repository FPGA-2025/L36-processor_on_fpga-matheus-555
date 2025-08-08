module Alu (
    input  wire [3:0]  ALU_OP_i,
    input  wire [31:0] ALU_RS1_i,
    input  wire [31:0] ALU_RS2_i,
    output  reg [31:0] ALU_RD_o,
    output wire ALU_ZR_o
);

    // Definição dos opcodes da ALU
    localparam AND             = 4'b0000;
    localparam OR              = 4'b0001;
    localparam SUM             = 4'b0010;
    localparam SUB             = 4'b1010;
    localparam GREATER_EQUAL   = 4'b1100;
    localparam GREATER_EQUAL_U = 4'b1101;
    localparam SLT             = 4'b1110;
    localparam SLT_U           = 4'b1111;
    localparam SHIFT_LEFT      = 4'b0100;
    localparam SHIFT_RIGHT     = 4'b0101;
    localparam SHIFT_RIGHT_A   = 4'b0111;
    localparam XOR             = 4'b1000;
    localparam NOR             = 4'b1001;
    localparam EQUAL           = 4'b0011;

    //insira o seu código aqui

    always @(*) begin
        case (ALU_OP_i)

            AND: begin
                ALU_RD_o = ALU_RS1_i & ALU_RS2_i;
            end
    
            OR: begin
                ALU_RD_o = ALU_RS1_i | ALU_RS2_i;
            end
    
            SUM: begin
                ALU_RD_o = ALU_RS1_i + ALU_RS2_i;
            end
    
            SUB: begin
                ALU_RD_o = ALU_RS1_i - ALU_RS2_i;
            end
    
            GREATER_EQUAL: begin
                ALU_RD_o = $signed(ALU_RS1_i) >= $signed(ALU_RS2_i);
            end
    
            GREATER_EQUAL_U: begin
                ALU_RD_o = $unsigned(ALU_RS1_i) >= $unsigned(ALU_RS2_i);
            end
    
            SLT: begin
                ALU_RD_o = $signed(ALU_RS1_i) < $signed(ALU_RS2_i);
            end
    
            SLT_U: begin

                ALU_RD_o = $unsigned(ALU_RS1_i) < $unsigned(ALU_RS2_i);
            end
    
            SHIFT_LEFT: begin
                ALU_RD_o = ALU_RS1_i << ALU_RS2_i[4:0];
            end
    
            SHIFT_RIGHT: begin
                ALU_RD_o = ALU_RS1_i >> ALU_RS2_i[4:0];
            end
    
            SHIFT_RIGHT_A: begin
                ALU_RD_o = $signed(ALU_RS1_i) >>> ALU_RS2_i[4:0];
            end
    
            XOR: begin
                ALU_RD_o = ALU_RS1_i ^ ALU_RS2_i;
            end
    
            NOR: begin
                ALU_RD_o = ~(ALU_RS1_i | ALU_RS2_i);
            end
    
            EQUAL: begin
                ALU_RD_o = ALU_RS1_i == ALU_RS2_i;
            end
    
            default: begin
                
            end
        endcase
    end

    assign ALU_ZR_o = ALU_RD_o == 0;

endmodule
