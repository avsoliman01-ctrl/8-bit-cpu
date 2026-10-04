`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Adel-Van Soliman
// 
// Create Date: 08/24/2026 12:15:55 pm
// Design Name: 
// Module Name: alu
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


module alu #(
    parameter DATA_WIDTH = 8)
    (
    input wire clk,
    input wire rst,
    input wire [DATA_WIDTH-1:0] a,
    input wire [DATA_WIDTH-1:0] b,
    input wire [2:0] opcode,
    input wire carry_in,
    input wire bus_writable,
    input wire we_f,
    output wire [DATA_WIDTH-1:0] c,
    output reg overflow_f,
    output reg carry_f, //flag carry
    output reg zero_f, //flag zero
    inout wire [DATA_WIDTH-1:0] io_data
    );
    reg [DATA_WIDTH-1:0] result;
    reg [DATA_WIDTH:0] tmp; //temp register
    reg carry;
    reg overflow;
    reg zero;
    always @(*) begin
        result = {DATA_WIDTH{1'b0}};
        tmp = {DATA_WIDTH+1{1'b0}};
        
        carry = 1'b0;
        overflow = 1'b0;
        zero = 1'b0;
        
        //opcode cases
     case (opcode)
        //add
        3'b000: begin
            tmp = {1'b0, a} + {1'b0, b};
            result = tmp[DATA_WIDTH-1:0];
            carry = tmp[DATA_WIDTH];
            
            overflow = (~(a[DATA_WIDTH-1] ^ b[DATA_WIDTH-1])) 
            & (result[DATA_WIDTH-1] ^ a[DATA_WIDTH-1]);
        end
        //add with carry
        3'b001: begin
            tmp = {1'b0, a} + {1'b0, b} + carry_in;
            
            result = tmp[DATA_WIDTH-1:0];
            carry = tmp[DATA_WIDTH];
            overflow = (~(a[DATA_WIDTH-1] ^ b[DATA_WIDTH-1])) 
            & (result[DATA_WIDTH-1] ^ a[DATA_WIDTH-1]);
        end
        //subtract
        3'b010: begin
            tmp = {1'b0, a} + {1'b0, ~b} + 1'b1; //flip b then add 1 then add it to 2
            result = tmp[DATA_WIDTH-1:0];
            carry = tmp[DATA_WIDTH];
            overflow = (a[DATA_WIDTH-1] ^ b[DATA_WIDTH-1]) 
            & (result[DATA_WIDTH-1] ^ a[DATA_WIDTH-1]);
        end
        //increment
        3'b011: begin
            tmp = {1'b0, a} + 1'b1;
            result = tmp[DATA_WIDTH-1:0];
            carry = tmp[DATA_WIDTH];
        end
        
        //deincrement
        3'b100: begin
            result = a - 1'b1;
        end
        
        //negate
        3'b101: begin
            result = (~a)+ 1'b1;
        end
        
        //and
        3'b110: begin
            result = a & b;
        end
        
        //or
        3'b111: begin
            result = a | b;
        end
        default: begin
            result = {DATA_WIDTH{1'b0}};
        end
    endcase
    
    if (result == {DATA_WIDTH{1'b0}})
        zero = 1'b1;
    else
        zero = 1'b0;
    end
    
    always@(posedge clk or posedge rst) begin
        if(rst) begin
            carry_f <= 1'b0;
            zero_f <= 1'b0;
            overflow_f <= 1'b0;
        end
        
        else begin
            if (we_f) begin
                carry_f <= carry;
                zero_f <= zero;
                overflow_f <= overflow;
            end
        end
    end
    assign c = result;
    assign io_data = bus_writable ? result : {DATA_WIDTH{1'bz}};        
            
endmodule
