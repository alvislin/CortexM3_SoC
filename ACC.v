module ACC  (

    // SYSTEM SIGNALS
    input   wire            clk,
    input   wire            rstn,

    // HANDSHAKE
    input   wire            AccValid_i,
    output  wire            AccReady_o,

    // Input Data Signals
    output  wire    [5:0]   DataRamAddr_o,
    input   wire    [23:0]  DataRamData_i,

    // Input Weight Signals
    output  wire    [8:0]   WtRamAddr_o,
    input   wire    [191:0] WtRamData_i,

    // OUTPUT 
    output  wire    [7:0]   Num0_o,
    output  wire    [7:0]   Num1_o,
    output  wire    [7:0]   Num2_o,
    output  wire    [7:0]   Num3_o,
    output  wire    [7:0]   Num4_o,
    output  wire    [7:0]   Num5_o,
    output  wire    [7:0]   Num6_o,
    output  wire    [7:0]   Num7_o,
    output  wire    [7:0]   Num8_o,
    output  wire    [7:0]   Num9_o
);

wire            L1ConvValid;
wire            L1ConvReady;
wire            L2ConvValid;
wire            L2ConvReady;   
wire            FullConnValid;
wire            FullConnReady;

//-------------------------------------------
// FSM
//-------------------------------------------

parameter   idle    =   3'b000;
parameter   conv1   =   3'b001;
parameter   conv2   =   3'b010;
parameter   fullc   =   3'b011;
parameter   sdb     =   3'b100;

reg [2:0]   state_c,state_n;

always@(posedge clk or negedge rstn) begin
    if(~rstn)
        state_c <=  idle;
    else
        state_c <=  state_n;
end

always@(*) begin
    case(state_c)
        idle: begin 
            if(AccValid_i)
                state_n =   conv1;
            else
                state_n =   state_c;
        end conv1: begin
            if(L1ConvReady)
                state_n =   conv2;
            else
                state_n =   state_c;
        end conv2: begin
            if(L2ConvReady)
                state_n =   fullc;
            else
                state_n =   state_c;
        end fullc: begin
            if(FullConnReady)
                state_n =   sdb;
            else
                state_n =   state_c;
        end sdb: begin
            if(~AccValid_i)
                state_n =   idle;
            else
                state_n =   state_c;
        end
    endcase
end

assign  L1ConvValid     =   state_c ==  conv1;
assign  L2ConvValid     =   state_c ==  conv2;
assign  FullConnValid   =   state_c ==  fullc;
assign  AccReady_o      =   state_c ==  sdb;

//-------------------------------------------
// CONV LAYER
//-------------------------------------------

wire            OutChan0We; 
wire            OutChan1We;
wire            OutChan2We;
wire            OutChan3We;
wire            OutChan4We;
wire            OutChan5We;
wire            OutChan6We;
wire            OutChan7We;

wire    [3:0]   OutChanAddr;
wire    [47:0]  OutChanData;

wire    [8:0]   ConvWtRamAddr;

ConvLayer   Convolution(
    .clk                    (clk),
    .rstn                   (rstn),
    .L1ConvReady_o          (L1ConvReady),
    .L1ConvValid_i          (L1ConvValid),
    .L2ConvReady_o          (L2ConvReady),
    .L2ConvValid_i          (L2ConvValid),
    .DataRamAddr_o          (DataRamAddr_o),
    .DataRamData_i          (DataRamData_i),
    .WtRamAddr_o            (ConvWtRamAddr),
    .WtRamData_i            (WtRamData_i),
    .OutChan0We_o           (OutChan0We),  
    .OutChan1We_o           (OutChan1We),
    .OutChan2We_o           (OutChan2We),
    .OutChan3We_o           (OutChan3We),
    .OutChan4We_o           (OutChan4We),
    .OutChan5We_o           (OutChan5We),
    .OutChan6We_o           (OutChan6We),
    .OutChan7We_o           (OutChan7We),
    .OutChanAddr_o          (OutChanAddr),
    .OutChanData_o          (OutChanData)
);

//-------------------------------------------
// RAM
//-------------------------------------------

wire    [3:0]   InChanRdEn;
wire    [47:0]  InChan0Data;
wire    [47:0]  InChan1Data;
wire    [47:0]  InChan2Data;
wire    [47:0]  InChan3Data;
wire    [47:0]  InChan4Data;
wire    [47:0]  InChan5Data;
wire    [47:0]  InChan6Data;
wire    [47:0]  InChan7Data;

L2RAM Channel0 (
	.clock      (clk),
	.data       (OutChanData),
	.wraddress  (OutChanAddr),
	.rdaddress  (InChanRdEn),
	.wren       (OutChan0We),
	.q       	(InChan0Data)
);

L2RAM Channel1 (
	.clock      (clk),
	.data       (OutChanData),
	.wraddress  (OutChanAddr),
	.rdaddress  (InChanRdEn),
	.wren       (OutChan1We),
	.q       	(InChan1Data)
);

L2RAM Channel2 (
	.clock      (clk),
	.data       (OutChanData),
	.wraddress  (OutChanAddr),
	.rdaddress  (InChanRdEn),
	.wren       (OutChan2We),
	.q       	(InChan2Data)
);

L2RAM Channel3 (
	.clock      (clk),
	.data       (OutChanData),
	.wraddress  (OutChanAddr),
	.rdaddress  (InChanRdEn),
	.wren       (OutChan3We),
	.q       	(InChan3Data)
);

L2RAM Channel4 (
	.clock      (clk),
	.data       (OutChanData),
	.wraddress  (OutChanAddr),
	.rdaddress  (InChanRdEn),
	.wren       (OutChan4We),
	.q       	(InChan4Data)
);

L2RAM Channel5 (
	.clock      (clk),
	.data       (OutChanData),
	.wraddress  (OutChanAddr),
	.rdaddress  (InChanRdEn),
	.wren       (OutChan5We),
	.q       	(InChan5Data)
);

L2RAM Channel6 (
	.clock      (clk),
	.data       (OutChanData),
	.wraddress  (OutChanAddr),
	.rdaddress  (InChanRdEn),
	.wren       (OutChan6We),
	.q       	(InChan6Data)
);

L2RAM Channel7 (
	.clock      (clk),
	.data       (OutChanData),
	.wraddress  (OutChanAddr),
	.rdaddress  (InChanRdEn),
	.wren       (OutChan7We),
	.q       	(InChan7Data)
);

//-------------------------------------------
// Full Connect
//-------------------------------------------

wire     [7:0]   num0;
wire     [7:0]   num1;
wire     [7:0]   num2;
wire     [7:0]   num3;
wire     [7:0]   num4;
wire     [7:0]   num5;
wire     [7:0]   num6;
wire     [7:0]   num7;
wire     [7:0]   num8;
wire     [7:0]   num9;

wire    [8:0]  FullConnWtRamAddr;

Full_Connect_Layer FC(
    .clk                    (clk),
    .rst_n                  (rstn),
    .valid                  (FullConnValid),
    .ready                  (FullConnReady),
    .weight_data            (WtRamData_i),
    .weight_addr            (FullConnWtRamAddr),
    .second_layer_data_0    (InChan0Data),
    .second_layer_data_1    (InChan1Data),
    .second_layer_data_2    (InChan2Data),
    .second_layer_data_3    (InChan3Data),
    .second_layer_data_4    (InChan4Data),
    .second_layer_data_5    (InChan5Data),
    .second_layer_data_6    (InChan6Data),
    .second_layer_data_7    (InChan7Data),
    .data_addr              (InChanRdEn),
    .num_0                  (num0),
    .num_1                  (num1),
    .num_2                  (num2),
    .num_3                  (num3),
    .num_4                  (num4),
    .num_5                  (num5),
    .num_6                  (num6),
    .num_7                  (num7),
    .num_8                  (num8),
    .num_9                  (num9)
);


assign  WtRamAddr_o   =   state_c    ==  fullc    ?   FullConnWtRamAddr    :   ConvWtRamAddr;

reg      [7:0]   num0_reg;
reg      [7:0]   num1_reg;
reg      [7:0]   num2_reg;
reg      [7:0]   num3_reg;
reg      [7:0]   num4_reg;
reg      [7:0]   num5_reg;
reg      [7:0]   num6_reg;
reg      [7:0]   num7_reg;
reg      [7:0]   num8_reg;
reg      [7:0]   num9_reg;


always@(posedge clk or negedge rstn) begin
    if(~rstn) begin
        num0_reg    <=  8'b0;
        num1_reg    <=  8'b0;
        num2_reg    <=  8'b0;
        num3_reg    <=  8'b0;
        num4_reg    <=  8'b0;
        num5_reg    <=  8'b0;
        num6_reg    <=  8'b0;
        num7_reg    <=  8'b0;
        num8_reg    <=  8'b0;
        num9_reg    <=  8'b0;
    end else if(FullConnValid & FullConnReady) begin
        num0_reg    <=  num0;
        num1_reg    <=  num1;
        num2_reg    <=  num2;
        num3_reg    <=  num3;
        num4_reg    <=  num4;
        num5_reg    <=  num5;
        num6_reg    <=  num6;
        num7_reg    <=  num7;
        num8_reg    <=  num8;
        num9_reg    <=  num9;
    end
end        

assign Num0_o   =   num0_reg;
assign Num1_o   =   num1_reg;
assign Num2_o   =   num2_reg;
assign Num3_o   =   num3_reg;
assign Num4_o   =   num4_reg;
assign Num5_o   =   num5_reg;
assign Num6_o   =   num6_reg;
assign Num7_o   =   num7_reg;
assign Num8_o   =   num8_reg;
assign Num9_o   =   num9_reg;

endmodule