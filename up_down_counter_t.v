`include"up_down_counter.v"

module up_down_counter_t;
localparam T = 20;


reg reset,clk,enable,up;
wire [7:0]count;

up_down_counter #(.WIDTH(8)) DUT(

    .reset(reset),
    .clk(clk),
    .enable(enable),
    .up(up),
    .count(count)

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
    $dumpfile("counter.vcd");
    $dumpvars(0,up_down_counter_t);

// test counter up
repeat(10)@(negedge clk);


enable = 1;
up = 1;
repeat(1)@(negedge clk);
enable = 0;
up = 1;
// // test counter down
// enable = 1;
// up = 0;
// repeat(5)@(negedge clk);

// // disable counter
// enable = 0;
// repeat(5)@(negedge clk);


// reset = 0;
 repeat(10)@(negedge clk);


$finish;
end





endmodule