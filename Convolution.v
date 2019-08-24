/***********************************************/
/******  3 * 3 convolution kernel   ************/
/*******  Data Form : Fixed Point   ************/
/***********************************************/


module Convolution (
    input   wire            clk,
    input   wire            rstn,

    input   wire            vbit_i,

    // INPUT WEIGHT
    input   wire    [23:0]   weight_line0,
    input   wire    [23:0]   weight_line1,
    input   wire    [23:0]   weight_line2,

    // INPUT DATA
    input   wire    [23:0]  data_line0,
    input   wire    [23:0]  data_line1,
    input   wire    [23:0]  data_line2,

    // OUTPUT
    output  wire    [18:0]  result,
    output  wire            vbit_o
);

//--------------------------------------------
//  PIPLINE 0
//--------------------------------------------

wire    [14:0]   MultiOut0;
wire    [14:0]   MultiOut1;
wire    [14:0]   MultiOut2;
wire    [14:0]   MultiOut3;
wire    [14:0]   MultiOut4;
wire    [14:0]   MultiOut5;
wire    [14:0]   MultiOut6;
wire    [14:0]   MultiOut7;
wire    [14:0]   MultiOut8;

FixPointMultiplier Multiplier0(
    .data   (data_line0[7:0]),
    .weight (weight_line0[7:0]),
    .out    (MultiOut0)
);

FixPointMultiplier Multiplier1(
    .data   (data_line0[15:8]),
    .weight (weight_line0[15:8]),
    .out    (MultiOut1)
);

FixPointMultiplier Multiplier2(
    .data   (data_line0[23:16]),
    .weight (weight_line0[23:16]),
    .out    (MultiOut2)
);

FixPointMultiplier Multiplier3(
    .data   (data_line1[7:0]),
    .weight (weight_line1[7:0]),
    .out    (MultiOut3)
);

FixPointMultiplier Multiplier4(
    .data   (data_line1[15:8]),
    .weight (weight_line1[15:8]),
    .out    (MultiOut4)
);

FixPointMultiplier Multiplier5(
    .data   (data_line1[23:16]),
    .weight (weight_line1[23:16]),
    .out    (MultiOut5)
);

FixPointMultiplier Multiplier6(
    .data   (data_line2[7:0]),
    .weight (weight_line2[7:0]),
    .out    (MultiOut6)
);

FixPointMultiplier Multiplier7(
    .data   (data_line2[15:8]),
    .weight (weight_line2[15:8]),
    .out    (MultiOut7)
);

FixPointMultiplier Multiplier8(
    .data   (data_line2[23:16]),
    .weight (weight_line2[23:16]),
    .out    (MultiOut8)
);

wire             vbit_p0;
wire    [14:0]   MultiOut0_pip;
wire    [14:0]   MultiOut1_pip;
wire    [14:0]   MultiOut2_pip;
wire    [14:0]   MultiOut3_pip;
wire    [14:0]   MultiOut4_pip;
wire    [14:0]   MultiOut5_pip;
wire    [14:0]   MultiOut6_pip;
wire    [14:0]   MultiOut7_pip;
wire    [14:0]   MultiOut8_pip;

RegFile #(
    .Width      (135)
)   P0(
    .clk        (clk),
    .rstn       (rstn),
    .vbit_i     (vbit_i),
    .vbit_o     (vbit_p0),
    .data_i     ({MultiOut8,MultiOut7,MultiOut6,MultiOut5,MultiOut4,MultiOut3,MultiOut2,MultiOut1,MultiOut0}),
    .data_o     ({MultiOut8_pip,MultiOut7_pip,MultiOut6_pip,MultiOut5_pip,MultiOut4_pip,MultiOut3_pip,MultiOut2_pip,MultiOut1_pip,MultiOut0_pip})
);

//--------------------------------------------
//  PIPLINE 1
//--------------------------------------------

wire    [15:0]   AddrOut0;
wire    [15:0]   AddrOut1;
wire    [15:0]   AddrOut2;
wire    [15:0]   AddrOut3;
wire    [16:0]   AddrOut4;
wire    [16:0]   AddrOut5;
wire    [17:0]   AddrOut6;
wire    [17:0]   MultiOut8_align;

assign  MultiOut8_align = {MultiOut8_pip[14],3'b0,MultiOut8_pip[13:0]};

FixPointAdder #(
    .Width(15)
)   Adder0(
    .dina   (MultiOut0_pip),
    .dinb   (MultiOut1_pip),
    .dout   (AddrOut0)
);

FixPointAdder #(
    .Width(15)
)   Adder1(
    .dina   (MultiOut2_pip),
    .dinb   (MultiOut3_pip),
    .dout   (AddrOut1)
);

FixPointAdder #(
    .Width(15)
)   Adder2(
    .dina   (MultiOut4_pip),
    .dinb   (MultiOut5_pip),
    .dout   (AddrOut2)
);

FixPointAdder #(
    .Width(15)
)   Adder3(
    .dina   (MultiOut6_pip),
    .dinb   (MultiOut7_pip),
    .dout   (AddrOut3)
);

FixPointAdder #(
    .Width(16)
)   Adder4(
    .dina   (AddrOut0),
    .dinb   (AddrOut1),
    .dout   (AddrOut4)
);

FixPointAdder #(
    .Width(16)
)   Adder5(
    .dina   (AddrOut2),
    .dinb   (AddrOut3),
    .dout   (AddrOut5)
);

FixPointAdder #(
    .Width(17)
)   Adder6(
    .dina   (AddrOut4),
    .dinb   (AddrOut5),
    .dout   (AddrOut6)
);

wire    [18:0]  add_result;

FixPointAdder #(
    .Width(18)
)   Adder7(
    .dina   (MultiOut8_align),
    .dinb   (AddrOut6),
    .dout   (add_result)
);

RegFile #(
    .Width  (19)
)   P1(
    .clk        (clk),
    .rstn       (rstn),
    .vbit_i     (vbit_p0),
    .vbit_o     (vbit_o),
    .data_i     (add_result),
    .data_o     (result)
);


endmodule
