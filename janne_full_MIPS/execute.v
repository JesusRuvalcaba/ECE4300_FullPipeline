`timescale 1ns / 1ps
// MODIFIED: Added zero_out output to forward the ALU zero flag to the MEM stage.

module execute(
    input wire clk,
    input wire rst,
    input wire [1:0] ctlwb_in,
    input wire [2:0] ctlm_in,
    input wire [31:0] npc, rdata1, rdata2, s_extend,
    input wire [4:0] instr_2016, instr_1511,
    input wire [1:0] alu_op,
    input wire [5:0] funct,
    input wire alusrc, regdst,
    output wire [1:0] ctlwb_out,
    output wire [2:0] ctlm_out,
    output wire [31:0] adder_out, alu_result_out, rdata2_out,
    output wire [4:0] muxout_out,
    output wire zero_out
);

    // Internal Wires
    wire [31:0] npc_plus_offset;
    wire [31:0] alu_input_b;
    wire [31:0] alu_res_internal;
    wire [4:0] write_reg_internal;
    wire [2:0] alu_control_wire;
    wire zero_internal;

    // 1. Branch Address Adder
    adder adder3 (
        .add_in1(npc),
        .add_in2(s_extend),
        .add_out(npc_plus_offset)
    );

    // 2. RegDst Mux (Selects destination register: rt or rd)
    bottom_mux bottom_mux3 (
        .a(instr_1511),  // rd
        .b(instr_2016),  // rt
        .sel(regdst),
        .y(write_reg_internal)
    );

    // 3. ALUSrc Mux (Selects ALU input B: Register or Immediate)
    // Using a ternary operator here simplifies the file structure
    assign alu_input_b = alusrc ? s_extend : rdata2;

    // 4. ALU Control
    alu_control alu_control3 (
        .funct(funct),
        .aluop(alu_op),
        .select(alu_control_wire)
    );

    // 5. ALU
    alu alu3 (
        .a(rdata1),
        .b(alu_input_b),
        .control(alu_control_wire),
        .result(alu_res_internal),
        .zero(zero_internal)
    );

    // 6. EX/MEM Latch (Now Synchronous with Clock)
    ex_mem ex_mem3 (
        .clk(clk),
        .rst(rst),
        .ctlwb_in(ctlwb_in),
        .ctlm_in(ctlm_in),
        .adder_in(npc_plus_offset),
        .aluzero_in(zero_internal),
        .alu_res_in(alu_res_internal),
        .rdata2_in(rdata2),
        .write_reg_in(write_reg_internal),
        .ctlwb_out(ctlwb_out),
        .ctlm_out(ctlm_out),
        .adder_out(adder_out),
        .aluzero_out(zero_out),
        .alu_result_out(alu_result_out),
        .rdata2_out(rdata2_out),
        .muxout_out(muxout_out)
    );

endmodule
