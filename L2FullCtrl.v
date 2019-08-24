module L2FullCtrl #(
    parameter weight_Start_addr = 443,
    parameter Width = 15,
    parameter out_num = 10 - 1
)(
    input clk,
    input rst_n,
    // ready valid
    input  valid,
    output wire ready,

    input cal_ready,                    // DATA ready
    output [3:0] L2_bias_sel,

    output wire [8:0] weight_addr,
  //  input wire [191:0] weight_data,
    output wire data_valid,
    input wire [7:0] L2_result,

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


//*********************************************FSM************************************************//

localparam IDLE = 3'b001;
localparam PROCESS = 3'b010;
localparam SDB = 3'b100;

reg [2:0] state;
reg [2:0] state_nxt;
wire L2_done;

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
   if(L2_done) state_nxt <= SDB;
   else state_nxt <= state;
  end

  SDB : begin
    if(!valid) state_nxt <= IDLE;
    else state_nxt <= state;
  end
  endcase
end

assign ready = (state == SDB);
//****************************address******************************//
reg [3:0] addr_counter;

always@(posedge clk or negedge rst_n) begin
  if(~rst_n) begin
    addr_counter <= 0;
  end
  else if(state == PROCESS && addr_counter< (out_num + 1'd1)) begin
    addr_counter <= addr_counter + 1'd1;
  end
  else if(state == IDLE) begin
    addr_counter <= 0;
  end
end

reg [8:0] w_addr;

always@(posedge clk or negedge rst_n) begin
  if(~rst_n) begin
    w_addr <= weight_Start_addr;
  end
  else if(state == PROCESS && addr_counter < (out_num + 1'd1)) begin
    w_addr <= w_addr + 1'd1;
  end
  else if(state == IDLE) begin
    w_addr <= weight_Start_addr;
  end
end

assign weight_addr = w_addr;

wire ram_valid;
reg ram_valid_r;
assign ram_valid = (state == PROCESS && addr_counter < (out_num + 1'd1));

always@(posedge clk or negedge rst_n) begin
  if(~rst_n) begin
    ram_valid_r <= 0;
  end
  else ram_valid_r <= ram_valid;
end

assign data_valid = ram_valid_r;
//****************************************PROCESS********************************************//
reg [3:0] Num_counter;

always@(posedge clk or negedge rst_n) begin
  if(!rst_n)  begin
    Num_counter <= 4'd0;
  end
  else if(state == PROCESS && cal_ready) begin
    Num_counter <= Num_counter + 1'd1;
  end
  else if(state == IDLE) begin
    Num_counter <= 0;
  end
end

assign L2_done = (Num_counter == out_num && cal_ready);

reg [79:0]possible;
always@(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    possible <= 80'd0;
  end 
  else if(state == PROCESS && cal_ready) begin
    possible <={L2_result,possible[79:8]};
  end
  else if(state == IDLE) begin
    possible <= 0;
  end
end

assign L2_bias_sel = Num_counter;
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
