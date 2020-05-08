`timescale 1ns / 1ps
//------------------------------------------------------------------------------
// File name   :   bram_tb.v
// Module Name :   bram_tb
// Function    :   Tests the output of BRAM depending on implementation chosen
//                 at C4
// Coder       :   Caleb Bredekamp [BRDCAL003]
// Comments    :   One test bench was used for both implementations. Just need
//                 to comment the implementation you don't want to test.
//------------------------------------------------------------------------------
module bram_tb;

//---------------------------General BRAM Variables-----------------------------
reg clka = 0;           // Clock for port A
reg [7:0] addra = 0;    // 8bit address
wire [10:0] douta;      // BRAM output
//---------------------------FullSine Only Variables----------------------------
//reg ena = 1;          // Enable read on part A
//reg wea = 0;          // Disable write on port A
//reg [10:0] dina = 0;  // Data input

//----------------------------QuarterSine BRAM Init-----------------------------
quartsine dut(
    .clka(clka),
    .addra(addra),      // 8bit address to be translated to 6bit address
    .douta2(douta)      // Manipulated output value
    );

//----------------------------QuarterSine BRAM Init-----------------------------
//fullsine_mem_blk dut(
//    .clka(clka),
//    .ena(ena),
//    .wea(wea),
//    .addra(addra),
//    .dina(dina),
//    .douta(douta)
//    );

//-------------------------PWM Output and Module Init---------------------------
wire pwm_out;

pwm_module uut(
        .clk(clka),
        .PWM_in(douta),
        .PWM_out(pwm_out)
    );


reg [10:0] counter = 0; // Frequency counter to find middle C note

//--------------------------Print Format to Console-----------------------------
initial begin
    $display("\t||   Time   |    Sine    |  PWM_in  ||");
    $display("\t--------------------------------------");
end

//-------------------------Clock Generation f=100MHz----------------------------
always
    #5 clka <= ~clka;

//---------------------------Output at 261 Hz: C4-------------------------------
always @(posedge clka) begin
    counter = counter + 1'b1;
    if(counter >= 1493) begin
        addra = addra +1'b1;
        counter <= 11'b0;
    end
end

//----------------------------Print Douta to Console----------------------------
// Acts like a modified monitor statement to only print when douta changes and
// not the address. Did it this way to avoid confusion with the 2 wave delay
// before BRAM output changes
always @(douta)
    $display("\t||%f\t|\t%d\t |\t%d\t||", $bitstoreal(addra/(128/3.14159)), douta, douta);


endmodule
