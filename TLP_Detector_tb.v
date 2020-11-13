`include"TLP_Detector.v"
module TLP_Detector_tb();

//output signals
wire MRd, MWr, IORd, IOWr, CfgRd0, CfgWr0, CfgRd1, CfgWr1, Cpl, CplD;
wire [159:0] Data_out;
wire [7:0] TLP_count;
integer test_case;
//input signals
reg reset, clk, data_k;
reg [7:0] data_in;
//internal signals
reg [159:0] TLP_Bad_STP = 160'hFD_ffa5a5ff_0b0a090807060504030201_0a_0000_FD; //corrupted STP TLP
reg [159:0] TLP_B = 160'hFD_ffa5a5ff_0b0a090807060504030201_0a_0000_FB; //Cpl TLP
reg [159:0] TLP_C = 160'hFD_ffa5a5ff_0b0a090807060504030201_02_0000_FB; //IORd TLP
reg [159:0] TLP_Bad_END = 160'hFB_ffa5a5ff_0b0a090807060504030201_44_0000_FB; //Corrupted END TLP

reg [159:0] TLP_Mrd     = 160'hFD_ffa5a5ff_0b0a090807060504030201_00_0000_FB; 
reg [159:0] TLP_Mwr     = 160'hFD_ffa5a5ff_0b0a090807060504030201_01_0000_FB; 
reg [159:0] TLP_IORd    = 160'hFD_ffa5a5ff_0b0a090807060504030201_02_0000_FB;
reg [159:0] TLP_IOWr    = 160'hFD_ffa5a5ff_0b0a090807060504030201_42_0000_FB;
reg [159:0] TLP_CfgRd0  = 160'hFD_ffa5a5ff_0b0a090807060504030201_04_0000_FB;
reg [159:0] TLP_CfgWr0  = 160'hFD_ffa5a5ff_0b0a090807060504030201_44_0000_FB;
reg [159:0] TLP_CfgRd1  = 160'hFD_ffa5a5ff_0b0a090807060504030201_05_0000_FB;
reg [159:0] TLP_CfgWr1  = 160'hFD_ffa5a5ff_0b0a090807060504030201_45_0000_FB;
reg [159:0] TLP_Cpl     = 160'hFD_ffa5a5ff_0b0a090807060504030201_0a_0000_FB;
reg [159:0] TLP_CplD    = 160'hFD_ffa5a5ff_0b0a090807060504030201_4a_0000_FB;
reg [159:0] TLP_NA      = 160'hFD_ffa5a5ff_0b0a090807060504030201_ab_0000_FB;
reg [151:0] TLP_Inc_Legth0 = 152'hFD_ffa5a5ff_0a090807060504030201_ab_0000_FB;
reg [167:0] TLP_Inc_Legth1 = 168'hFD_ffa5a5ff_0c0b0a090807060504030201_ab_0000_FB;

reg [159:0] TLP_E = 160'hFD_ffa5a5ff_0b0a090807060504030201_02_0000_FB;
integer  i,j;
 
//generate clock
always begin
#10 clk = ~clk;
end
/*
+----------------+---------------------------------------------------+-----------------------------------------------------+
| Test Case #    |                  Test Description                 |                   Expected Output                   |
+----------------+---------------------------------------------------+-----------------------------------------------------+
|                |                                                   | Counter = 1                                         |
| Test case 1    | One TLP is sent                                   | TLP detected correctly                              |
|                |                                                   | TLP Type is correct                                 |
|                |                                                   | All outputs are in sync                             |
+----------------+---------------------------------------------------+-----------------------------------------------------+
|                |                                                   | all types should be detected                        |
| Test case 2    | Train all decoder outputs                         | Last TLP has no defined type                        |
|                |                                                   | you should define what to do with it                |
+----------------+---------------------------------------------------+-----------------------------------------------------+
|                |                                                   | Two TLPs should be detected and counter should be 2 |
| Test case 3    | Send two TLPs with cycle in between               |                                                     |
+----------------+---------------------------------------------------+-----------------------------------------------------+
|                |                                                   | Two TLPs should be detected as well                 |
| Test case 4    | Send two back to back TLPs                        |                                                     |
+----------------+---------------------------------------------------+-----------------------------------------------------+
|                |                                                   | No TLP should be detected                           |
| Test case 5    | Send corrupted TLP wrong STP data or datak)       |                                                     |
+----------------+---------------------------------------------------+-----------------------------------------------------+
|                |                                                   | No TLP should be detected                           |
| Test case 6    | Send corrupted TLP   (wrong END data or datak)    |                                                     |
+----------------+---------------------------------------------------+-----------------------------------------------------+
|                |                                                   | NO TLP should be detected                           |
| Test case 7    | Two TLPs are sent with incorrect lenghtes         |                                                     |
+----------------+---------------------------------------------------+-----------------------------------------------------+
|                |    making a 1 ns shift between clk and data       | 3 TLPs should be detected                           |
| Test case 8    |                                                   |                                                     |
+----------------+---------------------------------------------------+-----------------------------------------------------+

What if datak is set while normal data is sent? this is your call, handle it the way you see.
*/



//Test case 1
initial begin

$dumpfile("dump.vcd");
$dumpvars(0,TLP_Detector_tb);

clk = 0;
reset = 0;
test_case = 1;
data_in <= 8'h00;
data_k <= 1'h0;
#60
reset = 1;
#20;
	for(i = 0; i < 20; i=i+1) begin
        if(i == 0 || i == 19)
            data_k <= 1;
         else
            data_k <= 0;
            data_in <= TLP_B[8*i +: 8]; // first TLP
            #20;
     end    
//Test case 2
test_case = test_case +1;
#100;
clk = 0;
reset = 0;
data_in <= 8'h00;
data_k <= 1'h0;
#60
reset = 1;
#20;
	for(i = 0; i < 11; i=i+1) begin
           for(j =0; j <20 ; j=j+1) begin
                if(j == 0 || j == 19)
                    data_k <= 1;
                 else
                    data_k <= 0;
                 if (i == 0)   
                    data_in <= TLP_Mrd[8*j +: 8]; // first TLP
                else if (i == 1) begin
                    data_in <= TLP_Mwr[8*j +: 8]; // B2B TLP
                      end  
                else if (i == 2)
                    data_in <= TLP_IORd[8*j +: 8]; // TLP
                else if (i == 3)
                    data_in <= TLP_IOWr[8*j +: 8]; // TLP
                else if (i == 4)
                    data_in <= TLP_CfgRd0[8*j +: 8]; // TLP
                else if (i == 5)
                    data_in <= TLP_CfgWr0[8*j +: 8]; // TLP
                else if (i == 6)
                    data_in <= TLP_CfgRd1[8*j +: 8]; // TLP
                else if (i == 7)
                    data_in <= TLP_CfgWr1[8*j +: 8]; // TLP
                else if (i == 8)
                    data_in <= TLP_Cpl[8*j +: 8]; // TLP
                else if (i == 9)
                    data_in <= TLP_CplD[8*j +: 8]; // TLP
                else if (i == 10)
                    data_in <= TLP_NA[8*j +: 8]; // TLP
                 #20;
           end   
		data_k <= 0;
		data_in <= 8'h00;
		#40; 
	end
//Test case 3
test_case = test_case +1;
#100;
clk = 0;
reset = 0;
data_in <= 8'h00;
data_k <= 1'h0;
#60
reset = 1;
#20;
	for(i = 0; i < 20; i=i+1) begin
                if(i == 0 || i == 19)
                    data_k <= 1;
                 else
                    data_k <= 0;
                    data_in <= TLP_IORd[8*i +: 8]; // first TLP
                    #20;
     end
        data_k <= 0;
        #20;
    for(i = 0; i < 20; i=i+1) begin
                if(i == 0 || i == 19)
                    data_k <= 1;
                 else
                    data_k <= 0;
                    data_in <= TLP_IOWr[8*i +: 8]; // first TLP
                    #20;
     end   
//Test case 4
test_case = test_case +1;
#100;
clk = 0;
reset = 0;
data_in <= 8'h00;
data_k <= 1'h0;
#60
reset = 1;
#20;
	for(i = 0; i < 2; i=i+1) begin
           for(j =0; j <20 ; j=j+1) begin
                if(j == 0 || j == 19)
                    data_k <= 1;
                 else
                    data_k <= 0;
                 if (i == 0)   
                    data_in <= TLP_Mrd[8*j +: 8]; // first TLP
                 else if (i == 1) 
                    data_in <= TLP_Mwr[8*j +: 8]; // B2B TLP 
                 #20; 
	end
end
//Test case 5
test_case = test_case +1;
#100;
clk = 0;
reset = 0;
data_in <= 8'h00;
data_k <= 1'h0;
#60
reset = 1;
#20;
	for(i = 0; i < 20; i=i+1) begin
                if(i == 0 || i == 19)
                    data_k <= 1;
                 else
                    data_k <= 0;
                    data_in <= TLP_Bad_STP[8*i +: 8]; // first TLP
                    #20;
     end
        data_k <= 0;
        #20;
    for(i = 0; i < 20; i=i+1) begin
                if(i == 19)
                    data_k <= 1;
                 else
                    data_k <= 0;
                    data_in <= TLP_Cpl[8*i +: 8]; // first TLP
                    #20;
     end   
//Test case 6
test_case <= test_case +1;
#100;
clk = 0;
reset = 0;
data_in <= 8'h00;
data_k <= 1'h0;
#60
reset = 1;
#20;
	for(i = 0; i < 20; i=i+1) begin
                if(i == 0 || i == 19)
                    data_k <= 1;
                 else
                    data_k <= 0;
                    data_in <= TLP_Bad_END[8*i +: 8]; // first TLP
                    #20;
     end
        data_k <= 0;
        #20;
    for(i = 0; i < 20; i=i+1) begin
                if(i == 1)
                    data_k <= 1;
                 else
                    data_k <= 0;
                    data_in <= TLP_Cpl[8*i +: 8]; // first TLP
                    #20;
     end
//Test case 7
test_case = test_case +1;
#100;
clk = 0;
reset = 0;
data_in <= 8'h00;
data_k <= 1'h0;
#60
reset = 1;
#20;
	for(i = 0; i < 19; i=i+1) begin
                if(i == 0 || i == 18)
                    data_k <= 1;
                 else
                    data_k <= 0;
                    data_in <= TLP_Inc_Legth0[8*i +: 8]; // first TLP
                    #20;
     end  
data_k <= 0;
data_in <= 8'h00;
#40;
	for(i = 0; i < 21; i=i+1) begin
                if(i == 0 || i == 20)
                    data_k <= 1;
                 else
                    data_k <= 0;
                    data_in <= TLP_Inc_Legth1[8*i +: 8]; // first TLP
                    #20;
     end    
//Test case 8
test_case <= test_case +1;
#100;
clk = 0;
reset = 0;
data_in <= 8'h00;
data_k <= 1'h0;
#60
reset = 1;
#21;
	for(i = 0; i < 3; i=i+1) begin
           for(j =0; j <20 ; j=j+1) begin
                if(j == 0 || j == 19)
                    data_k <= 1;
                 else
                    data_k <= 0;
                 if (i == 0)   
                    data_in <= TLP_CfgRd0[8*j +: 8]; // first TLP
                 else if (i == 1) begin
                    data_in <= TLP_CplD[8*j +: 8]; // B2B TLP
                      end  
                 else if (i == 2)
                    data_in <= TLP_Cpl[8*j +: 8]; // TLP
                 #20;
           end    
	end
   #100 $finish;
end



//dut instance
TLP_Detector TLP_Detector_i(
.reset		(reset),
.clk		(clk),
.data_in	(data_in),
.datak		(data_k),
.TLP_count	(TLP_count),
.Data_out	(Data_out),
.MRd		(MRd), 
.MWr		(MWr), 
.IORd		(IORd), 
.IOWr		(IOWr), 
.CfgRd0		(CfgRd0), 
.CfgWr0		(CfgWr0), 
.CfgRd1		(CfgRd1), 
.CfgWr1		(CfgWr1), 
.Cpl		(Cpl), 
.CplD		(CplD)
);

endmodule
