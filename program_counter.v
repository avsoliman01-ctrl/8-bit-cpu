`timescale 1ns / 1ps

module program_counter #( parameter ADDR_WIDTH = 4)(
	input wire clk,
	input wire rst,
	input wire pc_inc,
	input wire pc_load,
	input wire [ADDR_WIDTH-1:0] load_value,

	output reg [ADDR_WIDTH-1:0] pc
);

	always @(posedge clk or posedge rst) begin
		if(rst) begin
			pc <={ADDR_WIDTH{1'b0}};
		end
		else if (pc_load) begin
			pc <= load_value;
		end
		else if (pc_inc) begin
			pc <= pc + 1'b1;
		end
	end

endmodule
