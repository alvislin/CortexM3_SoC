module L1FullConnect(
    input clk,
    input rst_n,
    // ready valid
    input  valid,
    output wire ready,
  //weight ram surface
    input[191:0] weight_data,
    output wire [8:0] weight_addr,

    //Data ram surface
    input[47:0] second_layer_data_0, 
    input[47:0] second_layer_data_1,
    input[47:0] second_layer_data_2,
    input[47:0] second_layer_data_3,
    input[47:0] second_layer_data_4,
    input[47:0] second_layer_data_5,
    input[47:0] second_layer_data_6,
    input[47:0] second_layer_data_7,
    output wire [3:0] data_addr,

    output wire [7:0] L2_din0,
    output wire [7:0] L2_din1,
    output wire [7:0] L2_din2,
    output wire [7:0] L2_din3,
    output wire [7:0] L2_din4,
    output wire [7:0] L2_din5,
    output wire [7:0] L2_din6,
    output wire [7:0] L2_din7,
    output wire [7:0] L2_din8,
    output wire [7:0] L2_din9,
    output wire [7:0] L2_din10,
    output wire [7:0] L2_din11,
    output wire [7:0] L2_din12,
    output wire [7:0] L2_din13,
    output wire [7:0] L2_din14,
    output wire [7:0] L2_din15
);

wire data_ready_w;
wire data_sel_w;
wire [3:0] bias_sel_w;
wire mac_ready_w;
wire ctrl_bias_ready_w;
wire ctrl_bias_valid_w;
wire [7:0]result;

L1FullCtrl #(
    .weight_Start_addr(27),
    .Width(15),
    .L1_process_num(25),
    .neu_num(15)
) fullctrl0(
  .clk(clk),
  .rst_n(rst_n),
  .valid(valid),
  .ready(ready),
  .data_addr(data_addr),
  .weight_addr(weight_addr),
  .data_valid(data_ready_w),
  .data_sel(data_sel_w),
  .bias_sel(bias_sel_w),
  .mac_ready(mac_ready_w),
  .bias_valid(ctrl_bias_valid_w),
  .bias_ready(ctrl_bias_ready_w),
  .Al_result(result),
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

L1FullLogic #(
    .Width(15)
) fulllogic0(
    .clk(clk),
    .rst_n(rst_n),
    .data_sel(data_sel_w),
    .bias_sel(bias_sel_w),
    .data_ready(data_ready_w),
    .mac_ready(mac_ready_w),
    .bias_valid(ctrl_bias_valid_w),
    .bias_ready(ctrl_bias_ready_w),
    .Al_result(result),
    .weight_data(weight_data),
    .second_layer_data_0(second_layer_data_0),
    .second_layer_data_1(second_layer_data_1),
    .second_layer_data_2(second_layer_data_2),
    .second_layer_data_3(second_layer_data_3),
    .second_layer_data_4(second_layer_data_4),
    .second_layer_data_5(second_layer_data_5),
    .second_layer_data_6(second_layer_data_6),
    .second_layer_data_7(second_layer_data_7)
);

endmodule