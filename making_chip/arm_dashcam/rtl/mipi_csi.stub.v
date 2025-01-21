module mipi_csi_2 (
    input wire clk,
    input wire reset_n,
    input wire [15:0] mipi_data_in,
    output wire [15:0] mipi_data_out
);
    // Placeholder for MIPI CSI-2 interface
    // Example: Interface for receiving video stream from camera

    always @(posedge clk or negedge reset_n) begin
        if (~reset_n) begin
            // Reset logic
        end else begin
            mipi_data_out <= mipi_data_in; // Just pass-through for stub
        end
    end
endmodule
