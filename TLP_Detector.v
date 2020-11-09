`include"decoder.v"
`include"up_down_counter.v"

module TLP_Detector(
    input reset,
    input clk,
    input [7:0]data_in,
    output [3:0]TLP_count,
    output [159:0]TLP,
    output MRd, MWr, IORd, IOWr, CfgRd0, CfgWr0, CfgRd1, CfgWr1, Cpl, CplD
);
// counter width
localparam W = 5;

// states 
localparam  TLP_start = 2'b00,
            TLP_frame =2'b01,
            TLP_end = 2'b10,
            send = 2'b11;

localparam  STP  =  8'hFB,
            END =  8'hFD;

// decoder signals
wire [9:0]dec_out;
wire [7:0]dec_in;

//  counter signals
reg enable,up,reset_counter;
wire [W-1:0] count;

// decoder module
decoder dec(.data_in(dec_in),.data_out(dec_out));

// counter module
up_down_counter #(.WIDTH(W))counter(
    .reset(reset_counter),
    .clk(clk),
    .enable(enable),
    .up(up),
    .count(count)
    );

//////////////////////////////////////////

reg[1:0] state_reg,state_next;
reg[159:0] data_reg;
reg[159:0] data_next;
reg[3:0] TLP_reg,TLP_next;

reg datak;
always @(posedge clk or negedge reset)
begin
    if(~reset)
        begin
            state_reg <= TLP_start;
            data_reg <= 0;
            TLP_reg <= 0;
        end
    else 
        begin
            state_reg <= state_next;
            data_reg <= data_next;
            TLP_reg<= TLP_next;
        end
end            
// next state logic

always @*
begin
    data_next ={data_in[7:0],data_reg[159:8]};
    TLP_next = TLP_reg;
    
    //enable counter 
    reset_counter = 1;
    enable = 1;
    up = 1;
    // 
    datak = 0;
    state_next = state_reg;
    case (state_reg)
    TLP_start:
        begin
        
        if(data_reg[159:152] == STP)
            begin
            // count = 0 
            reset_counter = 0;
       
            datak = 1;
            state_next = TLP_frame;
            
            end     
        end
             

    TLP_frame: 
    begin
       // enable counter 
       
        if(count != 18)
        begin
      

        enable = 1;
        up = 1;
  
        end
        else
        begin
            data_next = data_reg;    
            state_next = TLP_end;
        end    
    end
     
    TLP_end:
    begin
        data_next = data_reg;   
        if(data_reg[159:152] == END)
        begin     
         datak = 1;
         TLP_next = TLP_reg + 1;
         state_next = send;
        end
        else begin
            state_next = TLP_start;
        end
    end
    send:
        begin   
            state_next = TLP_start;
        end
    endcase
end

assign dec_in = data_reg[31:24];
// output logic
assign TLP_count = TLP_reg;
assign TLP = (state_reg == send)? data_reg:0;
assign {CplD,Cpl,CfgWr1,CfgRd1,CfgWr0,CfgRd0,IOWr,IORd,MWr,MRd} = (state_reg == send)?dec_out:0;

endmodule