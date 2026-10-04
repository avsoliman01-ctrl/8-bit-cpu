`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Adel-Van Soliman
// 
// Create Date: 08/16/2026 02:00:47 PM
// Design Name: 
// Module Name: Register
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


module Register #(
    parameter DATA_WIDTH = 8
)(
    input wire clk, // clock
    input wire rst, // reset
    input wire we, // write enable
    input wire bus_writable, // controls whether register drives the bus
    
    output wire [DATA_WIDTH-1:0] o_data, // output data
    inout wire [DATA_WIDTH-1:0] io_data // used for inputting and outputting data
);

    reg [DATA_WIDTH-1:0] register;

    initial begin
        register = 8'h00; // initialize all bits of the register to 0
    end
        
    always @(posedge clk or posedge rst) begin 
        // runs on rising clock edge or rising reset
        
        if (rst) begin
            register <= 8'h00; 
            // <= is nonblocking assignment, normally used for sequential logic
        end 
        else begin
            if (we)
                register <= io_data; 
        end
    end
        
    assign io_data = bus_writable ? register : 8'hzz;
    // bus_writable = 1 -> register drives io_data
    // bus_writable = 0 -> register disconnects from bus (high impedance)
    
    assign o_data = register;
            
endmodule
