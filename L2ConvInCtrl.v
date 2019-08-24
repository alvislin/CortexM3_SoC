module L2ConvInCtrl (
    input   wire            clk,
    input   wire            rstn,

    input   wire            ConvValid_i,

    output  wire    [4:0]   DataRamAddr_o,
    output  wire    [8:0]   WtRamAddr_o,
    output  wire            WtBufEn_o,
    output  wire            InBufEn_o,
    output  wire            InBufZero_o,
    output  wire            WinMuxZero_o,
    output  wire    [3:0]   ConvWinCnt,
    output  wire            ConvSel,

    output  wire            vbit_o
);
wire    WorkDone;
wire    WorkFinish;
wire    IBIniDone;

/********************************************************/
/*******************   TOP FSM    ***********************/
/********************************************************/

parameter   top_Idle    =   2'b00;
parameter   top_IBIni   =   2'b01;
parameter   top_Work    =   2'b10;
parameter   top_Sdb     =   2'b11;

reg [1:0]   top_state,top_state_nxt;

always@(posedge clk or negedge rstn) begin
    if(~rstn)
        top_state   <=  top_Idle;
    else
        top_state   <=  top_state_nxt;
end

always@(*) begin
    case(top_state)
        top_Idle : begin
            if(ConvValid_i)
                top_state_nxt   =   top_IBIni;
            else
                top_state_nxt   =   top_state;
        end top_IBIni : begin
            if(IBIniDone)
                top_state_nxt   =   top_Work;
            else
                top_state_nxt   =   top_state;
        end top_Work : begin
            if(WorkFinish)
                top_state_nxt   =   top_Sdb;
            else if(WorkDone)
                top_state_nxt   =   top_IBIni;
            else
                top_state_nxt   =   top_state;
        end top_Sdb : begin
            if(~ConvValid_i)
                top_state_nxt   =   top_Idle;
            else
                top_state_nxt   =   top_state;
        end
    endcase
end

/********************************************************/
/*******************   IBINICTRL  ***********************/
/********************************************************/

reg     [1:0]   IBIniCnt;
wire    [1:0]   IBIniCnt_nxt;
wire            IBIniActive;

assign IBIniActive  =   top_state == top_IBIni;

assign IBIniDone    =   IBIniCnt == 2'b10;

assign IBIniCnt_nxt =   ~IBIniActive    ?   2'b00   :   (
                        IBIniDone       ?   2'b00   :   IBIniCnt + 1'b1);

always@(posedge clk or negedge rstn) begin
    if(~rstn)
        IBIniCnt    <=  2'b0;
    else 
        IBIniCnt    <=  IBIniCnt_nxt;
end

reg             IB_en;

always@(posedge clk or negedge rstn) begin  
    if(~rstn)
        IB_en   <=  1'b0;
    else 
        IB_en   <=  IBIniActive &   (~IBIniCnt[1]);
end

/********************************************************/
/*******************   WORK       ***********************/
/********************************************************/

wire    Work_Active;

assign  Work_Active     =   top_state == top_Work;

//------------------------------------------------------
// CONV WINDOW COUNTER
//------------------------------------------------------


reg     [3:0]   windowcnt;
wire    [3:0]   windowcnt_nxt;
wire            Line_done;

assign  Line_done       =   windowcnt == 4'd11;
assign  windowcnt_nxt   =   ~Work_Active    ?   4'b0    :   (
                            Line_done       ?   4'b0    :   windowcnt + 1'b1);
always@(posedge clk or negedge rstn) begin
    if(~rstn)
        windowcnt   <=  4'b0;
    else
        windowcnt   <=  windowcnt_nxt;
end

//------------------------------------------------------
// INPUT DATA ADDR CONTROL
//------------------------------------------------------

reg     [4:0]   data_addr;
reg     [4:0]   data_addr_nxt;
wire            Line_Almost_done;
wire            last_line;

assign  last_line               =   data_addr == 5'd26;
assign  Line_Almost_done        =   windowcnt == 5'd10;
assign  WorkDone    =   Work_Active     &   Line_done   &   last_line;

always@(*) begin
    if(IBIniActive) begin
        if(~IBIniCnt[1] & IBIniCnt[0])
            data_addr_nxt       =   data_addr   +   1'b1;
        else if(~IBIniCnt[1] & ~IBIniCnt[0])
            data_addr_nxt       =   5'b0;
        else
            data_addr_nxt       =   data_addr;
    end else if(Work_Active) begin
        if(Line_Almost_done) begin
            if(~last_line) 
                data_addr_nxt   =   data_addr   +   1'b1;
            else
                data_addr_nxt   =   5'b0;
        end else
            data_addr_nxt       =   data_addr;
    end else
        data_addr_nxt           =   5'b0;
end

always@(posedge clk or negedge rstn) begin
    if(~rstn)
        data_addr   <=  5'b0;
    else
        data_addr   <=  data_addr_nxt;
end

//--------------------------------------------------------
//  OUTPUT WEIGHT ADDR CONTROL
//--------------------------------------------------------

reg     [8:0]   weight_addr;
reg     [8:0]   weight_addr_nxt;

always@(*) begin
    if((top_state == top_Idle) || (top_state == top_Sdb))
        weight_addr_nxt             =   9'h3;
    else begin
        if(IBIniActive) begin
            if(IBIniCnt[1])
                weight_addr_nxt     =   weight_addr;
            else
                weight_addr_nxt     =   weight_addr +   1'b1;
        end else if(Work_Active) 
            if(WorkDone)
                weight_addr_nxt     =   weight_addr +   1'b1;
            else
                weight_addr_nxt         =   weight_addr;
        else
            weight_addr_nxt         =   weight_addr;
    end
end

always@(posedge clk or negedge rstn) begin
    if(~rstn)
        weight_addr   <=  9'h3;
    else
        weight_addr   <=  weight_addr_nxt;
end


//--------------------------------------------------------
//  CONV CHANNEL COUNTER
//--------------------------------------------------------

reg     [2:0]   TOTAL_CNT;

always@(posedge clk or negedge rstn) begin
    if(~rstn)
        TOTAL_CNT   <=  3'b0;
    else if((top_state == top_Idle) || (top_state == top_Sdb))
        TOTAL_CNT   <=  3'b0;
    else if(WorkDone)
        TOTAL_CNT   <=  TOTAL_CNT + 1'b1;
end

assign  WorkFinish  =   WorkDone   &   (TOTAL_CNT    ==  3'b111);

//--------------------------------------------------------
//  Last Line Window Zero for Padding
//--------------------------------------------------------

reg    WinMuxZero_o_reg;

always@(posedge clk or negedge rstn) begin
    if(~rstn)
        WinMuxZero_o_reg <=  1'b0;
    else
        WinMuxZero_o_reg <=  data_addr == 5'd25;
end

//--------------------------------------------------------
//  OUTPUT 
//--------------------------------------------------------

assign ConvWinCnt       =   windowcnt;
assign DataRamAddr_o    =   data_addr;
assign WtBufEn_o        =   IB_en;
assign InBufEn_o        =   IB_en    |   (Line_done & ~WorkDone);
assign WtRamAddr_o      =   weight_addr;    
assign ConvSel          =    ~(top_state == top_Idle);
assign InBufZero_o      =   ~IBIniCnt[1] & IBIniCnt[0] & IB_en;
assign WinMuxZero_o     =   WinMuxZero_o_reg;
assign vbit_o           =   Work_Active;

endmodule

