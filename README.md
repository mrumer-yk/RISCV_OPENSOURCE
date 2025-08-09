# RISC-V 5Stage Pipelined Core (Vivado Project)

This repository contains a RISCV processor implemented in Verilog with a classic 5stage pipeline and integrated SPI master and floatingpoint support.

## Features
- 5stage pipeline: Fetch, Decode, Execute, Memory, Writeback
- Hazard detection and data forwarding (see hazard_unit.v)
- Integrated SPI master in Memory stage (spimodule.v, spi2.v), with finish flag passed into the front-end for flow control
- Floatingpoint operations via ALU_Floating_Point with multiplication, division, add/sub, and iteration unit
- Top module TOP_RISC_V ties the pipeline together
- Testbench 	b.v
- Constraints example dd.xdc

## Toplevel
- Top module: TOP_RISC_V in modified risc v.srcs/sources_1/new/riscv.v
- Note: SPI ports exist in the Memory stage. Ensure toplevel SPI ports are exposed (uncomment in TOP_RISC_V) if you plan to drive external SPI pins:
  - i_SPI_MISO, o_SPI_MOSI, o_SPI_Clk, o_SPI_CS_n

## Directory Layout
- RTL: modified risc v.srcs/sources_1/new/*.v
- Testbench: modified risc v.srcs/sim_1/new/tb.v
- Constraints: modified risc v.srcs/constrs_1/new/dd.xdc

## Build & Simulate (Vivado)
1. Create/clone the Vivado project or add the RTL files to a new project.
2. Set TOP_RISC_V as top (simulation top is 	op_pipe_line_tb in 	b.v).
3. Run behavioral simulation. The design uses forwarding and branch logic in execute_cycle.v and hazard_unit.v.
4. Synthesis/implementation target depends on your FPGA; update dd.xdc as needed for board pins.

## SPI Integration
- SPI master provided by SPI_Master and SPI_Master_With_Single_CS (spi2.v and spimodule.v).
- Memory stage (memory_cycle.v) connects the SPI signals and exposes a spi_finish handshake back to the front-end (etchdecodetop.v).

## FloatingPoint
- ALU_Floating_Point in ALU float.v supports add/sub, multiply, divide, and an iteration block.
- Integrated in ALU_TOP and selected by loat_signal from decode.

## Notes
- The Vivado project artifacts (.runs/.sim/.gen, etc.) are intentionally excluded via .gitignore. Only source RTL, testbench, and constraints are tracked.
- Repository target (empty at time of push): https://github.com/umeryk12/RiscV_open_source.

## License
See LICENSE (add your license file here if needed).

---
Origin repo reference: [umeryk12/RiscV_open_source](https://github.com/umeryk12/RiscV_open_source)
