module hvsync_generator(
    input clk,
	 input sw_p1,
	 input sw_p2,
	 input sw_p3,
    output vga_h_sync,
    output vga_v_sync,
    output reg inDisplayArea,
    output reg [9:0] CounterX,
    output reg [9:0] CounterY
  );
    reg vga_HS, vga_VS;

    wire CounterXmaxed = (CounterX == 800); // 16 + 48 + 96 + 640
    wire CounterYmaxed = (CounterY == 525); // 10 + 2 + 33 + 480

    always @(posedge clk)
    if (CounterXmaxed)
      CounterX <= 0;
    else
      CounterX <= CounterX + 1;

    always @(posedge clk)
    begin
      if (CounterXmaxed)
      begin
        if(CounterYmaxed)
          CounterY <= 0;
        else
          CounterY <= CounterY + 1;
      end
    end

    always @(posedge clk)
    begin
      vga_HS <= (CounterX > (640 + 16) && (CounterX < (640 + 16 + 96)));   // active for 96 clocks
      vga_VS <= (CounterY > (480 + 10) && (CounterY < (480 + 10 + 2)));   // active for 2 clocks
    end

    always @(posedge clk)
    begin
		if(sw_p1 == 0 & sw_p2 == 0 & sw_p3 == 0)			//0
			begin
				 inDisplayArea <= (CounterX < 160) && (CounterY < 240);
			end
			
		else if(sw_p1 == 0 & sw_p2 == 0 & sw_p3 == 1) 	//1
			begin
				 inDisplayArea <= (CounterX > 159) && (CounterX < 320) && (CounterY < 240);
			end
			
		else if(sw_p1 == 0 & sw_p2 == 1 & sw_p3 == 0)	//2
			begin
				 inDisplayArea <= (CounterX > 319) && (CounterX < 480) && (CounterY < 240);
			end
			
		else if(sw_p1 == 0 & sw_p2 == 1 & sw_p3 == 1)	//3
			begin
				 inDisplayArea <= (CounterX > 479) && (CounterX < 640) && (CounterY < 240);
			end	
			
			if(sw_p1 == 1 & sw_p2 == 1 & sw_p3 == 1)		//7
			begin
				 inDisplayArea <= (CounterX < 160) && (CounterY < 480)  && (CounterY > 239);
			end
			
		else if(sw_p1 == 1 & sw_p2 == 1 & sw_p3 == 0)	//6
			begin
				 inDisplayArea <= (CounterX > 159) && (CounterX < 320) && (CounterY < 480)  && (CounterY > 239);
			end
			
		else if(sw_p1 == 1 & sw_p2 == 0 & sw_p3 == 1)	//5
			begin
				 inDisplayArea <= (CounterX > 319) && (CounterX < 480) && (CounterY < 480)  && (CounterY > 239);
			end
			
		else if(sw_p1 == 1 & sw_p2 == 0 & sw_p3 == 0)	//4
			begin
				 inDisplayArea <= (CounterX > 479) && (CounterX < 640) && (CounterY < 480) && (CounterY > 239) ;
			end		
			
    end

    assign vga_h_sync = ~vga_HS;
    assign vga_v_sync = ~vga_VS;

endmodule