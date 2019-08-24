module L2FullConnect(
    input  clk,
    input  rst_n,
    input  valid,
    output ready,

    input L1_valid,
    output wire [8:0] weight_addr,
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

    //dataOut surface
    output wire [7:0] num_0,
    output wire [7:0] num_1, 
    output wire [7:0] num_2,
    output wire [7:0] num_3, 
    output wire [7:0] num_4,
    output wire [7:0] num_5, 
    output wire [7:0] num_6,
    output wire [7:0] num_7,
    output wire [7:0] num_8,
    output wire [7:0] num_9
);

wire cal_fire;
wire [3:0]L2_bias_sel;
wire data_fire;
wire [7:0] L2_result;


L2FullCtrl#(
    .weight_Start_addr(443),
    .Width(15),
    .out_num(10 - 1)
) L2fullctrl0(
    .clk(clk),
    .rst_n(rst_n),
    .ready(ready),
    .valid(valid),
    .weight_addr(weight_addr),
    .cal_ready(cal_fire),
    .L2_bias_sel(L2_bias_sel),
    .data_valid(data_fire),
    .L2_result(L2_result),
    .num_0(num_0),
    .num_1(num_1),
    .num_2(num_2),
    .num_3(num_3),
    .num_4(num_4),
    .num_5(num_5),
    .num_6(num_6),
    .num_7(num_7),
    .num_8(num_8),
    .num_9(num_9)
);

L2FullLogic#(
    .Width(15)
) L2fulllogic0(
    .clk(clk),
    .rst_n(rst_n),
    .weight_data(weight_data),
    .data_ready(data_fire),
    .L1_valid(L1_valid),
    .L2_bias_sel(L2_bias_sel),
    .cal_valid(cal_fire),
    .L2_result(L2_result),
    .L2_din0(L2_din0),
    .L2_din1(L2_din1),
    .L2_din2(L2_din2),
    .L2_din3(L2_din3),
    .L2_din4(L2_din4),
    .L2_din5(L2_din5),
    .L2_din6(L2_din6),
    .L2_din7(L2_din7),
    .L2_din8(L2_din8),
    .L2_din9(L2_din9),
    .L2_din10(L2_din10),
    .L2_din11(L2_din11),
    .L2_din12(L2_din12),
    .L2_din13(L2_din13),
    .L2_din14(L2_din14),
    .L2_din15(L2_din15)
);

endmodule