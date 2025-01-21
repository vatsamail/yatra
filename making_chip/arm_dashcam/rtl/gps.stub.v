module gps_interface (
    input wire clk,
    input wire reset_n,
    output wire [31:0] latitude,
    output wire [31:0] longitude,
    output wire [15:0] speed
);
    // Placeholder for GPS data receiving logic
    // GPS data parsing would occur here

    always @(posedge clk or negedge reset_n) begin
        if (~reset_n) begin
            // Reset logic
        end else begin
            // Dummy GPS data
            latitude <= 32'h12345678;
            longitude <= 32'h87654321;
            speed <= 16'd60; // Dummy speed in km/h
        end
    end
endmodule
