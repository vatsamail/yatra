module clk_rst_ip #(
    parameter SYS_CLK_FREQ = 100_000_000,  // 100 MHz
    parameter SYS_RST_DELAY = 100         // 100us delay for reset
)(
    input wire clk_in,                   // Input clock signal
    input wire reset_in,                 // Input reset signal
    
    output reg sys_clk,                  // Output system clock
    output reg sys_reset_n              // Output system reset (active-low)
);
    
    // Internal signal for clock division (assuming a simple clock division logic)
    reg [15:0] clk_div_counter;          // Clock division counter
    reg clk_out_reg;                     // Divided clock signal
    
    // Reset delay counter
    reg [31:0] reset_delay_counter;
    reg reset_active;
    
    // Clock generation logic (divide by 2 for simplicity)
    always @(posedge clk_in or posedge reset_in) begin
        if (reset_in) begin
            clk_div_counter <= 16'b0;
            sys_clk <= 1'b0;
        end else begin
            if (clk_div_counter == (SYS_CLK_FREQ / 2) - 1) begin
                sys_clk <= ~sys_clk;   // Toggle clock output every half cycle
                clk_div_counter <= 16'b0;
            end else begin
                clk_div_counter <= clk_div_counter + 1;
            end
        end
    end
    
    // Reset signal logic with delay
    always @(posedge clk_in or posedge reset_in) begin
        if (reset_in) begin
            reset_delay_counter <= 32'b0;
            sys_reset_n <= 1'b0;
            reset_active <= 1'b1;
        end else begin
            if (reset_delay_counter < SYS_RST_DELAY) begin
                reset_delay_counter <= reset_delay_counter + 1;
            end else begin
                sys_reset_n <= 1'b1;
                reset_active <= 1'b0;
            end
        end
    end
    
endmodule
