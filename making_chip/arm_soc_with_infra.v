// RTL Design for ARM Cortex-M Based SoC
module arm_soc (
    input  wire        clk,         // System clock
    input  wire        rst_n,       // Active-low reset
    // UART Interface
    input  wire        uart_rx,     // UART Receive
    output wire        uart_tx,     // UART Transmit
    // GPIO Interface
    input  wire [31:0] gpio_in,     // GPIO Inputs
    output wire [31:0] gpio_out,    // GPIO Outputs
    output wire [31:0] gpio_dir,    // GPIO Directions
    // Interrupt Outputs
    output wire        uart_int,    // UART Interrupt
    output wire        gpio_int,    // GPIO Interrupt
    output wire        timer_int    // Timer Interrupt
);

// Internal signals
wire        clk_main;
wire        clk_peripheral;
wire        reset_sync;
wire [31:0] uart_data;
wire        uart_ready;
wire        uart_write_enable;
wire [31:0] gpio_data_out;
wire [31:0] gpio_data_dir;

// Clock and Reset Generation
clock_reset_gen u_clk_rst (
    .clk_in(clk),
    .rst_n_in(rst_n),
    .clk_main(clk_main),
    .clk_peripheral(clk_peripheral),
    .rst_sync(reset_sync)
);

// DFT Signals
wire scan_clk;
wire scan_enable;
wire scan_in;
wire scan_out;

// DFT Integration
dft_controller u_dft (
    .clk(clk),
    .rst_n(rst_n),
    .scan_clk(scan_clk),
    .scan_enable(scan_enable),
    .scan_in(scan_in),
    .scan_out(scan_out)
);

// NoC Signals
wire [31:0] noc_to_uart_data;
wire [31:0] noc_to_gpio_data;
wire        noc_uart_write_enable;
wire        noc_gpio_write_enable;

// NoC Module
noc u_noc (
    .clk(clk_main),
    .rst_n(reset_sync),
    .uart_data_out(noc_to_uart_data),
    .gpio_data_out(noc_to_gpio_data),
    .uart_write_enable(noc_uart_write_enable),
    .gpio_write_enable(noc_gpio_write_enable),
    .uart_ready(uart_ready)
);

// UART Module
uart u_uart (
    .clk(clk_peripheral),
    .rst_n(reset_sync),
    .rx(uart_rx),
    .tx(uart_tx),
    .data_in(noc_to_uart_data),
    .data_out(uart_data),
    .write_enable(noc_uart_write_enable),
    .ready(uart_ready),
    .interrupt(uart_int)
);

// GPIO Module
gpio u_gpio (
    .clk(clk_peripheral),
    .rst_n(reset_sync),
    .gpio_in(gpio_in),
    .gpio_out(gpio_data_out),
    .gpio_dir(gpio_data_dir),
    .gpio_interrupt(gpio_int)
);

assign gpio_out = gpio_data_out;
assign gpio_dir = gpio_data_dir;

// Timer (Stub for now)
assign timer_int = 0;

endmodule

// Clock and Reset Generation Module
module clock_reset_gen (
    input  wire clk_in,
    input  wire rst_n_in,
    output wire clk_main,
    output wire clk_peripheral,
    output wire rst_sync
);

// Clock divider for peripheral clock
reg clk_divider;
always @(posedge clk_in or negedge rst_n_in) begin
    if (!rst_n_in) 
        clk_divider <= 0;
    else 
        clk_divider <= ~clk_divider;
end

assign clk_main = clk_in;
assign clk_peripheral = clk_divider; // Divide by 2

// Reset synchronization
reg [1:0] reset_sync_reg;
always @(posedge clk_in or negedge rst_n_in) begin
    if (!rst_n_in)
        reset_sync_reg <= 2'b00;
    else
        reset_sync_reg <= {reset_sync_reg[0], 1'b1};
end

assign rst_sync = reset_sync_reg[1];

endmodule

// DFT Controller
module dft_controller (
    input  wire clk,
    input  wire rst_n,
    output wire scan_clk,
    output wire scan_enable,
    input  wire scan_in,
    output wire scan_out
);

assign scan_clk = clk;
assign scan_enable = 1'b1; // Simplified always-on scan enable
assign scan_out = scan_in; // Loop-back for simplicity

endmodule

// NoC Module
module noc (
    input  wire        clk,
    input  wire        rst_n,
    output reg  [31:0] uart_data_out,
    output reg  [31:0] gpio_data_out,
    output reg         uart_write_enable,
    output reg         gpio_write_enable,
    input  wire        uart_ready
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        uart_data_out <= 32'd0;
        gpio_data_out <= 32'd0;
        uart_write_enable <= 1'b0;
        gpio_write_enable <= 1'b0;
    end else begin
        // Simplified NoC functionality
        if (uart_ready) begin
            uart_data_out <= 32'hA5A5A5A5; // Example data
            uart_write_enable <= 1'b1;
        end else begin
            uart_write_enable <= 1'b0;
        end

        gpio_data_out <= 32'hDEADBEEF; // Example GPIO data
        gpio_write_enable <= 1'b1;
    end
end

endmodule

// UART Module
module uart (
    input  wire        clk,
    input  wire        rst_n,
    input  wire        rx,
    output wire        tx,
    input  wire [31:0] data_in,
    output reg  [31:0] data_out,
    input  wire        write_enable,
    output wire        ready,
    output wire        interrupt
);

// UART functionality is simplified for this example
reg [7:0] tx_buffer;
assign tx = tx_buffer[0];
assign ready = 1'b1;
assign interrupt = 1'b0;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        tx_buffer <= 8'd0;
        data_out <= 32'd0;
    end else if (write_enable) begin
        tx_buffer <= data_in[7:0];
        data_out <= data_in;
    end
end

endmodule

// GPIO Module
module gpio (
    input  wire        clk,
    input  wire        rst_n,
    input  wire [31:0] gpio_in,
    output reg  [31:0] gpio_out,
    output reg  [31:0] gpio_dir,
    output wire        gpio_interrupt
);

assign gpio_interrupt = 1'b0; // Placeholder for interrupt logic

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        gpio_out <= 32'd0;
        gpio_dir <= 32'd0;
    end else begin
        // Placeholder for GPIO logic
    end
end

endmodule
