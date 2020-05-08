`timescale 1ns / 1ps
//------------------------------------------------------------------------------
// File name   :   quartsine.v
// Module Name :   quartsine
// Function    :   Implements BRAM with one quarter of a sinusoidal wave and
//                 translates it to output as a full sine wave
// Coder       :   Caleb Bredekamp [BRDCAL003] Taboka Nyadza [NYDTAB001]
// Comments    :   To get rid of repeating values, the fullsine.coe was edited
//                 and moved up a sample to exclude 1024. This meant it had to
//                 be added in the code below. Manipulations adapted from:
//                 https://zipcpu.com/dsp/2017/08/26/quarterwave.html
//------------------------------------------------------------------------------
module quartsine(
    //Quartsine Inputs
    input clka,
    input [7:0] addra,
    //Quartsine Outputs
    output reg [10:0] douta2=0);

//---------------------------BRAM IP inputs and outputs-------------------------
    reg ena = 1;                //Enabling reading on port A
    reg wea = 0;                //Disabling write on port A
    reg [10:0] dina = 0;        //Data into port A
    reg [5:0] trans_addr =0;    //The translated 6bit address from the 8bit addr
    wire [10:0] douta;          //Data to be read from BRAM

//----------------------------Initialising BRAM Block---------------------------
    quartersine_mem_blk qsine(
        .clka(clka),            // input wire clka
        .ena(ena),              // input wire ena //enable port a
        .wea(wea),              // input wire [0 : 0] wea // write enable a
        .addra(trans_addr),     // input wire [7 : 0] addra //address a
        .dina(dina),            // input wire [10 : 0] dina //data in
        .douta(douta)           // output wire [10 : 0] douta //data out
        );

//--------------Manipulating addresses and outputs to get fullsine--------------
    always @(posedge clka) begin
        case({addra[7:6]})
            2'b00: begin
                if (addra[5:0] == 0)
                    douta2 <= 1024;                 //The first value at t0
                else if (addra[5:0] > 0)begin
                    trans_addr <= (addra[5:0]-1'b1);//Address as is but shifted
                    douta2 <= douta;                //Output as is
                end
            end
            // Fullsine prints 3 values at 2047
            2'b01: begin
                trans_addr <= ~addra[5:0];          //Reverse order of access
                douta2 <= douta;                    //Output as is

            end
            2'b10: begin
                if (addra[5:0] == 0)
                    douta2 <= 1024;                 //Value at t=pi
                else if (addra[5:0] > 0)begin
                    trans_addr <= (addra[5:0]-1'b1);//Address as is but shifted
                    douta2 <= 2047-douta;           //'Negative' of output
                end
            end
            // Fullsine prints 3 values at 0
            2'b11: begin
                trans_addr <= ~addra[5:0];          //Reverse order of access
                douta2 <= 2047-douta;               //'Negative' of output
            end
        endcase
    end

endmodule
