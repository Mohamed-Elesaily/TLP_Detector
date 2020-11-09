`include"TLP_Detector.v"
module TLP_Detector_t;
localparam T = 20;


reg reset,clk;
reg[7:0] data_in;
wire [159:0]TLP;
wire [3:0] TLP_count;
wire MRd, MWr, IORd, IOWr, CfgRd0, CfgWr0, CfgRd1, CfgWr1, Cpl, CplD;
integer i;
TLP_Detector DUT(

    .reset(reset),
    .clk(clk),
    .data_in(data_in),
    .TLP_count(TLP_count),
    .TLP(TLP),
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
    $dumpvars(1,TLP_Detector_t);

// correct packets
for(i=0;i<20;i = i + 1)
begin
    if(i == 0)
    begin
    data_in = 8'hFB;    
    end
    else if(i == 3)begin
        data_in = 8'h00;   
    end
     else if (i == 19) begin
   data_in = 8'hFD;   
     end
    else begin
        data_in = $random%20;
    end
  @(negedge clk);
end
repeat(5)@(negedge clk);
for(i=0;i<20;i = i + 1)
begin
    if(i == 0)
    begin
    data_in = 8'hFB;    
    end
    else if(i == 3)begin
        data_in = 8'h45;   
    end
     else if (i == 19) begin
   data_in = 8'hFD;   
     end
    else begin
        data_in = $random%20;
    end
  @(negedge clk);
end
repeat(5)@(negedge clk);
for(i=0;i<20;i = i + 1)
begin
    if(i == 0)
    begin
    data_in = 8'hFB;    
    end
    else if(i == 3)begin
        data_in = 8'h4a;   
    end
     else if (i == 19) begin
   data_in = 8'hFD;   
     end
    else begin
        data_in = $random%20;
    end
  @(negedge clk);
end
repeat(5)@(negedge clk);
for(i=0;i<20;i = i + 1)
begin
    if(i == 0)
    begin
    data_in = 8'hFB;    
    end
    else if(i == 3)begin
        data_in = 8'h00;   
    end
     else if (i == 19) begin
   data_in = 8'hFD;   
     end
    else begin
        data_in = $random%20;
    end
  @(negedge clk);
end
repeat(5)@(negedge clk);
for(i=0;i<20;i = i + 1)
begin
    if(i == 0)
    begin
    data_in = 8'hFB;    
    end
    else if(i == 3)begin
        data_in = 8'h00;   
    end
     else if (i == 19) begin
   data_in = 8'hFD;   
     end
    else begin
        data_in = 8'hFD;
    end
  @(negedge clk);
end

repeat(5)@(negedge clk);
for(i=0;i<20;i = i + 1)
begin
    if(i == 0)
    begin
    data_in = 8'hFB;    
    end
    else if(i == 3)begin
        data_in = 8'h00;   
    end
     else if (i == 19) begin
   data_in = 8'hFD;   
     end
    else begin
        data_in = 8'hFB;
    end
  @(negedge clk);
end


repeat(10)@(negedge clk);
// length packet 24
for(i=0;i<24;i = i + 1)
begin
    if(i == 0)
    begin
    data_in = 8'hFB;    
    end
    else if(i == 3)begin
        data_in = 8'h00;   
    end
     else if (i == 23) begin
   data_in = 8'hFD;   
     end
    else begin
        data_in = $random%20;
    end
  @(negedge clk);
end

repeat(10)@(negedge clk);
// correct packet
for(i=0;i<20;i = i + 1)
begin
    if(i == 0)
    begin
    data_in = 8'hFB;    
    end
    else if(i == 3)begin
        data_in = 8'h00;   
    end
     else if (i == 19) begin
   data_in = 8'hFD;   
     end
    else begin
        data_in = $random%20;
    end
  @(negedge clk);
end

repeat(5)@(negedge clk);
// correct packet
for(i=0;i<20;i = i + 1)
begin
    if(i == 0)
    begin
    data_in = 8'hFB;    
    end
    else if(i == 3)begin
        data_in = 8'h00;   
    end
     else if (i == 19) begin
   data_in = 8'hFD;   
     end
    else begin
        data_in = 8'hFB;
    end
  @(negedge clk);
end
repeat(5)@(negedge clk);
// length packet 16 
for(i=0;i<16;i = i + 1)
begin
    if(i == 0)
    begin
    data_in = 8'hFB;    
    end
    else if(i == 3)begin
        data_in = 8'h00;   
    end
     else if (i == 15) begin
   data_in = 8'hFD;   
     end
    else begin
        data_in = $random%20;
    end
  @(negedge clk);
end
repeat(10)@(negedge clk);
// END not correct 
for(i=0;i<20;i = i + 1)
begin
    if(i == 0)
    begin
    data_in = 8'hFB;    
    end
    else if(i == 3)begin
        data_in = 8'h00;   
    end
     else if (i == 19) begin
   data_in = 8'hFA;   
     end
    else begin
        data_in = $random%20;
    end
  @(negedge clk);
end
repeat(10)@(negedge clk);
// STP not correct 
for(i=0;i<20;i = i + 1)
begin
    if(i == 0)
    begin
    data_in = 8'hFA;    
    end
    else if(i == 3)begin
        data_in = 8'h00;   
    end
     else if (i == 19) begin
   data_in = 8'hFA;   
     end
    else begin
        data_in = $random%20;
    end
  @(negedge clk);
end
repeat(10)@(negedge clk);
// random
for(i=0;i<20;i = i + 1)
begin
  data_in = $random/255;
  @(negedge clk);
end
$finish;
end

endmodule