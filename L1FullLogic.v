module L1FullLogic #(
    parameter Width = 15
)(
    input clk,
    input rst_n,

    input data_sel,
    input data_ready,
    input [3:0]bias_sel,

    input[191:0] weight_data,
    //Data ram surface
    input[47:0] second_layer_data_0, 
    input[47:0] second_layer_data_1,
    input[47:0] second_layer_data_2,
    input[47:0] second_layer_data_3,
    input[47:0] second_layer_data_4,
    input[47:0] second_layer_data_5,
    input[47:0] second_layer_data_6,
    input[47:0] second_layer_data_7,
    output wire mac_ready,
    input  bias_valid,
    output wire bias_ready,
    output wire [7:0]Al_result
);


//*****************************************16 bias********************************************************//

parameter L1_I_BP   = 2;
parameter L1_W_BP   = 7;
parameter L1_O_BP   = 1;

parameter L1_bias_0 = 32'b0000000000000000000000_00001100_00;
parameter L1_bias_1 = 32'b0000000000000000000000_00001100_00;
parameter L1_bias_2 = 32'b0000000000000000000000_00001100_00;
parameter L1_bias_3 = 32'b0000000000000000000000_00001011_00;
parameter L1_bias_4 = 32'b0000000000000000000000_00010001_00;
parameter L1_bias_5 = 32'b0000000000000000000000_00001101_00;
parameter L1_bias_6 = 32'b0000000000000000000000_00001110_00;
parameter L1_bias_7 = 32'b0000000000000000000000_00001111_00;
parameter L1_bias_8 = 32'b0000000000000000000000_00001111_00;
parameter L1_bias_9 = 32'b0000000000000000000000_00010010_00;
parameter L1_bias_10 = 32'b0000000000000000000000_00001101_00;
parameter L1_bias_11 = 32'b0000000000000000000000_00001101_00;
parameter L1_bias_12 = 32'b0000000000000000000000_00001011_00;
parameter L1_bias_13 = 32'b0000000000000000000000_00001110_00;
parameter L1_bias_14 = 32'b0000000000000000000000_00001011_00;
parameter L1_bias_15 = 32'b0000000000000000000000_00001101_00;

reg [31:0] layer1_bias_r;   
wire [31:0] layer1_bias;   

always@(*) begin
    case (bias_sel) 
      0 : layer1_bias_r = L1_bias_0;
      1 : layer1_bias_r = L1_bias_1;
      2 : layer1_bias_r = L1_bias_2;
      3 : layer1_bias_r = L1_bias_3;
      4 : layer1_bias_r = L1_bias_4;
      5 : layer1_bias_r = L1_bias_5;
      6 : layer1_bias_r = L1_bias_6;
      7 : layer1_bias_r = L1_bias_7;
      8 : layer1_bias_r = L1_bias_8;
      9 : layer1_bias_r = L1_bias_9;
      10 : layer1_bias_r = L1_bias_10;
      11 : layer1_bias_r = L1_bias_11;
      12 : layer1_bias_r = L1_bias_12;
      13 : layer1_bias_r = L1_bias_13;
      14 : layer1_bias_r = L1_bias_14;
      15 : layer1_bias_r = L1_bias_15;
      default : layer1_bias_r = 'd0;
    endcase
end
assign layer1_bias = layer1_bias_r;

//**********************************************data sel ************************************************//
wire [23:0]second_layer_temp_0;
wire [23:0]second_layer_temp_1;
wire [23:0]second_layer_temp_2;
wire [23:0]second_layer_temp_3;
wire [23:0]second_layer_temp_4;
wire [23:0]second_layer_temp_5;
wire [23:0]second_layer_temp_6;
wire [23:0]second_layer_temp_7;

assign second_layer_temp_0 = (~data_sel) ? second_layer_data_0[47:24] : second_layer_data_0[23:0];
assign second_layer_temp_1 = (~data_sel) ? second_layer_data_1[47:24] : second_layer_data_1[23:0];
assign second_layer_temp_2 = (~data_sel) ? second_layer_data_2[47:24] : second_layer_data_2[23:0];
assign second_layer_temp_3 = (~data_sel) ? second_layer_data_3[47:24] : second_layer_data_3[23:0];
assign second_layer_temp_4 = (~data_sel) ? second_layer_data_4[47:24] : second_layer_data_4[23:0];
assign second_layer_temp_5 = (~data_sel) ? second_layer_data_5[47:24] : second_layer_data_5[23:0];
assign second_layer_temp_6 = (~data_sel) ? second_layer_data_6[47:24] : second_layer_data_6[23:0];
assign second_layer_temp_7 = (~data_sel) ? second_layer_data_7[47:24] : second_layer_data_7[23:0];



wire [Width-1:0]m0_result;
FixPointMultiplier m0(
    .data(second_layer_temp_0[7:0]),
    .weight(weight_data[7:0]),
    .out(m0_result)
);

wire [Width-1:0]m1_result;
FixPointMultiplier m1(
    .data(second_layer_temp_0[15:8]),
    .weight(weight_data[15:8]),
    .out(m1_result)
);

wire [Width-1:0]m2_result;
FixPointMultiplier m2(
    .data(second_layer_temp_0[23:16]),
    .weight(weight_data[23:16]),
    .out(m2_result)
);

wire [Width-1:0]m3_result;
FixPointMultiplier m3(
    .data(second_layer_temp_1[7:0]),
    .weight(weight_data[31:24]),
    .out(m3_result)
);

wire [Width-1:0]m4_result;
FixPointMultiplier m4(
    .data(second_layer_temp_1[15:8]),
    .weight(weight_data[39:32]),
    .out(m4_result)
);

wire [Width-1:0]m5_result;
FixPointMultiplier m5(
    .data(second_layer_temp_1[23:16]),
    .weight(weight_data[47:40]),
    .out(m5_result)
);

wire [Width-1:0]m6_result;
FixPointMultiplier m6(
    .data(second_layer_temp_2[7:0]),
    .weight(weight_data[55:48]),
    .out(m6_result)
);

wire [Width-1:0]m7_result;
FixPointMultiplier m7(
    .data(second_layer_temp_2[15:8]),
    .weight(weight_data[63:56]),
    .out(m7_result)
);

wire [Width-1:0]m8_result;
FixPointMultiplier m8(
    .data(second_layer_temp_2[23:16]),
    .weight(weight_data[71:64]),
    .out(m8_result)
);

wire [Width-1:0]m9_result;
FixPointMultiplier m9(
    .data(second_layer_temp_3[7:0]),
    .weight(weight_data[79:72]),
    .out(m9_result)
);

wire [Width-1:0]m10_result;
FixPointMultiplier m10(
    .data(second_layer_temp_3[15:8]),
    .weight(weight_data[87:80]),
    .out(m10_result)
);

wire [Width-1:0]m11_result;
FixPointMultiplier m11(
    .data(second_layer_temp_3[23:16]),
    .weight(weight_data[95:88]),
    .out(m11_result)
);

wire [Width-1:0]m12_result;
FixPointMultiplier m12(
    .data(second_layer_temp_4[7:0]),
    .weight(weight_data[103:96]),
    .out(m12_result)
);

wire [Width-1:0]m13_result;
FixPointMultiplier m13(
    .data(second_layer_temp_4[15:8]),
    .weight(weight_data[111:104]),
    .out(m13_result)
);

wire [Width-1:0]m14_result;
FixPointMultiplier m14(
    .data(second_layer_temp_4[23:16]),
    .weight(weight_data[119:112]),
    .out(m14_result)
);

wire [Width-1:0]m15_result;
FixPointMultiplier m15(
    .data(second_layer_temp_5[7:0]),
    .weight(weight_data[127:120]),
    .out(m15_result)
);

wire [Width-1:0]m16_result;
FixPointMultiplier m16(
    .data(second_layer_temp_5[15:8]),
    .weight(weight_data[135:128]),
    .out(m16_result)
);

wire [Width-1:0]m17_result;
FixPointMultiplier m17(
    .data(second_layer_temp_5[23:16]),
    .weight(weight_data[143:136]),
    .out(m17_result)
);

wire [Width-1:0]m18_result;
FixPointMultiplier m18(
    .data(second_layer_temp_6[7:0]),
    .weight(weight_data[151:144]),
    .out(m18_result)
);

wire [Width-1:0]m19_result;
FixPointMultiplier m19(
    .data(second_layer_temp_6[15:8]),
    .weight(weight_data[159:152]),
    .out(m19_result)
);

wire [Width-1:0]m20_result;
FixPointMultiplier m20(
    .data(second_layer_temp_6[23:16]),
    .weight(weight_data[167:160]),
    .out(m20_result)
);

wire [Width-1:0]m21_result;
FixPointMultiplier m21(
    .data(second_layer_temp_7[7:0]),
    .weight(weight_data[175:168]),
    .out(m21_result)
);

wire [Width-1:0]m22_result;
FixPointMultiplier m22(
    .data(second_layer_temp_7[15:8]),
    .weight(weight_data[183:176]),
    .out(m22_result)
);

wire [Width-1:0]m23_result;
FixPointMultiplier m23(
    .data(second_layer_temp_7[23:16]),
    .weight(weight_data[191:184]),
    .out(m23_result)
);

wire [Width-1:0]m0_result_r;
wire [23:0] m_valid;
RegFile#(
    .Width(15)
) r0 (
    .clk(clk),
    .rstn(rst_n),
    .vbit_i(data_ready),
    .data_i(m0_result),
    .data_o(m0_result_r),
    .vbit_o(m_valid[0])
);

wire [Width-1:0]m1_result_r;
RegFile#(
    .Width(15)
) r1 (
    .clk(clk),
    .rstn(rst_n),
    .vbit_i(data_ready),
    .data_i(m1_result),
    .data_o(m1_result_r),
    .vbit_o(m_valid[1])
);

wire [Width-1:0]m2_result_r;
RegFile#(
    .Width(15)
) r2 (
    .clk(clk),
    .rstn(rst_n),
    .vbit_i(data_ready),
    .data_i(m2_result),
    .data_o(m2_result_r),
    .vbit_o(m_valid[2])
);

wire [Width-1:0]m3_result_r;
RegFile#(
    .Width(15)
) r3 (
    .clk(clk),
    .rstn(rst_n),
    .vbit_i(data_ready),
    .data_i(m3_result),
    .data_o(m3_result_r),
    .vbit_o(m_valid[3])
);

wire [Width-1:0]m4_result_r;
RegFile#(
    .Width(15)
) r4 (
    .clk(clk),
    .rstn(rst_n),
    .vbit_i(data_ready),
    .data_i(m4_result),
    .data_o(m4_result_r),
    .vbit_o(m_valid[4])
);

wire [Width-1:0]m5_result_r;
RegFile#(
    .Width(15)
) r5 (
    .clk(clk),
    .rstn(rst_n),
    .vbit_i(data_ready),
    .data_i(m5_result),
    .data_o(m5_result_r),
    .vbit_o(m_valid[5])
);

wire [Width-1:0]m6_result_r;
RegFile#(
    .Width(15)
) r6 (
    .clk(clk),
    .rstn(rst_n),
    .vbit_i(data_ready),
    .data_i(m6_result),
    .data_o(m6_result_r),
    .vbit_o(m_valid[6])
);

wire [Width-1:0]m7_result_r;
RegFile#(
    .Width(15)
) r7 (
    .clk(clk),
    .rstn(rst_n),
    .vbit_i(data_ready),
    .data_i(m7_result),
    .data_o(m7_result_r),
    .vbit_o(m_valid[7])
);

wire [Width-1:0]m8_result_r;
RegFile#(
    .Width(15)
) r8 (
    .clk(clk),
    .rstn(rst_n),
    .vbit_i(data_ready),
    .data_i(m8_result),
    .data_o(m8_result_r),
    .vbit_o(m_valid[8])
);

wire [Width-1:0]m9_result_r;
RegFile#(
    .Width(15)
) r9 (
    .clk(clk),
    .rstn(rst_n),
    .vbit_i(data_ready),
    .data_i(m9_result),
    .data_o(m9_result_r),
    .vbit_o(m_valid[9])
);

wire [Width-1:0]m10_result_r;
RegFile#(
    .Width(15)
) r10 (
    .clk(clk),
    .rstn(rst_n),
    .vbit_i(data_ready),
    .data_i(m10_result),
    .data_o(m10_result_r),
    .vbit_o(m_valid[10])
);

wire [Width-1:0]m11_result_r;
RegFile#(
    .Width(15)
) r11 (
    .clk(clk),
    .rstn(rst_n),
    .vbit_i(data_ready),
    .data_i(m11_result),
    .data_o(m11_result_r),
    .vbit_o(m_valid[11])
);

wire [Width-1:0]m12_result_r;
RegFile#(
    .Width(15)
) r12 (
    .clk(clk),
    .rstn(rst_n),
    .vbit_i(data_ready),
    .data_i(m12_result),
    .data_o(m12_result_r),
    .vbit_o(m_valid[12])
);

wire [Width-1:0]m13_result_r;
RegFile#(
    .Width(15)
) r13 (
    .clk(clk),
    .rstn(rst_n),
    .vbit_i(data_ready),
    .data_i(m13_result),
    .data_o(m13_result_r),
    .vbit_o(m_valid[13])
);

wire [Width-1:0]m14_result_r;
RegFile#(
    .Width(15)
) r14 (
    .clk(clk),
    .rstn(rst_n),
    .vbit_i(data_ready),
    .data_i(m14_result),
    .data_o(m14_result_r),
    .vbit_o(m_valid[14])
);

wire [Width-1:0]m15_result_r;
RegFile#(
    .Width(15)
) r15 (
    .clk(clk),
    .rstn(rst_n),
    .vbit_i(data_ready),
    .data_i(m15_result),
    .data_o(m15_result_r),
    .vbit_o(m_valid[15])
);

wire [Width-1:0]m16_result_r;
RegFile#(
    .Width(15)
) r16 (
    .clk(clk),
    .rstn(rst_n),
    .vbit_i(data_ready),
    .data_i(m16_result),
    .data_o(m16_result_r),
    .vbit_o(m_valid[16])
);

wire [Width-1:0]m17_result_r;
RegFile#(
    .Width(15)
) r17 (
    .clk(clk),
    .rstn(rst_n),
    .vbit_i(data_ready),
    .data_i(m17_result),
    .data_o(m17_result_r),
    .vbit_o(m_valid[17])
);

wire [Width-1:0]m18_result_r;
RegFile#(
    .Width(15)
) r18 (
    .clk(clk),
    .rstn(rst_n),
    .vbit_i(data_ready),
    .data_i(m18_result),
    .data_o(m18_result_r),
    .vbit_o(m_valid[18])
);

wire [Width-1:0]m19_result_r;
RegFile#(
    .Width(15)
) r19 (
    .clk(clk),
    .rstn(rst_n),
    .vbit_i(data_ready),
    .data_i(m19_result),
    .data_o(m19_result_r),
    .vbit_o(m_valid[19])
);

wire [Width-1:0]m20_result_r;
RegFile#(
    .Width(15)
) r20 (
    .clk(clk),
    .rstn(rst_n),
    .vbit_i(data_ready),
    .data_i(m20_result),
    .data_o(m20_result_r),
    .vbit_o(m_valid[20])
);

wire [Width-1:0]m21_result_r;
RegFile#(
    .Width(15)
) r21 (
    .clk(clk),
    .rstn(rst_n),
    .vbit_i(data_ready),
    .data_i(m21_result),
    .data_o(m21_result_r),
    .vbit_o(m_valid[21])
);

wire [Width-1:0]m22_result_r;
RegFile#(
    .Width(15)
) r22 (
    .clk(clk),
    .rstn(rst_n),
    .vbit_i(data_ready),
    .data_i(m22_result),
    .data_o(m22_result_r),
    .vbit_o(m_valid[22])
);

wire [Width-1:0]m23_result_r;
RegFile#(
    .Width(15)
) r23 (
    .clk(clk),
    .rstn(rst_n),
    .vbit_i(data_ready),
    .data_i(m23_result),
    .data_o(m23_result_r),
    .vbit_o(m_valid[23])
);

wire mult_ready;
assign mult_ready = &m_valid;

//************************************adderTree******************************//
wire [Width:0] adder_layer2_result0;
FixPointAdder#(
    .Width(15)
) a0(
    .dina(m0_result_r),
    .dinb(m1_result_r),
    .dout(adder_layer2_result0)
);

wire [Width:0] adder_layer2_result1;
FixPointAdder#(
    .Width(15)
) a1(
    .dina(m2_result_r),
    .dinb(m3_result_r),
    .dout(adder_layer2_result1)
);

wire [Width:0] adder_layer2_result2;
FixPointAdder#(
    .Width(15)
) a2(
    .dina(m4_result_r),
    .dinb(m5_result_r),
    .dout(adder_layer2_result2)
);

wire [Width:0] adder_layer2_result3;
FixPointAdder#(
    .Width(15)
) a3(
    .dina(m6_result_r),
    .dinb(m7_result_r),
    .dout(adder_layer2_result3)
);

wire [Width:0] adder_layer2_result4;
FixPointAdder#(
    .Width(15)
) a4(
    .dina(m8_result_r),
    .dinb(m9_result_r),
    .dout(adder_layer2_result4)
);

wire [Width:0] adder_layer2_result5;
FixPointAdder#(
    .Width(15)
) a5(
    .dina(m10_result_r),
    .dinb(m11_result_r),
    .dout(adder_layer2_result5)
);

wire [Width:0] adder_layer2_result6;
FixPointAdder#(
    .Width(15)
) a6(
    .dina(m12_result_r),
    .dinb(m13_result_r),
    .dout(adder_layer2_result6)
);

wire [Width:0] adder_layer2_result7;
FixPointAdder#(
    .Width(15)
) a7(
    .dina(m14_result_r),
    .dinb(m15_result_r),
    .dout(adder_layer2_result7)
);

wire [Width:0] adder_layer2_result8;
FixPointAdder#(
    .Width(15)
) a8(
    .dina(m16_result_r),
    .dinb(m17_result_r),
    .dout(adder_layer2_result8)
);

wire [Width:0] adder_layer2_result9;
FixPointAdder#(
    .Width(15)
) a9(
    .dina(m18_result_r),
    .dinb(m19_result_r),
    .dout(adder_layer2_result9)
);

wire [Width:0] adder_layer2_result10;
FixPointAdder#(
    .Width(15)
) a10(
    .dina(m20_result_r),
    .dinb(m21_result_r),
    .dout(adder_layer2_result10)
);

wire [Width:0] adder_layer2_result11;
FixPointAdder#(
    .Width(15)
) a11(
    .dina(m22_result_r),
    .dinb(m23_result_r),
    .dout(adder_layer2_result11)
);

//adder Net layer 2
wire [Width+1:0] adder_layer3_result0;
FixPointAdder#(
    .Width(16)
) a13(
    .dina(adder_layer2_result0),
    .dinb(adder_layer2_result1),
    .dout(adder_layer3_result0)
);

wire [Width+1:0] adder_layer3_result1;
FixPointAdder#(
    .Width(16)
) a14(
    .dina(adder_layer2_result2),
    .dinb(adder_layer2_result3),
    .dout(adder_layer3_result1)
);

wire [Width+1:0] adder_layer3_result2;
FixPointAdder#(
    .Width(16)
) a15(
    .dina(adder_layer2_result4),
    .dinb(adder_layer2_result5),
    .dout(adder_layer3_result2)
);

wire [Width+1:0] adder_layer3_result3;
FixPointAdder#(
    .Width(16)
) a16(
    .dina(adder_layer2_result6),
    .dinb(adder_layer2_result7),
    .dout(adder_layer3_result3)
);

wire [Width+1:0] adder_layer3_result4;
FixPointAdder#(
    .Width(16)
) a17(
    .dina(adder_layer2_result8),
    .dinb(adder_layer2_result9),
    .dout(adder_layer3_result4)
);

wire [Width+1:0] adder_layer3_result5;
FixPointAdder#(
    .Width(16)
) a18(
    .dina(adder_layer2_result10),
    .dinb(adder_layer2_result11),
    .dout(adder_layer3_result5)
);

//adder Net layer3
wire [Width+2:0] adder_layer4_result0;
FixPointAdder#(
    .Width(17)
) a19(
    .dina(adder_layer3_result0),
    .dinb(adder_layer3_result1),
    .dout(adder_layer4_result0)
);

wire [Width+2:0] adder_layer4_result1;
FixPointAdder#(
    .Width(17)
) a20(
    .dina(adder_layer3_result2),
    .dinb(adder_layer3_result3),
    .dout(adder_layer4_result1)
);

wire [Width+2:0] adder_layer4_result2;
FixPointAdder#(
    .Width(17)
) a21(
    .dina(adder_layer3_result4),
    .dinb(adder_layer3_result5),
    .dout(adder_layer4_result2)
);

//*************************RegFile*******************************//

wire [2:0]adderTree_valid;

wire [Width+2:0] adder_layer4_result0_r;
RegFile#(
    .Width(18)
) addReg0(
    .clk(clk),
    .rstn(rst_n),
    .vbit_i(mult_ready),
    .data_i(adder_layer4_result0),
    .data_o(adder_layer4_result0_r),
    .vbit_o(adderTree_valid[0])

);

wire [Width+2:0] adder_layer4_result1_r;
RegFile#(
    .Width(18)
) addReg1(
    .clk(clk),
    .rstn(rst_n),
    .vbit_i(mult_ready),
    .data_i(adder_layer4_result1),
    .data_o(adder_layer4_result1_r),
    .vbit_o(adderTree_valid[1])

);

wire [Width+2:0] adder_layer4_result2_r;
RegFile#(
    .Width(18)
) addReg2(
    .clk(clk),
    .rstn(rst_n),
    .vbit_i(mult_ready),
    .data_i(adder_layer4_result2),
    .data_o(adder_layer4_result2_r),
    .vbit_o(adderTree_valid[2])

);

wire addTree_ready;
assign addTree_ready = &adderTree_valid;

//adder Net layer4
wire [Width+3:0] adder_layer5_result0;
FixPointAdder#(
    .Width(18)
) a22(
    .dina(adder_layer4_result0_r),
    .dinb(adder_layer4_result1_r),
    .dout(adder_layer5_result0)
);

wire [Width+4:0] adder_layer5_result1;
FixPointAdder#(
    .Width(19)
) a23(
    .dina(adder_layer5_result0),
    .dinb({adder_layer4_result2_r[Width+2],1'd0,adder_layer4_result2_r[Width+1:0]}),
    .dout(adder_layer5_result1)
);

wire [Width+4:0]adder_result;
wire add_valid;
RegFile#(
    .Width(20)
) addselfReg0(
    .clk(clk),
    .rstn(rst_n),
    .vbit_i(addTree_ready),
    .data_i(adder_layer5_result1),
    .data_o(adder_result),
    .vbit_o(add_valid)

);

//addself reg
wire [32:0]sum_duffer;
wire [31:0]sum_duffer_r;


macReg#(
    .Width(32)
) macR0(
    .clk(clk),
    .rstn(rst_n),
    .clean(bias_ready),
    .en(add_valid),
    .vbit_i(add_valid),
    .data_i({sum_duffer[32],sum_duffer[30:0]}),
    .data_o(sum_duffer_r),
    .vbit_o(mac_ready)

);

//adder self layer

FixPointAdder#(
    .Width(32)
) a24(
    .dina(sum_duffer_r),
    .dinb({adder_result[Width+4],12'd0,adder_result[Width+3:0]}),
    .dout(sum_duffer)
);

//**************** ADD_BIAS ALIGN **************************/
wire [32:0] Align_temp;
FixPointAdder#(
    .Width(32)
) a25(
    .dina(sum_duffer_r),
    .dinb(layer1_bias),
    .dout(Align_temp)
);

wire [31:0] relu_out;
ReLU #(
  .Width(32)
) relu0 (
  .din({Align_temp[32],Align_temp[30:0]}),
  .dout(relu_out)
);

wire [7:0]Add_Al_result;
Align #(
  .Width(32),
  .BP_S0(L1_I_BP),
  .BP_S1(L1_W_BP),
  .BP_D(L1_O_BP)
) A1(
  .din(relu_out),
  .dout(Add_Al_result)
);

//result out
RegFile#(
    .Width(8)
) r24 (
    .clk(clk),
    .rstn(rst_n),
    .vbit_i(bias_valid),
    .data_i(Add_Al_result),
    .data_o(Al_result),
    .vbit_o(bias_ready)
);

endmodule