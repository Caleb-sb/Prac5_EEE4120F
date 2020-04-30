`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.04.2020 20:09:03
// Design Name: 
// Module Name: quartsine
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
module quartsine(
    input clka,
    input [7:0] addra,
    output [10:0] douta);

reg ena = 1;
reg wea = 0;
reg [10:0] dina = 0;

sinequarter_blk_mem_gen_0 dut(
        .clka(clka),
        .ena(ena),
        .wea(wea),      
        .addra(addra),  
        .dina(dina),    
        .douta(douta)
        );

endmodule
