module armdashcam_soc #(
    parameter SYS_CLK_FREQ = 100_000_000,  // 100 MHz
    parameter NUM_MASTERS = 4,
    parameter NUM_SLAVES = 4,
    parameter NUM_INTERRUPTS = 8
)(
    input wire clk_in,              // Input clock
    input wire reset_in,            // Input reset
    output wire sys_clk,            // System clock
    output wire sys_reset_n        // Active-low reset
);

    // Clock and Reset Subsystem
    wire clk;
    wire reset_n;

    clk_rst_ip #(
        .SYS_CLK_FREQ(SYS_CLK_FREQ),
        .SYS_RST_DELAY(100)  // 100us reset delay
    ) clk_rst_inst (
        .clk_in(clk_in),
        .reset_in(reset_in),
        .sys_clk(clk),
        .sys_reset_n(reset_n)
    );

    // NoC Subsystem
    wire [31:0] axi_m0_awaddr;
    wire axi_m0_awvalid;
    wire [31:0] axi_m0_wdata;
    wire axi_m0_wvalid;
    wire axi_m0_bready;

    noc_axi #(
        .NUM_MASTERS(NUM_MASTERS),
        .NUM_SLAVES(NUM_SLAVES)
    ) noc_inst (
        .clk(clk),
        .reset_n(reset_n),
        .axi_m0_awaddr(axi_m0_awaddr),
        .axi_m0_awvalid(axi_m0_awvalid),
        .axi_m0_wdata(axi_m0_wdata),
        .axi_m0_wvalid(axi_m0_wvalid),
        .axi_m0_bready(axi_m0_bready)
    );

    // Interrupt Generation (simplified)
    wire [NUM_INTERRUPTS-1:0] interrupt_signals;
    assign interrupt_signals[0] = 1'b1;  // Example interrupt source

    // GPIO and I/O Mux (simplified)
    wire uart_tx;
    wire uart_rx;
    wire spi_clk;
    wire spi_miso;
    wire spi_mosi;
    assign uart_tx = interrupt_signals[0] ? 1'b1 : 1'b0;  // Example mapping

    // Output
    assign sys_clk = clk;
    assign sys_reset_n = reset_n;

endmodule
