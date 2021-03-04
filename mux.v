`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:53:30 11/26/2020 
// Design Name: 
// Module Name:    mux 
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
module mux #(
		parameter D_WIDTH = 8
	)(
		// Clock and reset interface
		input clk,
		input rst_n,
		
		//Select interface
		input[1:0] select,
		
		// Output interface
		output reg[D_WIDTH - 1 : 0] data_o,
		output reg						 valid_o,
				
		//output interfaces
		input [D_WIDTH - 1 : 0] 	data0_i,
		input   							valid0_i,
		
		input [D_WIDTH - 1 : 0] 	data1_i,
		input   							valid1_i,
		
		input [D_WIDTH - 1 : 0] 	data2_i,
		input     						valid2_i
    );
	
	//TODO: Implement MUX logic here

reg data_o_aux0;
reg data_o_aux1;
reg data_o_aux2;
reg[D_WIDTH - 1 : 0] data_stoc;


	always@(posedge clk) begin
		if(!rst_n) begin
			valid_o <= 0;
			data_o <= 0;
			data_o_aux0 <= 0;
			data_o_aux1 <= 0;
			data_o_aux2 <= 0;
			
			data_stoc <= 0;
		end
		
		if(valid0_i) begin //se verifica intrarea datelor pe valid pt citire
			data_o_aux0 <= 1;
			data_stoc <= data0_i;
		end
		if(valid1_i) begin
			data_o_aux1 <= 1;
			data_stoc <= data1_i;
		end
		if(valid2_i) begin
			data_o_aux2 <= 1;
			data_stoc <= data2_i;
		end
		
		case(select) //in functie de semnalul select se alege pe ce cale se va duce informatia 
		//si se verifica daca a fost citita pe valid informatia respectiva
			2'b00: begin
				if(data_o_aux0 == 1) begin
					data_o <= data_stoc;
					valid_o <= 1;
					data_o_aux0 <= 0;
				end
			end
			
			2'b01: begin
				if(data_o_aux1 == 1) begin
					data_o <= data_stoc;
					valid_o <= 1;
					data_o_aux1 <= 0;
				end
			end
			
			2'b10: begin
				if(data_o_aux2 == 1) begin
					data_o <= data_stoc;
					valid_o <= 1;
					data_o_aux2 <= 0;
				end
			end
		endcase
		
	if(valid_o == 1)
		valid_o <= 0;
	end
endmodule
