`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:17:08 11/23/2020 
// Design Name: 
// Module Name:    ceasar_decryption 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module caesar_decryption #(
				parameter D_WIDTH = 8,
				parameter KEY_WIDTH = 16
			)(
			// Clock and reset interface
			input clk,
			input rst_n,
			
			// Input interface
			input[D_WIDTH - 1:0] data_i,
			input valid_i,
			
			// Decryption Key
			input[KEY_WIDTH - 1 : 0] key,
			
			// Output interface
            output reg busy,
			output reg[D_WIDTH - 1:0] data_o,
			output reg valid_o
    );

// TODO: Implement Caesar Decryption here
reg[D_WIDTH - 1:0] data_o_aux;
//reg valid_o_aux;

always @(posedge clk) begin
	if (!rst_n || !valid_i) begin
		data_o_aux <= 0;
		valid_o <= 0;
	end
	busy <= 0;
	if (valid_i) begin //decriptare
		data_o_aux <= data_i-key;
		valid_o<= 1;
	end
	
end

always@(*) begin
	data_o = data_o_aux;
end
endmodule
