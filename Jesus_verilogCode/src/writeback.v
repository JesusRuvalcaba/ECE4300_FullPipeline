`timescale 1ns / 1ps

module writeback(
    input wire MEM_WB_memtoreg,
    input wire [31:0] read_data,
    input wire [31:0] mem_alu_result,

    output wire [31:0] mem_wb_write_data
);

assign mem_wb_write_data =
    (MEM_WB_memtoreg) ? read_data : mem_alu_result;

endmodule
