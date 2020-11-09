`include"decoder.v"
module decoder_t;

localparam delay = 10;

reg [7:0] data_in;
wire [9:0] data_out;

decoder DUT(
    .data_in(data_in),
    .data_out(data_out)
);

initial begin
    $dumpfile("decoder.vcd");
    $dumpvars(0,decoder_t);    
    data_in = 8'h00;
    #(delay)
    data_in = 8'h01;
    #(delay)
    data_in = 8'h02;
    #(delay)
    data_in = 8'h42;
    #(delay)
    data_in = 8'h04;
    #(delay)
    data_in = 8'h44;
    #(delay)
    data_in = 8'h05;
    #(delay)
    data_in = 8'h45;
    #(delay)
    data_in = 8'h0a;
    #(delay)
    data_in = 8'h4a;
    #(delay)
    data_in = 8'h06;
    #(delay*4);
    $finish;
end



endmodule