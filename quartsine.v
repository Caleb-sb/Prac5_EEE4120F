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
    output reg [10:0] douta2);

reg ena = 1;
reg wea = 0;
reg [10:0] dina = 0;
reg [5:0] val;
wire [10:0] douta;

always @* begin
    case({addra[7],addra[6]})
        2'b00: begin 
            val = addra[5:0];
            douta2 = douta;
        end
        2'b01: begin
            val = ~addra[5:0];
            douta2 = douta;
        end
        2'b10: begin
            val = addra[5:0];
            douta2 = 1024-(douta-1024);
        end
        2'b11: begin
            val = ~addra[5:0];
            douta2 = 1024-(douta-1024);
        end
    endcase
end

sinequarter_blk_mem_gen_0 dut(
        clka,
        ena,
        wea,      
        val,  
        dina,    
        douta
        );

//always @* begin
//   casez({addra[7],addra[6]})
//        2'b00: douta2 <= douta;
//        2'b10: douta2 <= douta;
//        2'b11: douta2 <= douta;
//   endcase
//end

endmodule
