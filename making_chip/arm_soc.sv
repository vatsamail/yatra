// RAL Model for ARM SoC
class ARM_SoC_RAL extends uvm_reg_block;

  // UART Registers
  rand uvm_reg UART_DR;
  rand uvm_reg UART_FR;
  rand uvm_reg UART_CR;

  // GPIO Registers
  rand uvm_reg GPIO_DATA;
  rand uvm_reg GPIO_DIR;
  rand uvm_reg GPIO_IS;

  // Fuse Registers
  rand uvm_reg FUSE_DATA;
  rand uvm_reg FUSE_CTRL;

  function new(string name = "ARM_SoC_RAL");
    super.new(name);
  endfunction

  virtual function void build();
    // UART Register Fields
    UART_DR = uvm_reg::type_id::create("UART_DR");
    UART_FR = uvm_reg::type_id::create("UART_FR");
    UART_CR = uvm_reg::type_id::create("UART_CR");

    // GPIO Register Fields
    GPIO_DATA = uvm_reg::type_id::create("GPIO_DATA");
    GPIO_DIR = uvm_reg::type_id::create("GPIO_DIR");
    GPIO_IS = uvm_reg::type_id::create("GPIO_IS");

    // Fuse Register Fields
    FUSE_DATA = uvm_reg::type_id::create("FUSE_DATA");
    FUSE_CTRL = uvm_reg::type_id::create("FUSE_CTRL");

    // Add to register block
    this.default_map.add_reg(UART_DR, 'h40001000, "RW", 32);
    this.default_map.add_reg(UART_FR, 'h40001018, "R", 32);
    this.default_map.add_reg(UART_CR, 'h40001030, "RW", 32);

    this.default_map.add_reg(GPIO_DATA, 'h40002000, "RW", 32);
    this.default_map.add_reg(GPIO_DIR, 'h40002004, "RW", 32);
    this.default_map.add_reg(GPIO_IS, 'h40002008, "RW", 32);

    this.default_map.add_reg(FUSE_DATA, 'h40004000, "R", 32);
    this.default_map.add_reg(FUSE_CTRL, 'h40004004, "RW", 32);
  endfunction

endclass

// RAL Test Case
module ral_test;

  import uvm_pkg::*;
  `include "uvm_macros.svh"

  // DUT Interface
  reg clk;
  reg rst_n;

  // RAL Model
  ARM_SoC_RAL ral;

  initial begin
    // Initialize RAL Model
    ral = new("ral");
    ral.build();

    // Example Verification Sequence
    $display("Performing RAL Writes and Reads");

    ral.UART_DR.write(status, 32'hABCD1234);
    ral.UART_DR.read(status, read_data);
    $display("UART_DR Read Data: %h", read_data);

    ral.GPIO_DIR.write(status, 32'h00000001);
    ral.GPIO_DIR.read(status, read_data);
    $display("GPIO_DIR Read Data: %h", read_data);
  end

endmodule
