#ifndef ARM_SOC_H
#define ARM_SOC_H

// Base Addresses
#define FLASH_BASE        0x00000000
#define SRAM_BASE         0x20000000
#define UART_BASE         0x40001000
#define GPIO_BASE         0x40002000

// UART Registers
#define UART_DR           (UART_BASE + 0x00)  // Data Register
#define UART_FR           (UART_BASE + 0x18)  // Flag Register
#define UART_CR           (UART_BASE + 0x30)  // Control Register

// GPIO Registers
#define GPIO_DATA         (GPIO_BASE + 0x00)  // Data Register
#define GPIO_DIR          (GPIO_BASE + 0x04)  // Direction Register
#define GPIO_IS           (GPIO_BASE + 0x08)  // Interrupt Sense

// IOMUX Registers
#define IOMUX_SEL         0x40003000          // Pin Function Select

// Fuses Registers
#define FUSE_DATA         0x40004000          // Fuse Data
#define FUSE_CTRL         0x40004004          // Fuse Control

// UART Access Macros
#define UART_WRITE(data)  (*((volatile unsigned int *)(UART_DR)) = (data))
#define UART_READ()       (*((volatile unsigned int *)(UART_DR)))
#define UART_IS_READY()   (!(*((volatile unsigned int *)(UART_FR)) & 0x01))

// GPIO Access Macros
#define GPIO_WRITE(data)  (*((volatile unsigned int *)(GPIO_DATA)) = (data))
#define GPIO_READ()       (*((volatile unsigned int *)(GPIO_DATA)))
#define GPIO_SET_DIR(dir) (*((volatile unsigned int *)(GPIO_DIR)) = (dir))

#endif // ARM_SOC_H
