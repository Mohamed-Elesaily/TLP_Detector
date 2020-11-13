`include"decoder.v"
`include"up_down_counter.v"

module TLP_Detector(
    input reset,
    input clk,
    input [7:0]data_in,
    input  datak,
    output [7:0]TLP_count,

    output [159:0]Data_out,
    output MRd, MWr, IORd, IOWr, CfgRd0, CfgWr0, CfgRd1, CfgWr1, Cpl, CplD
);
// counter width
localparam W = 5;
localparam TLP_W = 8;

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

//  counters signals
reg enable,up,reset_counter,TLP_enable,TLP_up;
wire [W-1:0] count;


///////////////////////////////////////

reg[1:0] state_reg,state_next;
reg[159:0] data_reg;
reg[159:0] data_next;
reg[9:0] op_reg;

reg[159:0] data_out_reg;


always @(posedge clk or negedge reset)
begin
    if(~reset)
        begin
            state_reg <= TLP_start;
            data_reg <= 0;
          
        end
    else 
        begin
            state_reg <= state_next;
            data_reg <= data_next;
         
        end
end            
// next state logic

always @*
begin
    data_next ={data_in[7:0],data_reg[159:8]};
    // TLP_next = TLP_reg;
    op_reg = 0;
    //enable counter 
    enable = 1;
    reset_counter = 1;
    up = 1;
    // TLP counter
    TLP_enable = 0;
    TLP_up = 1;
    // 
 
    data_out_reg = 0;
    state_next = TLP_start;
    case (state_reg)
    TLP_start:
        begin

        if(datak & (data_in == STP))
            begin
                reset_counter = 0;
                //  counter enable
                enable = 0;
                // TLP counter
                state_next = TLP_frame;
                
            end     
        end
             

    TLP_frame: 
    begin

            if(count != 17)
            begin
          
            state_next = TLP_frame;
            end
            else begin
                state_next = TLP_end;
            end     
      
    end
     
    TLP_end:
    begin
        
       if(datak & (data_in == END))
        begin     
        
            state_next = send;
        end
       

    end
    send:
    begin
        TLP_enable = 1;
        op_reg = dec_out;
        data_out_reg = data_reg;
        state_next = TLP_start;
    end
    endcase
end

assign dec_in = data_reg[31:24];
// // output logic

assign Data_out =  data_out_reg;
assign {CplD,Cpl,CfgWr1,CfgRd1,CfgWr0,CfgRd0,IOWr,IORd,MWr,MRd} = op_reg;

/////////////////////////////////////////////////////////////////////////////

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

// TLP counter
up_down_counter #(.WIDTH(TLP_W))TLP_counter(
    .reset(reset),
    .clk(clk),
    .enable(TLP_enable),
    .up(TLP_up),
    .count(TLP_count)
    );




endmodule