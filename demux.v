`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:12:00 11/23/2020 
// Design Name: 
// Module Name:    demux 
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

module demux #(
		parameter MST_DWIDTH = 32,
		parameter SYS_DWIDTH = 8
	)(
		// Clock and reset interface
		input clk_sys,
		input clk_mst,
		input rst_n,
		
		//Select interface
		input[1:0] select,
		
		// Input interface
		input [MST_DWIDTH -1  : 0]	 data_i,
		input 						 	 valid_i,
		
		//output interfaces
		output reg [SYS_DWIDTH - 1 : 0] 	data0_o,
		output reg     						valid0_o,
		
		output reg [SYS_DWIDTH - 1 : 0] 	data1_o,
		output reg     						valid1_o,
		
		output reg [SYS_DWIDTH - 1 : 0] 	data2_o,
		output reg     						valid2_o
		
    );
	
	
	// TODO: Implement DEMUX logic
	reg[7:0] i;
	reg valid0_o_aux;
	reg valid1_o_aux;
	reg valid2_o_aux;
	reg [MST_DWIDTH -1  : 0] vect_stoc;
	integer count;
	
	always@(posedge clk_sys) begin
		if(!rst_n) begin
			data0_o <= 0;
			data1_o <= 0;
			data2_o <= 0;
			valid0_o <= 0;
			valid1_o <= 0;
			valid2_o <= 0;
			
			count <= 0;
			i <= 0;

		end
		if(valid_i)
			count <= count + 1;

		if (count+1 >= 4) begin
			case(select)
				2'b00: begin
					valid0_o <= 1;
					//data0_o <= vect_stoc[8*i+:8]; //am incercat o varianta cu operatorul part select
					//if(i+1<4) begin
					//	i <= i+1;
				/*	end else begin
						i <= 0;
						valid0_o <= 0;
					end*/
					if(i+1 > 3) begin
						i<=0;
						valid0_o <= 0;
					end else begin
						i<= i+1;
						
					if(i == 0)
						data0_o <= data_i[31:24];
					if(i == 1)
						data0_o <= vect_stoc[23:16];
					if(i == 2)
						data0_o <= vect_stoc[15:8];
					if(i == 3)
						data0_o <= vect_stoc[7:0];
					end
				end
				
				2'b01: begin
					valid1_o <= 1;
					if(i+1 > 3) begin
						i<=0;
						valid1_o <= 0;
					end else begin
						i<= i+1;
						
					if(i == 0)
						data1_o <= data_i[31:24];
					if(i == 1)
						data1_o <= vect_stoc[23:16];
					if(i == 2)
						data1_o <= vect_stoc[15:8];
					if(i == 3)
						data1_o <= vect_stoc[7:0];
					end

				end
				
				2'b10: begin
					valid2_o <= 1;
					if(i+1 > 3) begin
						i<=0;
						valid2_o <= 0;
					end else begin
						i<= i+1;
						
					if(i == 0)
						data2_o <= data_i[31:24];
					if(i == 1)
						data2_o <= vect_stoc[23:16];
					if(i == 2)
						data2_o <= vect_stoc[15:8];
					if(i == 3)
						data2_o <= vect_stoc[7:0];
					end
				end
				
			endcase
			
			
		end
	//	count <= 0; //aici s-ar fi resetat count, dar l-am scos pt debugging
	end
	
	always@(posedge clk_mst) begin
		if(!rst_n) begin
			vect_stoc <= 0;
		end
		
		if(valid_i) 
			vect_stoc <= data_i;

	end

endmodule
