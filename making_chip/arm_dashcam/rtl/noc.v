module noc_axi #(
    parameter NUM_MASTERS = 4,
    parameter NUM_SLAVES = 4
)(
    input wire clk,
    input wire reset_n,
    
    // AXI Master Interfaces
    input wire [31:0] axi_m0_awaddr,
    input wire axi_m0_awvalid,
    input wire [31:0] axi_m0_wdata,
    input wire axi_m0_wvalid,
    output wire axi_m0_bready,
    
    // AXI Slave Interfaces
    output wire [31:0] axi_s0_araddr,
    output wire axi_s0_arvalid,
    input wire [31:0] axi_s0_rdata,
    input wire axi_s0_rvalid
);
    
    // Internal wires to connect master-slave transactions
    wire [31:0] master_awaddr [NUM_MASTERS-1:0];
    wire master_awvalid [NUM_MASTERS-1:0];
    wire [31:0] master_wdata [NUM_MASTERS-1:0];
    wire master_wvalid [NUM_MASTERS-1:0];
    wire master_bready [NUM_MASTERS-1:0];

    wire [31:0] slave_araddr [NUM_SLAVES-1:0];
    wire slave_arvalid [NUM_SLAVES-1:0];
    wire [31:0] slave_rdata [NUM_SLAVES-1:0];
    wire slave_rvalid [NUM_SLAVES-1:0];
    
    // Arbitration logic (simplified)
    // In this basic example, we use round-robin arbitration for selecting the master and slave
    reg [NUM_MASTERS-1:0] master_arbitration;
    reg [NUM_SLAVES-1:0] slave_arbitration;
    
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            master_arbitration <= 0;
            slave_arbitration <= 0;
        end else begin
            master_arbitration <= {master_arbitration[NUM_MASTERS-2:0], master_arbitration[NUM_MASTERS-1]};
            slave_arbitration <= {slave_arbitration[NUM_SLAVES-2:0], slave_arbitration[NUM_SLAVES-1]};
        end
    end
    
    // Master to Slave mapping (simplified)
    assign axi_s0_araddr = slave_arbitration[0] ? master_awaddr[0] : 32'b0; // Simplified mapping
    assign axi_s0_arvalid = slave_arbitration[0] ? master_awvalid[0] : 1'b0;
    
    assign axi_m0_bready = master_bready[0]; // Simplified for one master

endmodule
