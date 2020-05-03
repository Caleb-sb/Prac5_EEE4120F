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
//reg ena = 1;
//reg wea = 0;
reg [7:0] addra = 0;
//reg [10:0] dina = 0;

//BRAM output
wire [10:0] douta;

quartsine dut(
    .clka(clka),
    .addra(addra),
    .douta2(douta)
    );

//fullsine_mem_blk dut(
//    .clka(clka),
//    .ena(ena),      
//    .wea(wea),      
//    .addra(addra),  
//    .dina(dina),    
//    .douta(douta)  
//    );

wire pwm_out;

pwm_module uut(
        .clk(clka),
        .PWM_in(douta),
        .PWM_out(pwm_out)
    );
    
//Frequency counter to find middle C note
reg [10:0] counter = 0;

initial begin
    $display("\t||   Time   |    Sine    |  PWM_in  ||");
    $display("\t--------------------------------------");
    //$monitor("\t||%f\t|\t%d\t |\t %d \t||", $bitstoreal(addra/(127/3.14159)), douta, douta);
end

always
    #5 clka <= ~clka;
    
always @(posedge clka) begin
    counter = counter + 1'b1;
    if(counter >= 1493) begin
        addra = addra +1'b1;
        counter <= 11'b0;
        
    end
end

always @(douta)
         $display("\t||%f\t|\t%d\t |\t%d\t||", $bitstoreal(addra/(128/3.14159)), douta, douta);
endmodule