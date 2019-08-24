module L2BiasMuxCtrl (
    input   wire            clk,
    input   wire            rstn,

    input   wire            ConvValid_i,
    input   wire            vbit_i,

    output  wire    [2:0]   BiasSel_o
);

//--------------------------------------------------
//  LINE CNT
//--------------------------------------------------

reg     [3:0]   LineCnt;
wire    [3:0]   LineCntNxt;
wire            LineDone;

assign  LineDone    =   LineCnt ==  4'd11;

assign  LineCntNxt  =   ~ConvValid_i    ?   4'b0    :   (
                        ~vbit_i         ?   LineCnt :   (
                        LineDone        ?   4'b0    :   LineCnt +   1'b1));

always@(posedge clk or negedge rstn) begin
    if(~rstn)
        LineCnt <=  4'b0;
    else
        LineCnt <=  LineCntNxt; 
end

//--------------------------------------------------
//  ROW CNT
//--------------------------------------------------

reg     [4:0]   RowCnt;
wire    [4:0]   RowCntNxt;
wire            RowDone;

assign  RowDone    =   RowCnt ==  5'd24;

assign  RowCntNxt  =    ~ConvValid_i    ?   5'b0    :   (
                        ~vbit_i         ?   RowCnt  :   (
                        ~LineDone       ?   RowCnt  :
                        RowDone         ?   5'b0    :   RowCnt +   1'b1));

always@(posedge clk or negedge rstn) begin
    if(~rstn)
        RowCnt <=  5'b0;
    else
        RowCnt <=  RowCntNxt; 
end

//--------------------------------------------------
//  ROW CNT
//--------------------------------------------------

reg     [2:0]   ChanCnt;
wire    [2:0]   ChanCntNxt;

assign  ChanCntNxt  =   ~ConvValid_i    ?   3'b0    :   (
                        ~vbit_i         ?   ChanCnt :   (
                        ~LineDone       ?   ChanCnt :   (
                        ~RowDone        ?   ChanCnt :   ChanCnt +   1'b1)));

always@(posedge clk or negedge rstn) begin
    if(~rstn)
        ChanCnt <=  3'b0;
    else
        ChanCnt <=  ChanCntNxt; 
end

//--------------------------------------------------------
//  OUTPUT 
//--------------------------------------------------------

assign  BiasSel_o =   ChanCnt;


endmodule