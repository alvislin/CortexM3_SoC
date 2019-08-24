module Full_Connect_Layer #(
    parameter weight_Start_addr = 51,
    parameter Width = 15
)(
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

//*****************************************26 bias********************************************************//

parameter L1_I_BP   = 2;
parameter L1_W_BP   = 7;
parameter L1_O_BP   = 1;
parameter L2_I_BP   = 1;
parameter L2_W_BP   = 7;
parameter L2_O_BP   = 1;

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


//*****************************************FSM********************************************************//
localparam IDLE = 3'd0;
localparam L1_LOAD = 3'd1;
localparam L1_DATA_PROCESS = 3'd2;
localparam L1_ADD_BIAS = 3'd3;
localparam L2_LOAD = 3'd4;
localparam L2_PROCESS = 3'd5;
localparam L2_ADD_BIAS = 3'd6;
localparam SDB = 3'd7;

reg [2:0] state;
reg [2:0] state_nxt;

reg [3:0]dout_counter;
reg [3:0]Num_counter;

wire dout_nxt;
wire MA_done;
wire L1_done;
wire L2_done;
reg use_w_counter;

assign ready = (state == SDB);
assign layer2_process = (state == L2_PROCESS)? 1'b1:1'b0;

always@(posedge clk or negedge rst_n) begin
  if(!rst_n)  state <= IDLE;
  else state<=state_nxt;
end

always@(*) begin
  case(state)
  IDLE:begin
    if(valid) state_nxt <= L1_DATA_PROCESS;
    else state_nxt <=state;
  end

  L1_DATA_PROCESS:begin
    if(MA_done) state_nxt <= L1_ADD_BIAS;
    else state_nxt <= L1_LOAD;
  end

  L1_LOAD:begin
     state_nxt<=L1_DATA_PROCESS;
  end

  L1_ADD_BIAS:begin
    if(L1_done) state_nxt <= L2_LOAD;
    else state_nxt <= L1_LOAD;
  end
  L2_LOAD:begin
    state_nxt <= L2_PROCESS;
  end

  L2_PROCESS:begin
    if(L2_done) state_nxt <= SDB;
    else state_nxt <= L2_LOAD;
  end

  SDB : begin
    if(!valid) state_nxt <= IDLE;
    else state_nxt <= state;
  end


  endcase
end

//******************************sel bias******************************************//
reg [31:0] layer1_bias_r;   
reg [18:0] layer2_bias_r;

wire [31:0] layer1_bias;   
wire [18:0] layer2_bias;

always@(*) begin
    case (dout_counter) 
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

always@(*) begin
    case (Num_counter) 
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

assign layer1_bias = layer1_bias_r;
assign layer2_bias = layer2_bias_r;



//*************************L1_load****************************************//
reg [8:0] w_addr;
reg [3:0] d_addr;

assign weight_addr = w_addr;
assign data_addr = d_addr;
 
always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
      w_addr <= weight_Start_addr;
    end 
    else if(state == L1_DATA_PROCESS || state == L2_PROCESS) begin
      w_addr <= w_addr + 1'd1;
    end
    else if(state == IDLE) begin
      w_addr <= weight_Start_addr;
    end
end

always@(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    d_addr <=5'd0; 
  end
  else if(state == L1_DATA_PROCESS && use_w_counter == 1'd1) begin
    d_addr <= d_addr + 1'd1;
  end
  else if(state == L1_ADD_BIAS) begin
    d_addr <= 5'd0;
  end
  else if(state == IDLE) begin
    d_addr <= 5'd0;
  end
end


//****************************process************************************//
reg [31:0] sum_buffer;

wire [31:0] add_sum;
wire [32:0] add_result;

assign add_sum = sum_buffer;


always@(posedge clk or negedge rst_n) begin
  if(!rst_n ) begin
    sum_buffer <= 32'd0;
  end
  else if(state == L1_DATA_PROCESS) begin
    sum_buffer <= {add_result[32],add_result[30:0]};
  end
  else if(state == L1_ADD_BIAS) begin
    sum_buffer <= 32'd0;
  end
  else if(state == IDLE) begin
    sum_buffer <= 32'd0;
  end
end  

always@(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    use_w_counter <= 1'd0;
  end
  else if(state == L1_DATA_PROCESS) begin
    use_w_counter <= use_w_counter + 1'd1;
  end
end

reg[4:0] p_counter;
assign MA_done = (p_counter == 5'd25 && state == L1_DATA_PROCESS) ? 1'd1 : 1'd0;

always@(posedge clk or negedge rst_n) begin
  if(!rst_n ) begin
    p_counter <= 5'd0;
  end
  else if(state == L1_DATA_PROCESS) begin
    if(p_counter == 5'd25) begin
      p_counter <= 5'd0;
    end
    else p_counter <= p_counter + 1'd1;
  end
  else if(state == IDLE) begin
    p_counter <= 5'd0;  
  end
end

wire [23:0]second_layer_temp_0;
wire [23:0]second_layer_temp_1;
wire [23:0]second_layer_temp_2;
wire [23:0]second_layer_temp_3;
wire [23:0]second_layer_temp_4;
wire [23:0]second_layer_temp_5;
wire [23:0]second_layer_temp_6;
wire [23:0]second_layer_temp_7;

assign second_layer_temp_0 = (use_w_counter == 1'd1) ? second_layer_data_0[47:24] : second_layer_data_0[23:0];
assign second_layer_temp_1 = (use_w_counter == 1'd1) ? second_layer_data_1[47:24] : second_layer_data_1[23:0];
assign second_layer_temp_2 = (use_w_counter == 1'd1) ? second_layer_data_2[47:24] : second_layer_data_2[23:0];
assign second_layer_temp_3 = (use_w_counter == 1'd1) ? second_layer_data_3[47:24] : second_layer_data_3[23:0];
assign second_layer_temp_4 = (use_w_counter == 1'd1) ? second_layer_data_4[47:24] : second_layer_data_4[23:0];
assign second_layer_temp_5 = (use_w_counter == 1'd1) ? second_layer_data_5[47:24] : second_layer_data_5[23:0];
assign second_layer_temp_6 = (use_w_counter == 1'd1) ? second_layer_data_6[47:24] : second_layer_data_6[23:0];
assign second_layer_temp_7 = (use_w_counter == 1'd1) ? second_layer_data_7[47:24] : second_layer_data_7[23:0];

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


wire [Width:0] adder_layer2_result0;
FixPointAdder#(
    .Width(15)
) a0(
    .dina(m0_result),
    .dinb(m1_result),
    .dout(adder_layer2_result0)
);

wire [Width:0] adder_layer2_result1;
FixPointAdder#(
    .Width(15)
) a1(
    .dina(m2_result),
    .dinb(m3_result),
    .dout(adder_layer2_result1)
);

wire [Width:0] adder_layer2_result2;
FixPointAdder#(
    .Width(15)
) a2(
    .dina(m4_result),
    .dinb(m5_result),
    .dout(adder_layer2_result2)
);

wire [Width:0] adder_layer2_result3;
FixPointAdder#(
    .Width(15)
) a3(
    .dina(m6_result),
    .dinb(m7_result),
    .dout(adder_layer2_result3)
);

wire [Width:0] adder_layer2_result4;
FixPointAdder#(
    .Width(15)
) a4(
    .dina(m8_result),
    .dinb(m9_result),
    .dout(adder_layer2_result4)
);

wire [Width:0] adder_layer2_result5;
FixPointAdder#(
    .Width(15)
) a5(
    .dina(m10_result),
    .dinb(m11_result),
    .dout(adder_layer2_result5)
);

wire [Width:0] adder_layer2_result6;
FixPointAdder#(
    .Width(15)
) a6(
    .dina(m12_result),
    .dinb(m13_result),
    .dout(adder_layer2_result6)
);

wire [Width:0] adder_layer2_result7;
FixPointAdder#(
    .Width(15)
) a7(
    .dina(m14_result),
    .dinb(m15_result),
    .dout(adder_layer2_result7)
);

wire [Width:0] adder_layer2_result8;
FixPointAdder#(
    .Width(15)
) a8(
    .dina(m16_result),
    .dinb(m17_result),
    .dout(adder_layer2_result8)
);

wire [Width:0] adder_layer2_result9;
FixPointAdder#(
    .Width(15)
) a9(
    .dina(m18_result),
    .dinb(m19_result),
    .dout(adder_layer2_result9)
);

wire [Width:0] adder_layer2_result10;
FixPointAdder#(
    .Width(15)
) a10(
    .dina(m20_result),
    .dinb(m21_result),
    .dout(adder_layer2_result10)
);

wire [Width:0] adder_layer2_result11;
FixPointAdder#(
    .Width(15)
) a11(
    .dina(m22_result),
    .dinb(m23_result),
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

//adder Net layer4
wire [Width+3:0] adder_layer5_result0;
FixPointAdder#(
    .Width(18)
) a22(
    .dina(adder_layer4_result0),
    .dinb(adder_layer4_result1),
    .dout(adder_layer5_result0)
);

wire [Width+4:0] adder_layer5_result1;
FixPointAdder#(
    .Width(19)
) a23(
    .dina(adder_layer5_result0),
    .dinb({adder_layer4_result2[Width+2],1'd0,adder_layer4_result2[Width+1:0]}),
    .dout(adder_layer5_result1)
);

// adder self layer
FixPointAdder#(
    .Width(32)
) a24(
    .dina(add_sum),
    .dinb({adder_layer5_result1[Width+4],12'd0,adder_layer5_result1[Width+3:0]}),
    .dout(add_result)
);

//**************** ADD_BIAS ALIGN **************************/
wire [32:0] Align_temp;
FixPointAdder#(
    .Width(32)
) a25(
    .dina(add_sum),
    .dinb(layer1_bias),
    .dout(Align_temp)
);

wire [31:0] relu_out;
ReLU #(
  .Width(32)
) r0 (
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



//****************************ADD_BIAS & Align******************************//
reg [127:0] L1_result;

always@(posedge clk or negedge rst_n) begin
  if(!rst_n ) begin
    L1_result <= 128'd0;
  end
  else if(state == L1_ADD_BIAS) begin
    L1_result <= {Add_Al_result,L1_result[127:8]};
  end
end  



assign L1_done = (dout_counter == 4'd15 && state == L1_ADD_BIAS)? 1'd1 : 1'd0;

always@(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    dout_counter <= 4'd0;
  end
  else if(state == L1_ADD_BIAS) begin
    dout_counter <= dout_counter + 1'd1;
  end
  else if(state == IDLE) begin
    dout_counter <= 4'd0;
  end
end



//*************************L2_LOAD*********************//
wire [7:0] L2_din0;
wire [7:0] L2_din1;
wire [7:0] L2_din2;
wire [7:0] L2_din3;
wire [7:0] L2_din4;
wire [7:0] L2_din5;
wire [7:0] L2_din6;
wire [7:0] L2_din7;
wire [7:0] L2_din8;
wire [7:0] L2_din9;
wire [7:0] L2_din10;
wire [7:0] L2_din11;
wire [7:0] L2_din12;
wire [7:0] L2_din13;
wire [7:0] L2_din14;
wire [7:0] L2_din15;

assign L2_din0 = L1_result[7:0];
assign L2_din1 = L1_result[15:8];
assign L2_din2 = L1_result[23:16];
assign L2_din3 = L1_result[31:24];
assign L2_din4 = L1_result[39:32];
assign L2_din5 = L1_result[47:40];
assign L2_din6 = L1_result[55:48];
assign L2_din7 = L1_result[63:56];
assign L2_din8 = L1_result[71:64];
assign L2_din9 = L1_result[79:72];
assign L2_din10 = L1_result[87:80];
assign L2_din11 = L1_result[95:88];
assign L2_din12 = L1_result[103:96];
assign L2_din13 = L1_result[111:104];
assign L2_din14 = L1_result[119:112];
assign L2_din15 = L1_result[127:120];


wire [Width-1:0]L2_m0_result;
FixPointMultiplier m24(
    .data(L2_din0),
    .weight(weight_data[7:0]),
    .out(L2_m0_result)
);

wire [Width-1:0]L2_m1_result;
FixPointMultiplier m25(
    .data(L2_din1),
    .weight(weight_data[15:8]),
    .out(L2_m1_result)
);

wire [Width-1:0]L2_m2_result;
FixPointMultiplier m26(
    .data(L2_din2),
    .weight(weight_data[23:16]),
    .out(L2_m2_result)
);

wire [Width-1:0]L2_m3_result;
FixPointMultiplier m27(
    .data(L2_din3),
    .weight(weight_data[31:24]),
    .out(L2_m3_result)
);

wire [Width-1:0]L2_m4_result;
FixPointMultiplier m28(
    .data(L2_din4),
    .weight(weight_data[39:32]),
    .out(L2_m4_result)
);

wire [Width-1:0]L2_m5_result;
FixPointMultiplier m29(
    .data(L2_din5),
    .weight(weight_data[47:40]),
    .out(L2_m5_result)
);

wire [Width-1:0]L2_m6_result;
FixPointMultiplier m30(
    .data(L2_din6),
    .weight(weight_data[55:48]),
    .out(L2_m6_result)
);

wire [Width-1:0]L2_m7_result;
FixPointMultiplier m31(
    .data(L2_din7),
    .weight(weight_data[63:56]),
    .out(L2_m7_result)
);

wire [Width-1:0]L2_m8_result;
FixPointMultiplier m32(
    .data(L2_din8),
    .weight(weight_data[71:64]),
    .out(L2_m8_result)
);

wire [Width-1:0]L2_m9_result;
FixPointMultiplier m33(
    .data(L2_din9),
    .weight(weight_data[79:72]),
    .out(L2_m9_result)
);

wire [Width-1:0]L2_m10_result;
FixPointMultiplier m34(
    .data(L2_din10),
    .weight(weight_data[87:80]),
    .out(L2_m10_result)
);

wire [Width-1:0]L2_m11_result;
FixPointMultiplier m35(
    .data(L2_din11),
    .weight(weight_data[95:88]),
    .out(L2_m11_result)
);

wire [Width-1:0]L2_m12_result;
FixPointMultiplier m36(
    .data(L2_din12),
    .weight(weight_data[103:96]),
    .out(L2_m12_result)
);

wire [Width-1:0]L2_m13_result;
FixPointMultiplier m37(
    .data(L2_din13),
    .weight(weight_data[111:104]),
    .out(L2_m13_result)
);

wire [Width-1:0]L2_m14_result;
FixPointMultiplier m38(
    .data(L2_din14),
    .weight(weight_data[119:112]),
    .out(L2_m14_result)
);

wire [Width-1:0]L2_m15_result;
FixPointMultiplier m39(
    .data(L2_din15),
    .weight(weight_data[127:120]),
    .out(L2_m15_result)
);

// L2 adder Net
wire [Width:0] L2_adder_layer2_result0;
FixPointAdder#(
    .Width(15)
) a26(
    .dina(L2_m0_result),
    .dinb(L2_m1_result),
    .dout(L2_adder_layer2_result0)
);

wire [Width:0] L2_adder_layer2_result1;
FixPointAdder#(
    .Width(15)
) a27(
    .dina(L2_m2_result),
    .dinb(L2_m3_result),
    .dout(L2_adder_layer2_result1)
);

wire [Width:0] L2_adder_layer2_result2;
FixPointAdder#(
    .Width(15)
) a28(
    .dina(L2_m4_result),
    .dinb(L2_m5_result),
    .dout(L2_adder_layer2_result2)
);

wire [Width:0] L2_adder_layer2_result3;
FixPointAdder#(
    .Width(15)
) a29(
    .dina(L2_m6_result),
    .dinb(L2_m7_result),
    .dout(L2_adder_layer2_result3)
);

wire [Width:0] L2_adder_layer2_result4;
FixPointAdder#(
    .Width(15)
) a30(
    .dina(L2_m8_result),
    .dinb(L2_m9_result),
    .dout(L2_adder_layer2_result4)
);

wire [Width:0] L2_adder_layer2_result5;
FixPointAdder#(
    .Width(15)
) a31(
    .dina(L2_m10_result),
    .dinb(L2_m11_result),
    .dout(L2_adder_layer2_result5)
);

wire [Width:0] L2_adder_layer2_result6;
FixPointAdder#(
    .Width(15)
) a32(
    .dina(L2_m12_result),
    .dinb(L2_m13_result),
    .dout(L2_adder_layer2_result6)
);

wire [Width:0] L2_adder_layer2_result7;
FixPointAdder#(
    .Width(15)
) a33(
    .dina(L2_m14_result),
    .dinb(L2_m15_result),
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


wire [Width+3:0] L2_adder_layer5_result0;
FixPointAdder#(
    .Width(18)
) a40(
    .dina(L2_adder_layer4_result0),
    .dinb(L2_adder_layer4_result1),
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



//*************************L2_process*****************************//
reg [79:0]possible;

always@(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    possible <= 80'd0;
  end 
  else if(state == L2_PROCESS) begin
    possible <={Num_P,possible[79:8]};
  end
end
always@(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    Num_counter <= 4'd0;
  end
  else if(state == L2_PROCESS) begin
    if(Num_counter == 4'd9) begin
      Num_counter <= 4'd0;
    end
    else Num_counter <= Num_counter + 1'd1;
  end
end

assign L2_done = (state == L2_PROCESS && Num_counter == 4'd9) ? 1'd1 : 1'd0;

assign num_0 = possible[7:0];
assign num_1 = possible[15:8];
assign num_2 = possible[23:16];
assign num_3 = possible[31:24];
assign num_4 = possible[39:32];
assign num_5 = possible[47:40];
assign num_6 = possible[55:48];
assign num_7 = possible[63:56];
assign num_8 = possible[71:64];
assign num_9 = possible[79:72];

endmodule
