module L1FullCtrl #(
    parameter weight_Start_addr = 27,
    parameter Width = 15,
    parameter L1_process_num = 25,
    parameter neu_num = 15
)(
    input clk,
    input rst_n,
    // ready valid
    input  valid,
    output wire ready,

    input mac_ready,                    // addself ready

    output bias_valid,                  // the sign that is add bias
    input bias_ready,                  //the sign that was added bias 

    input [7:0] Al_result,

    output wire [8:0] weight_addr,

    //Data ram surface
    output wire [3:0] data_addr, 

    // ram ready
    output wire data_valid,

    // data sel
    output wire data_sel,

    // bias sel 
    output wire[3:0] bias_sel,


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


//*********************************************FSM************************************************//

localparam IDLE = 3'b001;
localparam PROCESS = 3'b010;
localparam SDB = 3'b100;

reg [2:0] state;
reg [2:0] state_nxt;

wire L1_done;

always@(posedge clk or negedge rst_n) begin
  if(!rst_n)  state <= IDLE;
  else state<=state_nxt;
end

always@(*) begin
  case(state)
  IDLE:begin
    if(valid) state_nxt <= PROCESS;
    else state_nxt <=state;
  end
 
  PROCESS:begin
   if(L1_done) state_nxt <= SDB;
   else state_nxt <= state;
  end

  SDB : begin
    if(!valid) state_nxt <= IDLE;
    else state_nxt <= state;
  end
  endcase
end


//****************************************Process************************************//

reg[4:0] pipe_counter;
reg pipe_run;

always@(posedge clk or negedge rst_n) begin
  if(~rst_n) begin
    pipe_counter <= 5'd0;
    pipe_run <= 1'd1;
  end
  else if(bias_ready && state == PROCESS) begin
    pipe_run <= 1'd1;
    pipe_counter <= 5'd0;
  end
  else if(state == PROCESS && pipe_run) begin
    if(pipe_counter == L1_process_num) pipe_run <= 1'd0;
    else pipe_counter <= pipe_counter + 1'd1;
  end
end


//****************************address******************************//
reg [8:0] w_addr;
reg [3:0] d_addr;
reg use_w_counter;

always@(posedge clk or negedge rst_n) begin
  if(~rst_n) begin
    w_addr <= weight_Start_addr;
  end
  else if(pipe_run  && state == PROCESS) begin
    w_addr <= w_addr + 1'd1;
  end
  else if(state == IDLE) begin
    w_addr <= weight_Start_addr;
  end
end

always@(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    use_w_counter <= 1'd0;
  end
  else if(pipe_run  && state == PROCESS) begin
    use_w_counter <= use_w_counter + 1'd1;
  end
  else use_w_counter <= 1'd0;
end

always@(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    d_addr <=5'd0; 
  end
  else if(pipe_run && use_w_counter == 1'd1) begin
    if(d_addr == 5'd12)  d_addr <= 'd0;
    else d_addr <= d_addr + 1'd1;
  end
  else if(pipe_run && use_w_counter == 1'd0) begin
    d_addr <= d_addr;
  end
  else d_addr <= 5'd0;
end

wire ram_valid;
reg ram_valid_r;
assign ram_valid = (pipe_run  && state == PROCESS);

always@(posedge clk or negedge rst_n) begin
  if(~rst_n) begin
    ram_valid_r <= 0;
  end
  else ram_valid_r <= ram_valid;
end

assign data_valid = ram_valid_r;
//*****************************mac_counter*****************************************//
reg [4:0] mac_counter;

always@(posedge clk or negedge rst_n) begin
  if(~rst_n) begin
    mac_counter <= 'd0;
  end
  else if(state == PROCESS && mac_ready) begin
    if(mac_counter == L1_process_num ) mac_counter<= 'd0;
    else mac_counter <= mac_counter + 1'd1;
  end
  else if(state != PROCESS) begin
    mac_counter <= 'd0;
  end
end

reg bias_valid_r;

always@(posedge clk or negedge rst_n) begin
  if(~rst_n)  bias_valid_r<= 0;
  else if(mac_counter == L1_process_num)  bias_valid_r <= 1;
  else bias_valid_r <= 0;
end

assign bias_valid = (mac_counter == L1_process_num)  ;
//******************************neu_counter******************************************//
reg [3:0] neu_counter;
always@(posedge clk or negedge rst_n) begin
  if(~rst_n) begin
    neu_counter <= 'd0;
  end
  else if(state == PROCESS && bias_ready) begin
    neu_counter <= neu_counter + 1'd1;
  end
  else if(state != PROCESS) begin
    neu_counter <= 'd0;
  end
end

assign bias_sel = neu_counter;

reg [127:0] L1_result;

always@(posedge clk or negedge rst_n) begin
  if(!rst_n ) begin
    L1_result <= 128'd0;
  end
  else if(state == PROCESS && bias_ready) begin
    L1_result <= {Al_result,L1_result[127:8]};
  end
  else if(state == IDLE) begin
    L1_result <= 128'd0;
  end
end  

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

assign L1_done = (neu_counter == neu_num && bias_ready);

assign weight_addr = w_addr;
assign data_addr = d_addr;
assign data_sel = use_w_counter;
assign ready = (state == SDB);

endmodule