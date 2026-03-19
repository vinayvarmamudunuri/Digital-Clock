# Digital Clock Verilog

## Description
This project implements a 12-hour digital clock using Verilog.
It displays hours, minutes, seconds, and AM/PM.

## Inputs
- clk clock signal
- reset resets to 12:00:00 AM
- ena 1-second enable signal

## Outputs
- hh[7:0] hours in BCD
- mm[7:0] minutes in BCD
- ss[7:0] seconds in BCD
- pm AM/PM indicator

## Working
- Seconds count from 00 to 59
- Minutes increment when seconds reach 59
- Hours increment when time is 59:59
- Format 01 to 12 and repeats
- PM toggles at 11:59:59 to 12:00:00

## BCD Format
- 12 is 0001 0010
- 45 is 0100 0101
- 59 is 0101 1001

## Modules
- unittimer counts 0 to 9
- tentimer counts 0 to 5

## Author
Vinay Varma Mudunuri

Department of Electronics Engineering

IIT(BHU) Varanasi
