`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:24:12 11/27/2020 
// Design Name: 
// Module Name:    scytale_decryption 
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
module scytale_decryption#(
			parameter D_WIDTH = 8, 
			parameter KEY_WIDTH = 8, 
			parameter MAX_NOF_CHARS = 50,
			parameter START_DECRYPTION_TOKEN = 8'hFA
		)(
			// Clock and reset interface
			input clk,
			input rst_n,
			
			// Input interface
			input[D_WIDTH - 1:0] data_i,
			input valid_i,
			
			// Decryption Key
			input[KEY_WIDTH - 1 : 0] key_N,
			input[KEY_WIDTH - 1 : 0] key_M,
			
			// Output interface
			output reg[D_WIDTH - 1:0] data_o,
			output reg valid_o,
			
			output reg busy
    );

// TODO: Implement Scytale Decryption here

reg [7:0] i;
reg [7:0] j;
reg [7:0] size_vect;
reg[D_WIDTH - 1:0] data_o_aux;

reg[D_WIDTH - 1:0] vect_stoc [49:0];
//vector de mai multe caractere cu 0xFA in cap

always@(posedge clk) begin

	if(!rst_n) begin
		data_o<=0;
		valid_o <=0;
		busy<= 0;
		i <= 0;
	   j <= 0;
		size_vect <= 0;
	end

	else if(rst_n) begin
	
		if(valid_i == 1 && data_i!= 8'hFA) begin
			vect_stoc[size_vect] <= data_i; //scriere in vector de caractere
			size_vect <= size_vect+1;
		end
		
		
		if(data_i == 8'hFA)
			busy<= 1;
		
		if(busy == 1) begin
			if(j<key_M) begin
				data_o <= vect_stoc[i+key_N*j]; //decriptare
				valid_o <= 1;
				if (j+1 == key_M && i< key_N) begin
					i <= i+1;
					j <= 0;
				end
				else begin
					j <= j+1;
					end
				
			end
		if(i == key_N) begin //reinitializare cand se ajunge la capatul vectorului decriptat
			size_vect <= 0;
			i<=0;
			j <= 0;
			busy <= 0;
			valid_o <= 0;
			data_o <= 0;


		end

		end
		

	end

end
endmodule
