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

module decryption_top#(
			parameter addr_witdth = 8,
			parameter reg_width 	 = 16,
			parameter MST_DWIDTH = 32,
			parameter SYS_DWIDTH = 8
		)(
		// Clock and reset interface
		input clk_sys,
		input clk_mst,
		input rst_n,
		
		// Input interface
		input [MST_DWIDTH -1 : 0] data_i,
		input 						  valid_i,
		output busy,
		
		//output interface
		output [SYS_DWIDTH - 1 : 0] data_o,
		output      					 valid_o,
		
		// Register access interface
		input[addr_witdth - 1:0] addr,
		input read,
		input write,
		input [reg_width - 1 : 0] wdata,
		output[reg_width - 1 : 0] rdata,
		output done,
		output error
		
    );
	
	
	// TODO: Add and connect all Decryption blocks
	
	wire [reg_width - 1 : 0] select;
   wire [reg_width - 1 : 0] caesar_key;
   wire [reg_width - 1 : 0] scytale_key;
   wire [reg_width - 1 : 0] zigzag_key;
   wire [SYS_DWIDTH - 1 : 0]     data0_o;
   wire                         valid0_o;
   wire [SYS_DWIDTH - 1 : 0]     data1_o;
   wire                         valid1_o;
   wire [SYS_DWIDTH - 1 : 0]     data2_o;
   wire                         valid2_o;

	//mux
	wire [SYS_DWIDTH - 1 : 0] 		 data0_i;
	wire                        valid0_i;
	wire [SYS_DWIDTH - 1 : 0] 	    data1_i;
	wire   							valid1_i;
	wire [SYS_DWIDTH - 1 : 0] 		data2_i;
	wire     						valid2_i;
	
	//caesar	
    wire caesar_busy;
	 wire [SYS_DWIDTH - 1 : 0] data_caesar_o;
	 wire valid_caesar_o;
	
	//scytale
	wire scytale_busy;
	wire [SYS_DWIDTH - 1 : 0] data_scytale_o;
	wire valid_scytale_o;
    
   decryption_regfile D_REGF(clk_sys, rst_n, addr,read,write, wdata,rdata,done,error,select,caesar_key,scytale_key,zigzag_key);
   demux DMUX(clk_sys, clk_mst,rst_n,select,data_i, valid_i,data0_o,valid0_o,data1_o,valid1_o,data2_o,valid2_o );
	mux MUX(clk_sys,rst_n,select[1:0],data_o,valid_o,data0_i,valid0_i,data1_i,valid1_i,data2_i,valid2_i);
	caesar_decryption C_D(clk_sys,rst_n,data0_i,valid0_i,caesar_key,caesar_busy,data_caesar_o,valid_caesar_o);
	scytale_decryption S_D(clk_sys,rst_n,data1_i,valid1_i,scytale_key[15:8],scytale_key[7:0],data_scytale_o,valid_scytale_o,scytale_busy);

	or(busy, busy_caesar, busy_scytale);
endmodule
