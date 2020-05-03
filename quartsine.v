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
    output reg [10:0] douta2=0);

    reg ena = 1;
    reg wea = 0;
    reg [10:0] dina = 0;
    reg [5:0] trans_addr =0;
    wire [10:0] douta;

    quartersine_mem_blk qsine(
        .clka(clka),    // input wire clka
        .ena(ena),      // input wire ena //enable port a
        .wea(wea),      // input wire [0 : 0] wea // write enable a
        .addra(trans_addr),  // input wire [7 : 0] addra //address a
        .dina(dina),    // input wire [10 : 0] dina //data in
        .douta(douta)  // output wire [10 : 0] douta //data out
        );

    always @(posedge clka) begin
        case({addra[7:6]})
            2'b00: begin
                if (addra[5:0] == 0)
                    douta2 <= 1024;
                else if (addra[5:0] > 0)begin
                    trans_addr <= (addra[5:0]-1'b1);
                    douta2 <= douta;
                end
            end
            2'b01: begin
                trans_addr <= ~addra[5:0];
                douta2 <= douta;
                
            end
            2'b10: begin
                if (addra[5:0] == 0)
                    douta2 <= 1024;
                else if (addra[5:0] > 0)begin
                    trans_addr <= (addra[5:0]-1'b1);
                    douta2 <= 2047-douta;
                end
            end
            2'b11: begin
                trans_addr <= ~addra[5:0];
                douta2 <= 2047-douta;
            end
        endcase
    end

endmodule
