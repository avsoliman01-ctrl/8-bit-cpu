`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Adel-Van Soliman
// 
// Create Date: 09/01/2026 12:45:01 PM
// Design Name: 
// Module Name: controller
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module controller(
    input wire clk,
    input wire rst,
    input wire [3:0] opcode,
    input wire zero_flag,
    input wire carry_flag,
    output reg ram_write_en,
    output reg ram_bus_en,
    output reg a_we,
    output reg a_bus_en,
    output reg b_we,
    output reg b_bus_en,
    output reg [2:0] alu_opcode,
    output reg alu_bus_en,
    output reg alu_flag_we,
    output reg ir_we,
    output reg ram_addr_sel,
    output reg pc_inc,
    output reg pc_load
    );
    localparam  fetch = 1'b0;
    localparam  execute = 1'b1;
    reg state;
    reg next_state;
    //state register
    always @(posedge clk or posedge rst) begin
        if(rst)
            state <= fetch;
        else
            state <= next_state;
    end
    //controller logic
    always @(*) begin
    //default state
    ram_write_en = 1'b0;
    ram_bus_en = 1'b0;
    a_we = 1'b0;
    a_bus_en = 1'b0;
    b_we = 1'b0;
    b_bus_en = 1'b0;
    alu_opcode = 3'b000;
    alu_bus_en = 1'b0;
    alu_flag_we = 1'b0;
    ir_we = 1'b0;
    pc_inc = 1'b0;
    pc_load = 1'b0;
    ram_addr_sel = 1'b0;
    next_state = fetch;
    
    case(state)
        fetch: begin
            ram_addr_sel = 1'b0;
            ram_bus_en = 1'b1;
            ir_we = 1'b1;
            pc_inc = 1'b1;
            next_state = execute;
        end
        
        execute: begin
            ram_addr_sel = 1'b1;
            
            case (opcode)
                //NOP
                4'b0000: begin
                //mbappe special
                end
                //LDA
                4'b0001: begin
                    ram_bus_en = 1'b1;
                    a_we = 1'b1;
                end
                //LDB
                4'b0010: begin
                    ram_bus_en = 1'b1;
                    b_we = 1'b1;
                end
                //sta
                4'b0011: begin
                    a_bus_en = 1'b1;
                    ram_write_en = 1'b1;
                end
                //STB
                4'b0100: begin
                    b_bus_en = 1'b1;
                    ram_write_en = 1'b1;
                end
                //ADD
                4'b0101: begin
                    alu_opcode =3'b000;
                    alu_bus_en = 1'b1;
                    a_we= 1'b1;
                    alu_flag_we = 1'b1;
                end
                //add w carry
                4'b0110: begin
                    alu_opcode =3'b001;
                    alu_bus_en = 1'b1;
                    a_we= 1'b1;
                    alu_flag_we = 1'b1;
                end
                //sub
                4'b0111: begin
                    alu_opcode =3'b010;
                    alu_bus_en = 1'b1;
                    a_we= 1'b1;
                    alu_flag_we = 1'b1;
                end
                //inc
                4'b1000: begin
                    alu_opcode =3'b011;
                    alu_bus_en = 1'b1;
                    a_we= 1'b1;
                    alu_flag_we = 1'b1;
                end
                //dec
                4'b1001: begin
                    alu_opcode =3'b100;
                    alu_bus_en = 1'b1;
                    a_we= 1'b1;
                    alu_flag_we = 1'b1;
                end
                // Negate
                4'b1010: begin
                    alu_opcode =3'b101;
                    alu_bus_en = 1'b1;
                    a_we= 1'b1;
                    alu_flag_we = 1'b1;
                end
                //logical and
                4'b1011: begin
                    alu_opcode =3'b110;
                    alu_bus_en = 1'b1;
                    a_we= 1'b1;
                    alu_flag_we = 1'b1;
                end
                //logical or
                4'b1100: begin
                    alu_opcode =3'b111;
                    alu_bus_en = 1'b1;
                    a_we= 1'b1;
                    alu_flag_we = 1'b1;
                end
                //jmp
                4'b1101: begin
                    pc_load =1'b1;
                end
                //zj
                4'b1110: begin
                    if (zero_flag)
                        pc_load =1'b1;
                end
                //jc
                4'b1111: begin
                    if (carry_flag)
                        pc_load =1'b1;
                end
                default: begin
                end
        endcase
        
        next_state = fetch;
        end
    endcase
end
endmodule
