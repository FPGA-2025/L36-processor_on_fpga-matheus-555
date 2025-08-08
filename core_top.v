module core_top #(
    parameter MEMORY_FILE = ""
)(
    input  wire        clk,
    input  wire        rst_n,

    output wire [7:0] leds
);

// insira seu código aqui

// Sinais do processador
wire proc_rd_en;
wire proc_wr_en;
wire [31:0] proc_addr;
wire [31:0] proc_data_out;
wire [31:0] proc_data_in;

// Sinais da memória
wire mem_rd_en;
wire mem_wr_en;
wire [31:0] mem_addr;
wire [31:0] mem_data_out;
wire [31:0] mem_data_in;

// Sinais do periferico
wire periph_rd_en_o;
wire periph_wr_en_o;
wire [31:0] periph_addr;
wire [31:0] periph_data_in;
wire [31:0] periph_data_out;


Memory #(
    .MEMORY_FILE(MEMORY_FILE),
    .MEMORY_SIZE()
) mem (
    .clk(clk),
    .rd_en_i(mem_rd_en),
    .wr_en_i(mem_wr_en),
    .addr_i(mem_addr),
    .data_i(mem_data_out),
    .data_o(mem_data_in),
    .ack_o()
);


Core #(
    .BOOT_ADDRESS()
) core (
    .clk(clk),
    .rst_n(rst_n),
    .rd_en_o(proc_rd_en),
    .wr_en_i(proc_wr_en),
    .data_i(proc_data_in),
    .addr_o(proc_addr),
    .data_o(proc_data_out)
);


bus_interconnect bus(
    // sinais vindos do processador
    .proc_rd_en_i(proc_rd_en),
    .proc_wr_en_i(proc_wr_en),
    .proc_data_o(proc_data_in),
    .proc_addr_i(proc_addr),
    .proc_data_i(proc_data_out),

    // sinais que vão para a memória
    .mem_rd_en_o(mem_rd_en),
    .mem_wr_en_o(mem_wr_en),
    .mem_data_i(mem_data_in),
    .mem_addr_o(mem_addr),
    .mem_data_o(mem_data_out),

    // sinais que vão para o periférico
    .periph_rd_en_o(periph_rd_en_o),
    .periph_wr_en_o(periph_wr_en),
    .periph_data_i(periph_data_in),
    .periph_addr_o(periph_addr),
    .periph_data_o(periph_data_out)
);


led_peripheral led_periph (
    .clk(clk),
    .rst_n(rst_n),
    .rd_en_i(periph_rd_en),
    .wr_en_i(periph_wr_en),
    .addr_i(periph_addr),
    .data_i(periph_data_out),
    .data_o(periph_data_in),
    .leds_o(leds)
);

endmodule