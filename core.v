module Core #(
    parameter BOOT_ADDRESS = 32'h00000000
) (
    // Control signal
    input wire clk,
    // input wire halt,
    input wire rst_n,

    // Memory BUS
    // input  wire ack_i,
    output wire rd_en_o,
    output wire wr_en_i,
    // output wire [3:0]  byte_enable,
    input  wire [31:0] data_i,
    output wire [31:0] addr_o,
    output wire [31:0] data_o
);

//insira seu código aqui

// --- Sinais de controle
wire pc_write;
wire ir_write;
wire pc_source;
wire reg_write;
wire memory_read;
wire is_immediate;
wire memory_write;
wire pc_write_cond;
wire lorD;
wire memory_to_reg;
wire [1:0] aluop;
wire [1:0] alu_src_a;
wire [1:0] alu_src_b;

// --- Registradores
reg [31:0] pc;
reg [31:0] instruction;
reg [31:0] memory_data_reg;
reg [31:0] alu_out;

// --- Sinais da instrução
wire [6:0] instruction_opcode = instruction[6:0];
wire [4:0] rs1 = instruction[19:15];
wire [4:0] rs2 = instruction[24:20];
wire [4:0] rd = instruction[11:7];
wire [2:0] funct3 = instruction[14:12];
wire [6:0] funct7 = instruction[31:25];

// --- Sinais do datapath
wire [31:0] reg_data1;
wire [31:0] reg_data2;
wire [31:0] immediate;
wire [3:0] alu_control;
wire [31:0] alu_result;
wire alu_zero;

// --- Conexões auxiliares
wire [31:0] next_pc;
wire [31:0] alu_input_a;
wire [31:0] alu_input_b;
wire [31:0] write_data;

// --- Instanciação dos módulos
Control_Unit control_unit(
    .clk(clk),
    .rst_n(rst_n),
    .instruction_opcode(instruction_opcode),
    .pc_write(pc_write),
    .ir_write(ir_write),
    .pc_source(pc_source),
    .reg_write(reg_write),
    .memory_read(memory_read),
    .is_immediate(is_immediate),
    .memory_write(memory_write),
    .pc_write_cond(pc_write_cond),
    .lorD(lorD),
    .memory_to_reg(memory_to_reg),
    .aluop(aluop),
    .alu_src_a(alu_src_a),
    .alu_src_b(alu_src_b)
);

Registers registers(
    .clk(clk),
    .wr_en_i(reg_write),
    .RS1_ADDR_i(rs1),
    .RS2_ADDR_i(rs2),
    .RD_ADDR_i(rd),
    .data_i(write_data),
    .RS1_data_o(reg_data1),
    .RS2_data_o(reg_data2)
);

Immediate_Generator imm_gen(
    .instr_i(instruction),
    .imm_o(immediate)
);

ALU_Control alu_ctrl(
    .is_immediate_i(is_immediate),
    .ALU_CO_i(aluop),
    .FUNC7_i(funct7),
    .FUNC3_i(funct3),
    .ALU_OP_o(alu_control)
);

Alu alu(
    .ALU_OP_i(alu_control),
    .ALU_RS1_i(alu_input_a),
    .ALU_RS2_i(alu_input_b),
    .ALU_RD_o(alu_result),
    .ALU_ZR_o(alu_zero)
);

// Atualização do PC
assign next_pc = pc_source ? alu_out : alu_result;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        pc = BOOT_ADDRESS;
    end else if (pc_write || (pc_write_cond && alu_zero)) begin
        pc = next_pc;
    end
end

// Registradores intermediários
always @(posedge clk) begin
    if (ir_write) instruction <= data_i;

    memory_data_reg = data_i;
    alu_out         = alu_result;
end

// MUXes
assign alu_input_a = (alu_src_a == 2'b00) ? pc :
                     (alu_src_a == 2'b01) ? reg_data1 :
                      32'b0;

assign alu_input_b = (alu_src_b == 2'b00) ? reg_data2 :
                     (alu_src_b == 2'b01) ? 32'd4 :
                      immediate;

assign write_data = memory_to_reg ? memory_data_reg : alu_out;

// Interface com memória
assign rd_en_o = memory_read;
assign wr_en_i = memory_write;
assign addr_o = lorD ? alu_out : pc;
assign data_o = reg_data2;

endmodule