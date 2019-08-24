
module clktimer_pwm 
	#( parameter BPS_PARA = 750000 )
	(
	input clk,
	input RSTn,		
	output reg clk_timer	
);	
 
reg	[19:0] cnt = 0;

always @ (posedge clk or negedge RSTn) begin
	if(~RSTn) cnt <= 20'b0;
	else if(cnt >= BPS_PARA-1) cnt <= 20'b0;		
	else cnt <= cnt + 1'b1;
end

always @ (posedge clk or negedge RSTn) begin
	if(~RSTn) clk_timer <= 1'b0;
	else if(cnt == (BPS_PARA>>1)) clk_timer <= 1'b1;
	else clk_timer <= 1'b0;	
end
 
endmodule