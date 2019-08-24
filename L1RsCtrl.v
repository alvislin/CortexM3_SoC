module L1RsCtrl (
    input   wire            clk,
    input   wire            rstn,

    input   wire            ConvValid_i,
    input   wire            vbit_i,

    output  wire    [4:0]   PoolLineSel_o,
    output  wire            PoolLine0We_o,
    output  wire            PoolLine1We_o,

    output  wire            vbit_o

);

//--------------------------------------------------
//  LINE CNT
//--------------------------------------------------

reg     [4:0]   LineCnt;
wire    [4:0]   LineCntNxt;
wire            LineDone;

assign  LineDone    =   LineCnt ==  5'd23;

assign  LineCntNxt  =   ~ConvValid_i    ?   5'b0    :   (
                        ~vbit_i         ?   LineCnt :   (
                        LineDone        ?   5'b0    :   LineCnt +   1'b1));

always@(posedge clk or negedge rstn) begin
    if(~rstn)
        LineCnt <=  5'b0;
    else
        LineCnt <=  LineCntNxt; 
end

//--------------------------------------------------
//  ROW CNT
//--------------------------------------------------

reg     [5:0]   RowCnt;
wire    [5:0]   RowCntNxt;
wire            RowDone;

assign  RowDone    =   RowCnt ==  6'd51;

assign  RowCntNxt  =    ~ConvValid_i    ?   5'b0    :   (
                        ~vbit_i         ?   RowCnt  :   (
                        ~LineDone       ?   RowCnt  :   RowCnt +   1'b1));

always@(posedge clk or negedge rstn) begin
    if(~rstn)
        RowCnt <=  5'b0;
    else
        RowCnt <=  RowCntNxt; 
end

//--------------------------------------------------
// LINE STATE FOR REGSPLICE SEL
//--------------------------------------------------

reg     LineState;
wire    LineStateNxt;

assign  LineStateNxt    =   ~ConvValid_i    ?   1'b0        :   (
                            LineDone        ?   ~LineState  :   LineState);

always@(posedge clk or negedge rstn) begin
    if(~rstn)
        LineState  <=  1'b0;
    else
        LineState  <=  LineStateNxt;
end

//--------------------------------------------------
//  VBIT OUTPUT
//--------------------------------------------------

reg     VbitReg;
wire    VbitRegNxt;

assign  VbitRegNxt  =   vbit_i          &
                        LineDone        &
                        (LineState  |   RowDone);                               

always@(posedge clk or negedge rstn) begin
    if(~rstn)
        VbitReg   <=  1'b0;
    else
        VbitReg   <=  VbitRegNxt;
end

//--------------------------------------------------------
//  OUTPUT 
//--------------------------------------------------------

assign PoolLineSel_o        =   LineCnt;
assign PoolLine0We_o        =   ConvValid_i &   vbit_i  &   ~LineState;
assign PoolLine1We_o        =   ConvValid_i &   vbit_i  &   LineState;
assign vbit_o               =   VbitReg;

endmodule