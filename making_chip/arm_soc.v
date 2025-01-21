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
wire [31:0] uart_data;
wire        uart_ready;
wire        uart_write_enable;
wire [31:0] gpio_data_out;
wire [31:0] gpio_data_dir;

// UART Module
uart u_uart (
    .clk(clk),
    .rst_n(rst_n),
    .rx(uart_rx),
    .tx(uart_tx),
    .data_in(uart_data),
    .data_out(uart_data),
    .write_enable(uart_write_enable),
    .ready(uart_ready),
    .interrupt(uart_int)
);

// GPIO Module
gpio u_gpio (
    .clk(clk),
    .rst_n(rst_n),
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
