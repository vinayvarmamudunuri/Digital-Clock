`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.03.2026 19:03:12
// Design Name: 
// Module Name: digitalclock
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


module digitalclock(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg[7:0] ss);
    
    wire [1:0]enasec,enamin,enahr;
    assign enasec[0]=ena;
    
    //for seconds
    unittimer s0(clk,reset,enasec[0],ss[3:0]);
    assign enasec[1]=(ss[3:0]==9)&&enasec[0];
    tentimer s1(clk,reset,enasec[1],ss[7:4]);

    //for minutes
    assign enamin[0]=(ss[3:0]==9)&&(ss[7:4]==5);
        unittimer m0(clk,reset,enamin[0],mm[3:0]);
    assign enamin[1]=(mm[3:0]==9)&&(ss[3:0]==9)&&(ss[7:4]==5);
    tentimer m1(clk,reset,enamin[1],mm[7:4]);

    //for hours
    assign enahr[0]=(mm[7:4]==5)&&(mm[3:0]==9)&&(ss[3:0]==9)&&(ss[7:4]==5);
        assign enahr[1]=(hh[3:0]==9)&&(mm[7:4]==5)&&(mm[3:0]==9)&&(ss[3:0]==9)&&(ss[7:4]==5);
    always@(posedge clk)
        begin
            if(reset)begin
                hh[3:0]<=4'b0010;             
            end
            else if(((hh[7:4]==1)&&(hh[3:0]==2)&&(mm[7:4]==5)&&(mm[3:0]==9)&&(ss[3:0]==9)&&(ss[7:4]==5)))
                        hh[3:0]<=1;
            else if(enahr[0])
                begin
                    if(((hh[7:4]==1)&&(hh[3:0]==1)&&(mm[7:4]==5)&&(mm[3:0]==9)&&(ss[3:0]==9)&&(ss[7:4]==5)))
                        hh[3:0]<=4'b0010;
                    else if(hh[3:0]==4'b1001)
                        hh[3:0]<=4'b0000;
                    else 
                        hh[3:0]<=hh[3:0]+1;
                end
        end
    always@(posedge clk)
        begin
            if(reset)
                hh[7:4]<=4'b0001; 
            else if(((hh[7:4]==1)&&(hh[3:0]==2)&&(mm[7:4]==5)&&(mm[3:0]==9)&&(ss[3:0]==9)&&(ss[7:4]==5)))
                        hh[7:4]<=4'd0;
            else if(enahr[1])
                begin
                    if(((hh[7:4]==1)&&(hh[3:0]==1)&&(mm[7:4]==5)&&(mm[3:0]==9)&&(ss[3:0]==9)&&(ss[7:4]==5)))
                        hh[7:4]<=4'b0001;
                    else
                        hh[7:4]<=hh[7:4]+1;
                        
                end
        end
    //for pm
    always@(posedge clk)begin
        if(((hh[7:4]==1)&&(hh[3:0]==1)&&(mm[7:4]==5)&&(mm[3:0]==9)&&(ss[3:0]==9)&&(ss[7:4]==5)))
            pm<=~pm;
    else if(reset)
        pm<=0;
    end  
endmodule

module unittimer(input clk,reset,enable,output reg[3:0]unit);    
    always@(posedge clk)
        begin
            if(reset)
                unit<=4'h0;
            else if(enable)
                begin
                    if(unit==4'b1001)
                        unit<=4'b0000;
                    else
                        unit<=unit+1;
                end
        end
endmodule

module tentimer(input clk,reset,enable1,output reg[3:0]ten);    
    always@(posedge clk)
        begin
            if(reset)
                ten<=4'h0;
            else if(enable1)
                begin
                    if(ten==4'b0101)
                        ten<=4'b0000;
                    else
                        ten<=ten+1;
                end
        end
endmodule       
