`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:13:49 11/23/2020 
// Design Name: 
// Module Name:    decryption_regfile 
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
module decryption_regfile #(
			parameter addr_witdth = 8,
			parameter reg_width 	 = 16
		)(
			// Clock and reset interface
			input clk, 
			input rst_n,
			
			// Register access interface
			input[addr_witdth - 1:0] addr,
			input read,
			input write,
			input [reg_width -1 : 0] wdata,
			output reg [reg_width -1 : 0] rdata,
			output reg done,
			output reg error,
			
			// Output wires
			output reg[reg_width - 1 : 0] select,
			output reg[reg_width - 1 : 0] caesar_key,
			output reg[reg_width - 1 : 0] scytale_key,
			output reg[reg_width - 1 : 0] zigzag_key
    );

// TODO implementati bancul de registre.
	reg [reg_width - 1 : 0] variab_select;
reg [reg_width - 1 : 0] variab_caesar;
reg [reg_width - 1 : 0] variab_scytale;
reg [reg_width - 1 : 0] variab_zigzag;
reg done_aux;

	always@(posedge clk) begin
		if(!rst_n) begin
			rdata <= 0;
			done <= 0;
			variab_select<= 16'h0;
			variab_caesar <= 16'h0;
			variab_scytale <= 16'hFFFF;
			variab_zigzag  <= 16'h2;
		end
		
		
		if(write && !read) begin
			case(addr)
				8'h00: begin // select
					variab_select[1:0] <= wdata[1:0];
					done_aux <= 1;
				end
				
				8'h10: begin //caesar_key
					variab_caesar<= wdata;
					done_aux <= 1;
				end
				
				8'h12: begin //scytale_key
					variab_scytale <= wdata;
					done_aux <= 1;
				end
			
				8'h14: begin //zigzag_key
					variab_zigzag <= wdata;
					done_aux <= 1;
				end
				
				default: begin //acces la registru inexistent
					error <= 1;
					rdata <= 0;
					done_aux <= 1;
				end
			endcase		
		end
			
		if(read && !write) begin
			case(addr)
				8'h00: begin // select
					rdata <= variab_select[1:0];
					done_aux <= 1;	
				end
				
				8'h10: begin //caesar_key
					rdata <= variab_caesar;
					done_aux <= 1;
				end
				
				8'h12: begin //scytale_key
					rdata <= variab_scytale;
					done_aux <= 1;
				end
			
				8'h14: begin //zigzag_key
					rdata <= variab_zigzag;
					done_aux <= 1;
				end
				
				default: begin
					error <= 1;
					rdata <= 0;
					done_aux <= 1;
				end
			endcase	
		end
			
		
		if(done_aux == 1) begin
			done <= 1;
		end
	
		if(done_aux == 1 && done == 1) begin //pentru a trece done in 0 pe urmatorul ciclu de ceas
			done <= 0;
			error <= 0;
		end
		
	end
	
	
	always @(*)begin //pt scriere asincrona
		select = variab_select;
		caesar_key = variab_caesar;
		scytale_key = variab_scytale;
		zigzag_key = variab_zigzag;
	end
	
endmodule
