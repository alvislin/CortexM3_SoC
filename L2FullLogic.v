module L2FullLogic#(
    parameter Width = 15
)(
    input clk,
    input rst_n,

    input data_ready,
    input [3:0]L2_bias_sel,
    input L1_valid,
    input[191:0] weight_data,

    input wire [7:0] L2_din0,
    input wire [7:0] L2_din1,
    input wire [7:0] L2_din2,
    input wire [7:0] L2_din3,
    input wire [7:0] L2_din4,
    input wire [7:0] L2_din5,
    input wire [7:0] L2_din6,
    input wire [7:0] L2_din7,
    input wire [7:0] L2_din8,
    input wire [7:0] L2_din9,
    input wire [7:0] L2_din10,
    input wire [7:0] L2_din11,
    input wire [7:0] L2_din12,
    input wire [7:0] L2_din13,
    input wire [7:0] L2_din14,
    input wire [7:0] L2_din15,

    output wire [7:0]L2_result,
    output wire cal_valid
);

//*****************************************10 bias********************************************************//

parameter L2_I_BP   = 1;
parameter L2_W_BP   = 7;
parameter L2_O_BP   = 1;
parameter L2_bias_0 = 19'b0000000000_00001011_0;
parameter L2_bias_1 = 19'b0000000000_00001110_0;
parameter L2_bias_2 = 19'b0000000000_00001100_0;
parameter L2_bias_3 = 19'b0000000000_00010011_0;
parameter L2_bias_4 = 19'b0000000000_00001010_0;
parameter L2_bias_5 = 19'b0000000000_00001110_0;
parameter L2_bias_6 = 19'b0000000000_00001000_0;
parameter L2_bias_7 = 19'b0000000000_00001101_0;
parameter L2_bias_8 = 19'b0000000000_00001000_0;
parameter L2_bias_9 = 19'b0000000000_00001111_0;

reg[18:0] layer2_bias_r;
wire[18:0] layer2_bias;

always@(*) begin
    case (L2_bias_sel) 
      0 : layer2_bias_r = L2_bias_0;
      1 : layer2_bias_r = L2_bias_1;
      2 : layer2_bias_r = L2_bias_2;
      3 : layer2_bias_r = L2_bias_3;
      4 : layer2_bias_r = L2_bias_4;
      5 : layer2_bias_r = L2_bias_5;
      6 : layer2_bias_r = L2_bias_6;
      7 : layer2_bias_r = L2_bias_7;
      8 : layer2_bias_r = L2_bias_8;
      9 : layer2_bias_r = L2_bias_9;
      default : layer2_bias_r = 'd0;
    endcase
end

assign layer2_bias = layer2_bias_r;

//***************************************save 
reg [7:0] L2_din0_r;
reg [7:0] L2_din1_r;
reg [7:0] L2_din2_r;
reg [7:0] L2_din3_r;
reg [7:0] L2_din4_r;
reg [7:0] L2_din5_r;
reg [7:0] L2_din6_r;
reg [7:0] L2_din7_r;
reg [7:0] L2_din8_r;
reg [7:0] L2_din9_r;
reg [7:0] L2_din10_r;
reg [7:0] L2_din11_r;
reg [7:0] L2_din12_r;
reg [7:0] L2_din13_r;
reg [7:0] L2_din14_r;
reg [7:0] L2_din15_r;

always@(posedge clk or negedge rst_n) begin
  if(~rst_n) begin
    L2_din0_r  <= 0;
    L2_din1_r  <= 0;
    L2_din2_r  <= 0;
    L2_din3_r  <= 0;
    L2_din4_r  <= 0;
    L2_din5_r  <= 0;
    L2_din6_r  <= 0;
    L2_din7_r  <= 0;
    L2_din8_r  <= 0;
    L2_din9_r  <= 0;
    L2_din10_r <= 0;
    L2_din11_r <= 0;
    L2_din12_r <= 0;
    L2_din13_r <= 0;
    L2_din14_r <= 0;
    L2_din15_r <= 0;
  end
  else if(L1_valid) begin
    L2_din0_r  <= L2_din0;
    L2_din1_r  <= L2_din1;
    L2_din2_r  <= L2_din2;
    L2_din3_r  <= L2_din3;
    L2_din4_r  <= L2_din4;
    L2_din5_r  <= L2_din5;
    L2_din6_r  <= L2_din6;
    L2_din7_r  <= L2_din7;
    L2_din8_r  <= L2_din8;
    L2_din9_r  <= L2_din9;
    L2_din10_r <= L2_din10;
    L2_din11_r <= L2_din11;
    L2_din12_r <= L2_din12;
    L2_din13_r <= L2_din13;
    L2_din14_r <= L2_din14;
    L2_din15_r <= L2_din15;   
  end
end
//****************************************mutilpiyer ********************************************//

wire [Width-1:0]L2_m0_result;
FixPointMultiplier m24(
    .data(L2_din0_r),
    .weight(weight_data[7:0]),
    .out(L2_m0_result)
);

wire [Width-1:0]L2_m1_result;
FixPointMultiplier m25(
    .data(L2_din1_r),
    .weight(weight_data[15:8]),
    .out(L2_m1_result)
);

wire [Width-1:0]L2_m2_result;
FixPointMultiplier m26(
    .data(L2_din2_r),
    .weight(weight_data[23:16]),
    .out(L2_m2_result)
);

wire [Width-1:0]L2_m3_result;
FixPointMultiplier m27(
    .data(L2_din3_r),
    .weight(weight_data[31:24]),
    .out(L2_m3_result)
);

wire [Width-1:0]L2_m4_result;
FixPointMultiplier m28(
    .data(L2_din4_r),
    .weight(weight_data[39:32]),
    .out(L2_m4_result)
);

wire [Width-1:0]L2_m5_result;
FixPointMultiplier m29(
    .data(L2_din5_r),
    .weight(weight_data[47:40]),
    .out(L2_m5_result)
);

wire [Width-1:0]L2_m6_result;
FixPointMultiplier m30(
    .data(L2_din6_r),
    .weight(weight_data[55:48]),
    .out(L2_m6_result)
);

wire [Width-1:0]L2_m7_result;
FixPointMultiplier m31(
    .data(L2_din7_r),
    .weight(weight_data[63:56]),
    .out(L2_m7_result)
);

wire [Width-1:0]L2_m8_result;
FixPointMultiplier m32(
    .data(L2_din8_r),
    .weight(weight_data[71:64]),
    .out(L2_m8_result)
);

wire [Width-1:0]L2_m9_result;
FixPointMultiplier m33(
    .data(L2_din9_r),
    .weight(weight_data[79:72]),
    .out(L2_m9_result)
);

wire [Width-1:0]L2_m10_result;
FixPointMultiplier m34(
    .data(L2_din10_r),
    .weight(weight_data[87:80]),
    .out(L2_m10_result)
);

wire [Width-1:0]L2_m11_result;
FixPointMultiplier m35(
    .data(L2_din11_r),
    .weight(weight_data[95:88]),
    .out(L2_m11_result)
);

wire [Width-1:0]L2_m12_result;
FixPointMultiplier m36(
    .data(L2_din12_r),
    .weight(weight_data[103:96]),
    .out(L2_m12_result)
);

wire [Width-1:0]L2_m13_result;
FixPointMultiplier m37(
    .data(L2_din13_r),
    .weight(weight_data[111:104]),
    .out(L2_m13_result)
);

wire [Width-1:0]L2_m14_result;
FixPointMultiplier m38(
    .data(L2_din14_r),
    .weight(weight_data[119:112]),
    .out(L2_m14_result)
);

wire [Width-1:0]L2_m15_result;
FixPointMultiplier m39(
    .data(L2_din15_r),
    .weight(weight_data[127:120]),
    .out(L2_m15_result)
);

//******************************************regfile******************************//

wire [Width-1:0]L2_m0_result_r;
wire [15:0] L2_m_valid;
RegFile#(
    .Width(15)
) r25 (
    .clk(clk),
    .rstn(rst_n),
    .vbit_i(data_ready),
    .data_i(L2_m0_result),
    .data_o(L2_m0_result_r),
    .vbit_o(L2_m_valid[0])
);

wire [Width-1:0]L2_m1_result_r;
RegFile#(
    .Width(15)
) r26 (
    .clk(clk),
    .rstn(rst_n),
    .vbit_i(data_ready),
    .data_i(L2_m1_result),
    .data_o(L2_m1_result_r),
    .vbit_o(L2_m_valid[1])
);

wire [Width-1:0]L2_m2_result_r;
RegFile#(
    .Width(15)
) r27 (
    .clk(clk),
    .rstn(rst_n),
    .vbit_i(data_ready),
    .data_i(L2_m2_result),
    .data_o(L2_m2_result_r),
    .vbit_o(L2_m_valid[2])
);

wire [Width-1:0]L2_m3_result_r;
RegFile#(
    .Width(15)
) r28 (
    .clk(clk),
    .rstn(rst_n),
    .vbit_i(data_ready),
    .data_i(L2_m3_result),
    .data_o(L2_m3_result_r),
    .vbit_o(L2_m_valid[3])
);

wire [Width-1:0]L2_m4_result_r;
RegFile#(
    .Width(15)
) r29 (
    .clk(clk),
    .rstn(rst_n),
    .vbit_i(data_ready),
    .data_i(L2_m4_result),
    .data_o(L2_m4_result_r),
    .vbit_o(L2_m_valid[4])
);

wire [Width-1:0]L2_m5_result_r;
RegFile#(
    .Width(15)
) r30 (
    .clk(clk),
    .rstn(rst_n),
    .vbit_i(data_ready),
    .data_i(L2_m5_result),
    .data_o(L2_m5_result_r),
    .vbit_o(L2_m_valid[5])
);

wire [Width-1:0]L2_m6_result_r;
RegFile#(
    .Width(15)
) r31 (
    .clk(clk),
    .rstn(rst_n),
    .vbit_i(data_ready),
    .data_i(L2_m6_result),
    .data_o(L2_m6_result_r),
    .vbit_o(L2_m_valid[6])
);

wire [Width-1:0]L2_m7_result_r;
RegFile#(
    .Width(15)
) r32 (
    .clk(clk),
    .rstn(rst_n),
    .vbit_i(data_ready),
    .data_i(L2_m7_result),
    .data_o(L2_m7_result_r),
    .vbit_o(L2_m_valid[7])
);

wire [Width-1:0]L2_m8_result_r;
RegFile#(
    .Width(15)
) r33 (
    .clk(clk),
    .rstn(rst_n),
    .vbit_i(data_ready),
    .data_i(L2_m8_result),
    .data_o(L2_m8_result_r),
    .vbit_o(L2_m_valid[8])
);

wire [Width-1:0]L2_m9_result_r;
RegFile#(
    .Width(15)
) r34 (
    .clk(clk),
    .rstn(rst_n),
    .vbit_i(data_ready),
    .data_i(L2_m9_result),
    .data_o(L2_m9_result_r),
    .vbit_o(L2_m_valid[9])
);

wire [Width-1:0]L2_m10_result_r;
RegFile#(
    .Width(15)
) r35 (
    .clk(clk),
    .rstn(rst_n),
    .vbit_i(data_ready),
    .data_i(L2_m10_result),
    .data_o(L2_m10_result_r),
    .vbit_o(L2_m_valid[10])
);

wire [Width-1:0]L2_m11_result_r;
RegFile#(
    .Width(15)
) r36 (
    .clk(clk),
    .rstn(rst_n),
    .vbit_i(data_ready),
    .data_i(L2_m11_result),
    .data_o(L2_m11_result_r),
    .vbit_o(L2_m_valid[11])
);

wire [Width-1:0]L2_m12_result_r;
RegFile#(
    .Width(15)
) r37 (
    .clk(clk),
    .rstn(rst_n),
    .vbit_i(data_ready),
    .data_i(L2_m12_result),
    .data_o(L2_m12_result_r),
    .vbit_o(L2_m_valid[12])
);

wire [Width-1:0]L2_m13_result_r;
RegFile#(
    .Width(15)
) r38 (
    .clk(clk),
    .rstn(rst_n),
    .vbit_i(data_ready),
    .data_i(L2_m13_result),
    .data_o(L2_m13_result_r),
    .vbit_o(L2_m_valid[13])
);

wire [Width-1:0]L2_m14_result_r;
RegFile#(
    .Width(15)
) r39 (
    .clk(clk),
    .rstn(rst_n),
    .vbit_i(data_ready),
    .data_i(L2_m14_result),
    .data_o(L2_m14_result_r),
    .vbit_o(L2_m_valid[14])
);

wire [Width-1:0]L2_m15_result_r;
RegFile#(
    .Width(15)
) r40 (
    .clk(clk),
    .rstn(rst_n),
    .vbit_i(data_ready),
    .data_i(L2_m15_result),
    .data_o(L2_m15_result_r),
    .vbit_o(L2_m_valid[15])
);

wire muti_ready;
assign muti_ready = &L2_m_valid; 

//********************************adder tree***************************//

wire [Width:0] L2_adder_layer2_result0;
FixPointAdder#(
    .Width(15)
) a26(
    .dina(L2_m0_result_r),
    .dinb(L2_m1_result_r),
    .dout(L2_adder_layer2_result0)
);

wire [Width:0] L2_adder_layer2_result1;
FixPointAdder#(
    .Width(15)
) a27(
    .dina(L2_m2_result_r),
    .dinb(L2_m3_result_r),
    .dout(L2_adder_layer2_result1)
);

wire [Width:0] L2_adder_layer2_result2;
FixPointAdder#(
    .Width(15)
) a28(
    .dina(L2_m4_result_r),
    .dinb(L2_m5_result_r),
    .dout(L2_adder_layer2_result2)
);

wire [Width:0] L2_adder_layer2_result3;
FixPointAdder#(
    .Width(15)
) a29(
    .dina(L2_m6_result_r),
    .dinb(L2_m7_result_r),
    .dout(L2_adder_layer2_result3)
);

wire [Width:0] L2_adder_layer2_result4;
FixPointAdder#(
    .Width(15)
) a30(
    .dina(L2_m8_result_r),
    .dinb(L2_m9_result_r),
    .dout(L2_adder_layer2_result4)
);

wire [Width:0] L2_adder_layer2_result5;
FixPointAdder#(
    .Width(15)
) a31(
    .dina(L2_m10_result_r),
    .dinb(L2_m11_result_r),
    .dout(L2_adder_layer2_result5)
);

wire [Width:0] L2_adder_layer2_result6;
FixPointAdder#(
    .Width(15)
) a32(
    .dina(L2_m12_result_r),
    .dinb(L2_m13_result_r),
    .dout(L2_adder_layer2_result6)
);

wire [Width:0] L2_adder_layer2_result7;
FixPointAdder#(
    .Width(15)
) a33(
    .dina(L2_m14_result_r),
    .dinb(L2_m15_result_r),
    .dout(L2_adder_layer2_result7)
);


// adder layer2 Net
wire [Width+1:0] L2_adder_layer3_result0;
FixPointAdder#(
    .Width(16)
) a34(
    .dina(L2_adder_layer2_result0),
    .dinb(L2_adder_layer2_result1),
    .dout(L2_adder_layer3_result0)
);

wire [Width+1:0] L2_adder_layer3_result1;
FixPointAdder#(
    .Width(16)
) a35(
    .dina(L2_adder_layer2_result2),
    .dinb(L2_adder_layer2_result3),
    .dout(L2_adder_layer3_result1)
);


wire [Width+1:0] L2_adder_layer3_result2;
FixPointAdder#(
    .Width(16)
) a36(
    .dina(L2_adder_layer2_result4),
    .dinb(L2_adder_layer2_result5),
    .dout(L2_adder_layer3_result2)
);


wire [Width+1:0] L2_adder_layer3_result3;
FixPointAdder#(
    .Width(16)
) a37(
    .dina(L2_adder_layer2_result6),
    .dinb(L2_adder_layer2_result7),
    .dout(L2_adder_layer3_result3)
);


//L2 adder Net layer4
wire [Width+2:0] L2_adder_layer4_result0;
FixPointAdder#(
    .Width(17)
) a38(
    .dina(L2_adder_layer3_result0),
    .dinb(L2_adder_layer3_result1),
    .dout(L2_adder_layer4_result0)
);


wire [Width+2:0] L2_adder_layer4_result1;
FixPointAdder#(
    .Width(17)
) a39(
    .dina(L2_adder_layer3_result2),
    .dinb(L2_adder_layer3_result3),
    .dout(L2_adder_layer4_result1)
);

//************************RegFile**********************************//
wire [Width+2:0] L2_adder_layer4_result0_r;
wire [Width+2:0] L2_adder_layer4_result1_r;
wire [1:0]adder_valid;
wire adder_ready;
assign adder_ready = &adder_valid;

RegFile#(
    .Width(18)
) addReg0 (
    .clk(clk),
    .rstn(rst_n),
    .vbit_i(muti_ready),
    .data_i(L2_adder_layer4_result0),
    .data_o(L2_adder_layer4_result0_r),
    .vbit_o(adder_valid[0])
);

RegFile#(
    .Width(18)
) addReg1 (
    .clk(clk),
    .rstn(rst_n),
    .vbit_i(muti_ready),
    .data_i(L2_adder_layer4_result1),
    .data_o(L2_adder_layer4_result1_r),
    .vbit_o(adder_valid[1])
);

wire [Width+3:0] L2_adder_layer5_result0;
FixPointAdder#(
    .Width(18)
) a40(
    .dina(L2_adder_layer4_result0_r),
    .dinb(L2_adder_layer4_result1_r),
    .dout(L2_adder_layer5_result0)
);

// output layer 
wire [Width+4:0] L2_adder_layer6_result0;
FixPointAdder#(
    .Width(19)
) a41(
    .dina(L2_adder_layer5_result0),
    .dinb(layer2_bias),
    .dout(L2_adder_layer6_result0)
);

wire [7:0] Num_P;
Align #(
  .Width(20),
  .BP_S0(L2_I_BP),
  .BP_S1(L2_W_BP),
  .BP_D(L2_O_BP)
) A2(
  .din(L2_adder_layer6_result0),
  .dout(Num_P)
);


RegFile#(
    .Width(8)
) r41 (
    .clk(clk),
    .rstn(rst_n),
    .vbit_i(adder_ready),
    .data_i(Num_P),
    .data_o(L2_result),
    .vbit_o(cal_valid)
);


endmodule
