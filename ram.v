`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Adel-Van Soliman
// 
// Create Date: 08/17/2026 05:07:55 PM
// Design Name: 
// Module Name: ram
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

module ram #(
    parameter DATA_WIDTH = 8,
    parameter MEM_SIZE = 16
)(
    input wire clk,
    input wire we,
    input wire bus_writable,
    input wire jmp_imme, //jump immediate
    input wire [DATA_WIDTH-1:0] addr, //8 bit address access
    
    inout wire [DATA_WIDTH-1:0] io_data
);
    
    reg [DATA_WIDTH-1:0] mem [0:MEM_SIZE-1];
    wire [7:0] out;
    
	 initial begin

        mem[0] = 8'h1E; // LDA 14
        mem[1] = 8'h2F; // LDB 15
        mem[2] = 8'h50; // ADD
        mem[3] = 8'h3D; // STA 13
        mem[4] = 8'hD4; // JMP 4

        mem[5]  = 8'h00;
        mem[6]  = 8'h00;
        mem[7]  = 8'h00;
        mem[8]  = 8'h00;
        mem[9]  = 8'h00;
        mem[10] = 8'h00;
        mem[11] = 8'h00;
        mem[12] = 8'h00;

        mem[13] = 8'h00; // result
        mem[14] = 8'h05; // 5
        mem[15] = 8'h03; // 3

    end

	 
    always @(posedge clk) begin
        if (we) mem[addr[3:0]] <= io_data; //if write enable is set to 1 then the memory address first 4 bits is set to io data
    end
    
    assign out = (jmp_imme) ?{4'h0, mem[addr[3:0]][3:0]} : //if jmp=1 then padd the upper bits with 0's (because i already got the jump instruction) and load the data at the address into the lower 4 bits, if jmp=0 then just keep reading the 8 bits from address
mem[addr[3:0]]; //read normaly
    assign io_data = (bus_writable) ? out : 8'hZZ;

endmodule
