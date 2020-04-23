`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/23/2020 06:54:05 PM
// Design Name: 
// Module Name: bram_tb
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
module bram_tb;

//BRAM inputs
reg clka = 0;
reg ena = 1;
reg wea = 0;
reg [7:0] addra = 0;
reg [10:0] dina = 0;

//BRAM output
wire [10:0] douta;

fullsine_mem_blk dut(
    .clka(clka),
    .ena(ena),      
    .wea(wea),      
    .addra(addra),  
    .dina(dina),    
    .douta(douta)  
    );

//Frequency counter to find C
reg [10:0] counter = 0;

initial begin
    $display("\t||\t\t  Time  \t\t|    Sine    ||");
    $display("\t---------------------------------------");
    $monitor("\t||%d\t|\t%d\t ||", $time, douta);
end

always
    #5 clka <= ~clka;
    
always @(posedge clka) begin
    counter = counter + 1'b1;
    if(counter >= 11'b10111010101) begin
        addra = addra +1'b1;
        counter <= 11'b0;
        
    end
end
endmodule