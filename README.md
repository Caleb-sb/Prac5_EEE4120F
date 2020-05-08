# Prac5_EEE4120F
A tone and arpeggio generator on an FPGA using BRAM

For a demo video of assignment functionality, please see: https://youtu.be/uMw0D096LuY

## Test Bench
The test bench needs to be altered according to the BRAM name you've created and certain inputs and outputs need to be changed according to the implmentation (quartersine or fullsine). It prints the output of the BRAM block as the output changes. Please see the report for more details.

## Adding to Vivado
After downloading, add all .v files to Design Sources except for bram_tb.v. Add the constr.xdc file to Constraints and bram_tb.v file to Simulation Sources.

The BRAM needs to be generated using Vivado's IP Catalog and named according to the implementation you need to run. Use the .coe files to load the BRAM with the necessary values depending on the implementation chosen.

## Changing Base_f
The SW[] taken as input into the top.v module will adjust the base frequency as well as the arpeggio frequency. It starts around C4.

## Changing modes
The button (BTNL originally) taken as input to the top.v module will change from base_f mode to arpeggio mode.
