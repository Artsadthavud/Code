module testVGA(
    input clk_50,
	 input sw_r,
	 input sw_g,
	 input sw_b,
	 input sw_p1,
	 input sw_p2,
	 input sw_p3,
	 output reg clk,

    output reg [2:0] pixel,
    output hsync_out,
    output vsync_out
);
    wire inDisplayArea;
  //  wire [9:0] CounterX;

	 always @(posedge clk_50)
		begin
			clk <= ~clk;	
		end
	 

    hvsync_generator hvsync(
      .clk(clk),
		.sw_p1(~sw_p1),
		.sw_p2(~sw_p2),
		.sw_p3(~sw_p3),
      .vga_h_sync(hsync_out),
      .vga_v_sync(vsync_out),
      //.CounterX(CounterX),
      //.CounterY(CounterY),
      .inDisplayArea(inDisplayArea)
    );

    always @(posedge clk)
    begin
      if (inDisplayArea)
			begin
				pixel[0] <= ~sw_g;
				pixel[1] <= ~sw_b;
				pixel[2] <= ~sw_r;	
			end
			
      else // if it's not to display, go dark
        pixel <= 3'b000;
    end

endmodule