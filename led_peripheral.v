module led_peripheral(
    input  wire        clk,
    input  wire        rst_n,
    // Interface com o barramento
    input  wire        rd_en_i,
    input  wire        wr_en_i,
    input  wire [31:0] addr_i,
    input  wire [31:0] data_i,
    output wire  [31:0] data_o,
    // Interface com os LEDs físicos
    output wire  [7:0]  leds_o
);

// Endereços específicos do LED
localparam LED_WRITE_ADDR = 8'h00;
localparam LED_READ_ADDR  = 8'h04;

wire [3:0] effective_address = addr_i[3:0];

// Registro interno para os LEDs
reg [7:0] led_reg;
reg [31:0] data_reg;

// Lógica de escrita síncrona
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        led_reg <= 8'h00;
    end
    else if (wr_en_i && (effective_address == LED_WRITE_ADDR)) begin
        led_reg <= data_i[7:0];  // Captura apenas os 8 LSBs
    end
end

// Lógica de leitura combinacional
always @(*) begin
    if (rd_en_i && (effective_address == LED_READ_ADDR)) begin
        data_reg = {24'b0, led_reg};  // Retorna valor estendido para 32 bits
    end
    else begin
        data_reg = {24'b0, led_reg};  // Retorna valor estendido para 32 bits
    end
end

assign data_o = data_reg;
assign leds_o  = led_reg;

endmodule