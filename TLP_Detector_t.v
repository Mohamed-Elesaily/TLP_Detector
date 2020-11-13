`include"TLP_Detector.v"
module TLP_Detector_t;
localparam T = 20;


reg reset,clk,datak;
reg[7:0] data_in;
wire [159:0]TLP;
wire [7:0] TLP_count;
wire MRd, MWr, IORd, IOWr, CfgRd0, CfgWr0, CfgRd1, CfgWr1, Cpl, CplD;
integer i;
TLP_Detector DUT(

    .reset(reset),
    .clk(clk),
    .datak(datak),
    .data_in(data_in),
    .TLP_count(TLP_count),
    .Data_out(TLP),
    .MRd(MRd), .MWr(MWr), .IORd(IORd), .IOWr(IOWr), .CfgRd0(CfgRd0), .CfgWr0(CfgWr0), .CfgRd1(CfgRd1), .CfgWr1(CfgWr1), .Cpl(Cpl), .CplD(CplD)

);

always 
    begin
        clk = 0;
        #(T/2);
        clk = 1;
        #(T/2); 
    end

initial 
begin
   reset = 0;
   #(T/2);
   reset = 1;
   #(T/2);
end


initial 
begin
    $dumpfile("dump.vcd");
    $dumpvars(0,TLP_Detector_t);

    data_in = 8'h00;
  @(negedge clk);
  @(negedge clk);
// correct packets
for(i=0;i<20;i = i + 1)
begin
   
   
    if(i == 0)
    begin
      datak = 1;
    data_in = 8'hFB;    
    end
      else if (i == 1) begin
       datak = 1;
   data_in = 8'hFD;   
     end
    else if(i == 3)begin
        data_in = 8'h00;   
    end
     else if (i == 19) begin
       datak = 1;
   data_in = 8'hFD;   
     end
    else begin
        data_in = $random%20;
         datak = 0;

    end

  @(negedge clk);
     
end
 @(negedge clk);
      @(negedge clk);
     
for(i=0;i<20;i = i + 1)
begin
   
   
    if(i == 0)
    begin
      datak = 1;
    data_in = 8'hFB;    
    end
      else if (i == 1) begin
       datak = 1;
   data_in = 8'hFD;   
     end
    else if(i == 3)begin
        data_in = 8'h00;   
    end
     else if (i == 19) begin
       datak = 1;
   data_in = 8'hFD;   
     end
    else begin
        data_in = $random%20;
         datak = 0;

    end

  @(negedge clk);
     
end
 datak = 0;
repeat(5)@(negedge clk);

$finish;
end

endmodule