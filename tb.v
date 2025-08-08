`timescale 1ns/1ps

module tb();

localparam QTDE_LINHAS_TESTE = 1;
localparam QTDE_BITS_TESTE = 8;

reg clk = 0;
reg rst_n;
wire [7:0] leds;

reg [QTDE_BITS_TESTE-1:0] file_data [0:QTDE_LINHAS_TESTE-1];
reg [7:0] expected_leds;

always #1 clk = ~clk; // Clock generation

core_top #(
    .MEMORY_FILE("programa.txt") // Specify the memory file
) t (
    .clk(clk),
    .rst_n(rst_n),
    .leds(leds)
);

initial begin
    $dumpfile("saida.vcd");
    $dumpvars(0, tb);

    rst_n = 0; // Reset the system
    #5;
    rst_n = 1; // Release reset

    #50; // wait for the end of the program

    $readmemh("test/teste0.txt", file_data); // Read the memory file

    expected_leds = file_data[0][QTDE_BITS_TESTE-1:0];

    $display("Expected LEDs: %h", expected_leds);

    if (leds !== expected_leds) begin
        $display("=== ERRO Escrita nos LEDS falhou: esperava %h, obtive %h", expected_leds, leds);
    end else begin
        $display("=== OK Escrita nos LEDS passou: obtive %h", leds);
    end

    $finish; // End simulation
end

endmodule