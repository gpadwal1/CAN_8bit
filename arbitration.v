module arbitration(
	input [7:0] my_id,
	input [7:0] bus_id,
	output reg win
);
always @(*)begin
	if(my_id < bus_id)
		win = 1;
	else
		win = 0;
	end
endmodule

