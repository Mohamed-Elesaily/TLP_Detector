module up_down_counter #(parameter WIDTH = 8 )
(
    input reset, // active low
    input clk,
    input enable,
    input up,
    output [WIDTH-1:0] count

);
reg one = 1;
reg [WIDTH-1:0]register, next_register;


always @(posedge clk or negedge reset)
    if(~reset)
        register <= 0;
    else 
        register <= next_register;    


// next state logic

always@*
    if(enable & up)
        next_register = register + one;
    else if (enable & ~up) 
        next_register = register - one;
    else
        next_register = register;    
//  outpur logic
assign count = register;


endmodule