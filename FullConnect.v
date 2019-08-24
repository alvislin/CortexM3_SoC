module Full_Connect_Layer (
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

localparam IDLE = 3'd0;
localparam L1PROCESS = 3'd1;
localparam L2PROCESS = 3'd2;
localparam SDB = 3'd3;

reg [2:0] state;
reg [2:0] state_nxt;

wire L1_start;
wire L1_end;
wire L2_start;
wire L2_end;

always@(posedge clk or negedge rst_n) begin
  if(!rst_n)  state <= IDLE;
  else state<=state_nxt;
end

always@(*) begin
  case(state)
  IDLE:begin
    if(valid) state_nxt <= L1PROCESS;
    else state_nxt <=state;
  end

  L1PROCESS:begin
    if(L1_end) state_nxt <= L2PROCESS;
    else state_nxt <= state;
  end
  L2PROCESS:begin
    if(L2_end) state_nxt <= SDB;
    else state_nxt <= state;
  end

  SDB : begin
    if(!valid) state_nxt <= IDLE;
    else state_nxt <= state;
  end
  endcase
end

assign L1_start = (state == L1PROCESS);
assign L2_start = (state == L2PROCESS || state == SDB);
assign ready = (state == SDB);

wire [7:0]L1_temp0 ;
wire [7:0]L1_temp1 ;
wire [7:0]L1_temp2 ;
wire [7:0]L1_temp3 ;
wire [7:0]L1_temp4 ;
wire [7:0]L1_temp5 ;
wire [7:0]L1_temp6 ;
wire [7:0]L1_temp7 ;
wire [7:0]L1_temp8 ;
wire [7:0]L1_temp9 ;
wire [7:0]L1_temp10;
wire [7:0]L1_temp11;
wire [7:0]L1_temp12;
wire [7:0]L1_temp13;
wire [7:0]L1_temp14;
wire [7:0]L1_temp15;

wire [8:0]L1_W_addr;
wire [8:0]L2_W_addr;

assign weight_addr = (state == L2PROCESS) ? L2_W_addr : L1_W_addr;

L1FullConnect L1full(
     .clk(clk),
     .rst_n(rst_n),
     .valid(L1_start),
     .ready(L1_end),
     .weight_data(weight_data),
     .weight_addr(L1_W_addr),

     .second_layer_data_0(second_layer_data_0), 
     .second_layer_data_1(second_layer_data_1),
     .second_layer_data_2(second_layer_data_2),
     .second_layer_data_3(second_layer_data_3),
     .second_layer_data_4(second_layer_data_4),
     .second_layer_data_5(second_layer_data_5),
     .second_layer_data_6(second_layer_data_6),
     .second_layer_data_7(second_layer_data_7),
     .data_addr(data_addr),

     .L2_din0 (L1_temp0),
     .L2_din1 (L1_temp1),
     .L2_din2 (L1_temp2),
     .L2_din3 (L1_temp3),
     .L2_din4 (L1_temp4),
     .L2_din5 (L1_temp5),
     .L2_din6 (L1_temp6),
     .L2_din7 (L1_temp7),
     .L2_din8 (L1_temp8),
     .L2_din9 (L1_temp9),
     .L2_din10(L1_temp10),
     .L2_din11(L1_temp11),
     .L2_din12(L1_temp12),
     .L2_din13(L1_temp13),
     .L2_din14(L1_temp14),
     .L2_din15(L1_temp15)
);

L2FullConnect L2full0(
    .clk(clk),
    .rst_n(rst_n),
    .valid(L2_start),
    .ready(L2_end),
    .L1_valid(L1_end),

    .weight_data(weight_data),
    .weight_addr(L2_W_addr),

    .L2_din0 (L1_temp0),
    .L2_din1 (L1_temp1),
    .L2_din2 (L1_temp2),
    .L2_din3 (L1_temp3),
    .L2_din4 (L1_temp4),
    .L2_din5 (L1_temp5),
    .L2_din6 (L1_temp6),
    .L2_din7 (L1_temp7),
    .L2_din8 (L1_temp8),
    .L2_din9 (L1_temp9),
    .L2_din10(L1_temp10),
    .L2_din11(L1_temp11),
    .L2_din12(L1_temp12),
    .L2_din13(L1_temp13),
    .L2_din14(L1_temp14),
    .L2_din15(L1_temp15),

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




endmodule