module L2RegSplice(
    input   wire            clk,
    input   wire            rstn,
    input   wire    [7:0]   din,
    input   wire    [3:0]   Sel,
    input   wire            We,
	input	wire			Zero,
    output  wire    [95:0]  dout
);

reg [7:0] dout_reg0;
reg [7:0] dout_reg1;
reg [7:0] dout_reg2;
reg [7:0] dout_reg3;
reg [7:0] dout_reg4;
reg [7:0] dout_reg5;
reg [7:0] dout_reg6;
reg [7:0] dout_reg7;
reg [7:0] dout_reg8;
reg [7:0] dout_reg9;
reg [7:0] dout_rega;
reg [7:0] dout_regb;

always@(posedge clk or negedge rstn) begin
	if(~rstn)
		dout_reg0 <= 8'b0;
	else if(We) begin
		if(Sel == 4'h0)
			dout_reg0 <= din;
	end
end

always@(posedge clk or negedge rstn) begin
	if(~rstn)
		dout_reg1 <= 8'b0;
	else if(We) begin
		if(Sel == 4'h1)
			dout_reg1 <= din;
	end
end

always@(posedge clk or negedge rstn) begin
	if(~rstn)
		dout_reg2 <= 8'b0;
	else if(We) begin
		if(Sel == 4'h2)
			dout_reg2 <= din;
	end
end

always@(posedge clk or negedge rstn) begin
	if(~rstn)
		dout_reg3 <= 8'b0;
	else if(We) begin
		if(Sel == 4'h3)
			dout_reg3 <= din;
	end
end

always@(posedge clk or negedge rstn) begin
	if(~rstn)
		dout_reg4 <= 8'b0;
	else if(We) begin
		if(Sel == 4'h4)
			dout_reg4 <= din;
	end
end

always@(posedge clk or negedge rstn) begin
	if(~rstn)
		dout_reg5 <= 8'b0;
	else if(We) begin
		if(Sel == 4'h5)
			dout_reg5 <= din;
	end
end

always@(posedge clk or negedge rstn) begin
	if(~rstn)
		dout_reg6 <= 8'b0;
	else if(We) begin
		if(Sel == 4'h6)
			dout_reg6 <= din;
	end
end

always@(posedge clk or negedge rstn) begin
	if(~rstn)
		dout_reg7 <= 8'b0;
	else if(We) begin
		if(Sel == 4'h7)
			dout_reg7 <= din;
	end
end

always@(posedge clk or negedge rstn) begin
	if(~rstn)
		dout_reg8 <= 8'b0;
	else if(We) begin
		if(Sel == 4'h8)
			dout_reg8 <= din;
	end
end

always@(posedge clk or negedge rstn) begin
	if(~rstn)
		dout_reg9 <= 8'b0;
	else if(We) begin
		if(Sel == 4'h9)
			dout_reg9 <= din;
	end
end

always@(posedge clk or negedge rstn) begin
	if(~rstn)
		dout_rega <= 8'b0;
	else if(We) begin
		if(Sel == 4'ha)
			dout_rega <= din;
	end
end

always@(posedge clk or negedge rstn) begin
	if(~rstn)
		dout_regb <= 8'b0;
	else if(We) begin
		if(Sel == 4'hb)
			dout_regb <= din;
	end
end

assign dout = Zero	?	96'b0:	{dout_regb,   dout_rega,  dout_reg9,   dout_reg8,  dout_reg7,  dout_reg6,  
               					 dout_reg5,  dout_reg4,   dout_reg3,   dout_reg2,  dout_reg1,  dout_reg0};

endmodule