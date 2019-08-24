module L2ConvAdderTree (
	input	wire			 clk,
	input	wire			 rstn,

	input	wire			 vbit_i,

    input   wire    [18:0]   Conv0_Out,
    input   wire    [18:0]   Conv1_Out,
    input   wire    [18:0]   Conv2_Out,
    input   wire    [18:0]   Conv3_Out,
    input   wire    [18:0]   Conv4_Out,
    input   wire    [18:0]   Conv5_Out,
    input   wire    [18:0]   Conv6_Out,
    input   wire    [18:0]   Conv7_Out,
    output  wire    [21:0]   Conv_Out,

	output	wire			 vbit_o
);

wire    [19:0]   AddrOut0;
wire    [19:0]   AddrOut1;
wire    [19:0]   AddrOut2;
wire    [19:0]   AddrOut3;

FixPointAdder #(
	.Width		(19)
)   Adder0(
	.dina   	(Conv0_Out),
	.dinb   	(Conv1_Out),
	.dout   	(AddrOut0)
);

FixPointAdder #(
	.Width		(19)
)   Adder1(
	.dina   	(Conv2_Out),
	.dinb   	(Conv3_Out),
	.dout   	(AddrOut1)
);

FixPointAdder #(
	.Width		(19)
)   Adder2(
	.dina   	(Conv4_Out),
	.dinb   	(Conv5_Out),
	.dout   	(AddrOut2)
);

FixPointAdder #(
	.Width		(19)
)   Adder3(
	.dina   	(Conv6_Out),
	.dinb   	(Conv7_Out),
	.dout   	(AddrOut3)
);


wire    [20:0]   AddrOut4;
wire    [20:0]   AddrOut5;

FixPointAdder #(
	.Width		(20)
)   Adder4(
	.dina   	(AddrOut0),
	.dinb   	(AddrOut1),
	.dout   	(AddrOut4)
);

FixPointAdder #(
	.Width		(20)
)   Adder5(
	.dina   	(AddrOut2),
	.dinb   	(AddrOut3),
	.dout   	(AddrOut5)
);

wire	[21:0]	Conv_result;

FixPointAdder #(
	.Width		(21)
)   Adder6(
	.dina   	(AddrOut4),
	.dinb   	(AddrOut5),
	.dout   	(Conv_result)
);

RegFile	#(
	.Width		(22)
)	P0(
	.clk		(clk),
	.rstn		(rstn),
	.vbit_i		(vbit_i),
	.data_i		(Conv_result),
	.data_o		(Conv_Out),
	.vbit_o		(vbit_o)
);

endmodule