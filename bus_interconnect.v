module bus_interconnect (
    // Sinais do processador
    input   wire proc_rd_en_i,
    input   wire proc_wr_en_i,
    output  wire [31:0] proc_data_o,
    input   wire [31:0] proc_addr_i,
    input   wire [31:0] proc_data_i,

    // Sinais para a memória
    output  wire mem_rd_en_o,
    output  wire mem_wr_en_o,
    input   wire [31:0] mem_data_i,
    output  wire [31:0] mem_addr_o,
    output  wire [31:0] mem_data_o,

    // Sinais para o periférico
    output wire periph_rd_en_o,
    output wire periph_wr_en_o,
    input  wire [31:0] periph_data_i,
    output wire [31:0] periph_addr_o,
    output wire [31:0] periph_data_o
);

// ---  Definição das regiões de endereço

// - Memória de programa e de dados
localparam MEM_BASE    = 32'h00000000;
localparam MEM_END     = 32'h7FFFFFFF;

// - Memória dos periféricos
localparam PERIPH_BASE    = 32'h80000000;
localparam PERIPH_END     = 32'hFFFFFFFF;

// --- Decodificação de endereços
wire is_mem      = (proc_addr_i >= MEM_BASE)    && (proc_addr_i <= MEM_END);
wire is_periph   = (proc_addr_i >= PERIPH_BASE) && (proc_addr_i <= PERIPH_END);

// --- Conexões para a memória
assign mem_rd_en_o   = is_mem ? proc_rd_en_i : 1'b0;
assign mem_wr_en_o   = is_mem ? proc_wr_en_i : 1'b0;
assign mem_addr_o    = proc_addr_i;
assign mem_data_o    = proc_data_i;

// --- Conexões para o periférico de LEDs
assign periph_rd_en_o = is_periph ? proc_rd_en_i : 1'b0;
assign periph_wr_en_o = is_periph ? proc_wr_en_i : 1'b0;
assign periph_addr_o  = proc_addr_i;
assign periph_data_o  = proc_data_i;

// --- Multiplexação da saída de dados
assign proc_data_o = is_mem    ? mem_data_i :
                     is_periph ? periph_data_i :
                     32'h00000000;

endmodule