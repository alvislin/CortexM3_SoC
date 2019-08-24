module L1RegSplice(
    input   wire            clk,
    input   wire            rstn,
    input   wire    [7:0]   din,
    input   wire    [4:0]   Sel,
    input   wire            We,
    output  wire    [191:0] dout
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
reg [7:0] dout_reg10;
reg [7:0] dout_reg11;
reg [7:0] dout_reg12;
reg [7:0] dout_reg13;
reg [7:0] dout_reg14;
reg [7:0] dout_reg15;
reg [7:0] dout_reg16;
reg [7:0] dout_reg17;
reg [7:0] dout_reg18;
reg [7:0] dout_reg19;
reg [7:0] dout_reg20;
reg [7:0] dout_reg21;
reg [7:0] dout_reg22;
reg [7:0] dout_reg23;

always@(posedge clk or negedge rstn) begin
	if(~rstn)
		dout_reg0 <= 8'b0;
	else if(We) begin
		if(Sel == 5'd0)
			dout_reg0 <= din;
	end
end

always@(posedge clk or negedge rstn) begin
	if(~rstn)
		dout_reg1 <= 8'b0;
	else if(We) begin
		if(Sel == 5'd1)
			dout_reg1 <= din;
	end
end

always@(posedge clk or negedge rstn) begin
	if(~rstn)
		dout_reg2 <= 8'b0;
	else if(We) begin
		if(Sel == 5'd2)
			dout_reg2 <= din;
	end
end

always@(posedge clk or negedge rstn) begin
	if(~rstn)
		dout_reg3 <= 8'b0;
	else if(We) begin
		if(Sel == 5'd3)
			dout_reg3 <= din;
	end
end

always@(posedge clk or negedge rstn) begin
	if(~rstn)
		dout_reg4 <= 8'b0;
	else if(We) begin
		if(Sel == 5'd4)
			dout_reg4 <= din;
	end
end

always@(posedge clk or negedge rstn) begin
	if(~rstn)
		dout_reg5 <= 8'b0;
	else if(We) begin
		if(Sel == 5'd5)
			dout_reg5 <= din;
	end
end

always@(posedge clk or negedge rstn) begin
	if(~rstn)
		dout_reg6 <= 8'b0;
	else if(We) begin
		if(Sel == 5'd6)
			dout_reg6 <= din;
	end
end

always@(posedge clk or negedge rstn) begin
	if(~rstn)
		dout_reg7 <= 8'b0;
	else if(We) begin
		if(Sel == 5'd7)
			dout_reg7 <= din;
	end
end

always@(posedge clk or negedge rstn) begin
	if(~rstn)
		dout_reg8 <= 8'b0;
	else if(We) begin
		if(Sel == 5'd8)
			dout_reg8 <= din;
	end
end

always@(posedge clk or negedge rstn) begin
	if(~rstn)
		dout_reg9 <= 8'b0;
	else if(We) begin
		if(Sel == 5'd9)
			dout_reg9 <= din;
	end
end

always@(posedge clk or negedge rstn) begin
	if(~rstn)
		dout_reg10 <= 8'b0;
	else if(We) begin
		if(Sel == 5'd10)
			dout_reg10 <= din;
	end
end

always@(posedge clk or negedge rstn) begin
	if(~rstn)
		dout_reg11 <= 8'b0;
	else if(We) begin
		if(Sel == 5'd11)
			dout_reg11 <= din;
	end
end

always@(posedge clk or negedge rstn) begin
	if(~rstn)
		dout_reg12 <= 8'b0;
	else if(We) begin
		if(Sel == 5'd12)
			dout_reg12 <= din;
	end
end

always@(posedge clk or negedge rstn) begin
	if(~rstn)
		dout_reg13 <= 8'b0;
	else if(We) begin
		if(Sel == 5'd13)
			dout_reg13 <= din;
	end
end

always@(posedge clk or negedge rstn) begin
	if(~rstn)
		dout_reg14 <= 8'b0;
	else if(We) begin
		if(Sel == 5'd14)
			dout_reg14 <= din;
	end
end

always@(posedge clk or negedge rstn) begin
	if(~rstn)
		dout_reg15 <= 8'b0;
	else if(We) begin
		if(Sel == 5'd15)
			dout_reg15 <= din;
	end
end

always@(posedge clk or negedge rstn) begin
	if(~rstn)
		dout_reg16 <= 8'b0;
	else if(We) begin
		if(Sel == 5'd16)
			dout_reg16 <= din;
	end
end

always@(posedge clk or negedge rstn) begin
	if(~rstn)
		dout_reg17 <= 8'b0;
	else if(We) begin
		if(Sel == 5'd17)
			dout_reg17 <= din;
	end
end

always@(posedge clk or negedge rstn) begin
	if(~rstn)
		dout_reg18 <= 8'b0;
	else if(We) begin
		if(Sel == 5'd18)
			dout_reg18 <= din;
	end
end

always@(posedge clk or negedge rstn) begin
	if(~rstn)
		dout_reg19 <= 8'b0;
	else if(We) begin
		if(Sel == 5'd19)
			dout_reg19 <= din;
	end
end

always@(posedge clk or negedge rstn) begin
	if(~rstn)
		dout_reg20 <= 8'b0;
	else if(We) begin
		if(Sel == 5'd20)
			dout_reg20 <= din;
	end
end

always@(posedge clk or negedge rstn) begin
	if(~rstn)
		dout_reg21 <= 8'b0;
	else if(We) begin
		if(Sel == 5'd21)
			dout_reg21 <= din;
	end
end

always@(posedge clk or negedge rstn) begin
	if(~rstn)
		dout_reg22 <= 8'b0;
	else if(We) begin
		if(Sel == 5'd22)
			dout_reg22 <= din;
	end
end

always@(posedge clk or negedge rstn) begin
	if(~rstn)
		dout_reg23 <= 8'b0;
	else if(We) begin
		if(Sel == 5'd23)
			dout_reg23 <= din;
	end
end


assign dout = {dout_reg23,  dout_reg22, dout_reg21,  dout_reg20, dout_reg19, dout_reg18,
			   dout_reg17,  dout_reg16, dout_reg15,  dout_reg14, dout_reg13, dout_reg12,
			   dout_reg11,  dout_reg10, dout_reg9,   dout_reg8,  dout_reg7,  dout_reg6,  
			   dout_reg5,  dout_reg4,   dout_reg3,   dout_reg2,  dout_reg1,  dout_reg0};

endmodule