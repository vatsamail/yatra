# SDC File for ARM Cortex-M SoC Design

# Define the system clock
create_clock -period 10 [get_pins u_soc/clk]    # 10ns period (100MHz clock)

# Define the input and output delay constraints based on the external signals
# For example, define input delay for UART RX and GPIO inputs

set_input_delay -clock [get_clocks u_soc/clk] 5 [get_pins u_soc/uart_rx]     # 5ns input delay for UART RX
set_input_delay -clock [get_clocks u_soc/clk] 3 [get_pins u_soc/gpio_in]    # 3ns input delay for GPIO inputs

set_output_delay -clock [get_clocks u_soc/clk] 3 [get_pins u_soc/uart_tx]    # 3ns output delay for UART TX
set_output_delay -clock [get_clocks u_soc/clk] 2 [get_pins u_soc/gpio_out]   # 2ns output delay for GPIO outputs

# Set maximum and minimum input/output delays for data paths
set_max_delay 2 -from [get_pins u_soc/clk] -to [get_pins u_soc/uart_tx]    # Max delay for UART TX
set_min_delay 1 -from [get_pins u_soc/clk] -to [get_pins u_soc/uart_rx]    # Min delay for UART RX

# Define timing exceptions for paths with asynchronous signals or clocks
set_max_delay 5 -from [get_pins u_soc/clk] -to [get_pins u_soc/gpio_in]      # Max delay for GPIO input
set_min_delay 1 -from [get_pins u_soc/clk] -to [get_pins u_soc/gpio_out]     # Min delay for GPIO output

# Set input and output delays for NoC interface signals (if applicable)
set_input_delay -clock [get_clocks u_soc/clk] 5 [get_pins u_soc/noc_data_in]  # NoC data input delay
set_output_delay -clock [get_clocks u_soc/clk] 5 [get_pins u_soc/noc_data_out] # NoC data output delay

# Define clock constraints for clock gating (if applicable)
# For example, for the core and peripherals:
set_clock_gating -name clk_gate_core -gating_clock [get_pins u_soc/clk] -control_signal [get_pins u_soc/gpio_dir]

# Define timing exceptions for multi-cycle paths (example: GPIO)
set_multicycle_path 2 -from [get_pins u_soc/gpio_in] -to [get_pins u_soc/gpio_out]   # Multi-cycle path for GPIO

# Define constraints for the clock domain crossing if multiple clock domains exist
# For example, if UART operates on a different clock
create_clock -period 15 [get_pins u_uart/clk]  # UART clock with a period of 15ns (66.67 MHz)

# Define timing constraints for different paths in the SoC
# Example: GPIO interrupt path
set_max_delay 2 -f
