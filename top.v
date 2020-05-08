`timescale 1ns / 1ps
//------------------------------------------------------------------------------
// File name   :   top.v
// Module Name :   top
// Function    :   Implements FSM to output arpeggio or just base note
// Coder       :   Caleb Bredekamp [BRDCAL003]
// Comments    :   Adapted from template given by Keegan Crankshaw:
//                 https://github.com/UCT-EE-OCW/EEE4120F-Pracs
//------------------------------------------------------------------------------
module top(
    input  CLK100MHZ,
    input [7:0] SW,
    input BTNL,

    output AUD_PWM,
    output AUD_SD,
    output [1:0] LED
    );

    // Toggle arpeggiator enabled/disabled
    wire arp_switch;
    Debounce change_state (CLK100MHZ, BTNL, arp_switch);


//----------------------------Module/BRAM Init----------------------------------
// Uncomment the ena, wea, dina and fullsine module to use with fullsine BRAM


    reg    [7:0]    addra = 0;
    wire   [10:0]   douta;

    quartsine qsine_bram (
        .clka(CLK100MHZ),   // input wire clka
        .addra(addra),      // input wire [7 : 0]   addra   - address a
        .douta2(douta)      // output wire [10 : 0] douta   - data out
    );

//    reg ena           =   1;
//    reg wea           =   0;
//    reg [10:0] dina   =   0; //We're not putting data in - leaving as 0
//    fullsine_mem_blk fsine(
//        .clka(CLK100MHZ),
//        .ena(ena),          // input wire ena               - enable port a
//        .wea(wea),          // input wire [0 : 0]   wea     - write enable a
//        .addra(addra),      // input wire [7 : 0]   addra   - address a
//        .dina(dina),        // input wire [10 : 0]  dina    - data in
//        .douta(douta)       // output wire [10 : 0] douta   - data out
//        );

//-------------------------------PWM Output-------------------------------------
    // This gets tied to the BRAM
    reg [10:0] PWM;

    pwm_module pwm_mod(
        .clk(CLK100MHZ),
        .PWM_in(PWM),
        .PWM_out(AUD_PWM)
    );

//----------------------Sequential and FSM Variables----------------------------
    reg [12:0]  clkdiv      =   0;  // Used to set frequency in both modes
    reg [26:0]  note_switch =   0;  // 500ms timer
    reg [1:0]   note        =   0;  // which note in arp (in FSM)
    reg [9:0]   f_base      =   0;  // base note (added an extra bit for 746)
    reg arp_mode            =   0;  // Outputting arp or base note
    reg prev_arp_switch     =   0;


//----------------Sequential Arpeggio Operation and FSM Cases-------------------
always @(posedge CLK100MHZ) begin

    PWM     <= douta;               // tie memory output to the PWM input
    clkdiv  <= clkdiv + 1'b1;

    f_base[9:0] = 746 + SW[7:0];    // get the "base" frequency

    // Switching from base_f mode to arp mode on rising edge
    if (!arp_mode && arp_switch && !prev_arp_switch) begin
        arp_mode        <=  1;
        prev_arp_switch <=  1;
        note            <=  0;
    end
    // Switching from Arp mode to base_f mode on rising edge
    else if(arp_mode && arp_switch && !prev_arp_switch) begin
        arp_mode        <=  0;
        prev_arp_switch <=  1;
        note            <=  0;
    end
    if(!arp_switch) prev_arp_switch <= 0;   //Resetting to detect rising edge

    // Change the output note IF we're in the arp state
    if (arp_mode) begin
        note_switch <= note_switch + 1; // keep track of when to change notes
        if (note_switch == 50000000) begin
            note        <=  note +1'b1;
            note_switch <=  0;
        end
    end


//------FSM to switch between notes, otherwise just output the base note--------
    case(note)
        0: begin // base note
            if (clkdiv >= 2*f_base) begin //1492 (@SW=0)
                clkdiv[12:0] <= 0;
                addra <= addra +1;
            end
        end
        1: begin // 1.25 faster
            if (clkdiv >= (f_base*127/80)) begin //1185.04 (@SW=0)
                clkdiv[12:0] <= 0;
                    addra <= addra +1;
            end
        end
        2: begin //1.5 times faster
            if (clkdiv >= (f_base*161/120)) begin //996.49 (@SW=0)
                clkdiv[12:0] <= 0;
                addra <= addra +1;
            end
        end
        3: begin //2 times faster
            if (clkdiv >= f_base) begin //746.9 (@SW=0)
                clkdiv[12:0] <= 0;
                addra <= addra +1;
            end
        end
        default: begin // Don't know what's happening, just output middle C
            if (clkdiv >= 1493) begin
                clkdiv[12:0] <= 0;
                addra <= addra +1;
            end
        end
    endcase
end

//----------------------------Specifying Ouputs---------------------------------
assign AUD_SD = 1'b1;  // Enable audio out
assign LED[1:0] = note[1:0]; // Tie FRM state to LEDs


endmodule
