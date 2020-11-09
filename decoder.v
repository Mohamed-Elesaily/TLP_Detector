module decoder(

    input [7:0] data_in,
    output [9:0] data_out
);

reg [9:0] data_reg;

always @*
    case (data_in)
      8'h00: data_reg = 1;
      8'h01: data_reg = 2;
      8'h02: data_reg = 4;
      8'h42: data_reg = 8;
      8'h04: data_reg = 16;
      8'h44: data_reg = 32;
      8'h05: data_reg = 64;
      8'h45: data_reg = 128;
      8'h0a: data_reg = 256;
      8'h4a: data_reg = 512;  
      default: data_reg = 0;  
    endcase

assign data_out = data_reg;

endmodule