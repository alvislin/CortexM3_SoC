module DMA(
    input   wire                HCLK,
    input   wire                HRESETn,
    output  wire    [31:0]      HADDRD, 
    output  wire    [1:0]       HTRANSD, 
    output  wire    [2:0]       HSIZED, 
    output  wire    [2:0]       HBURSTD, 
    output  wire    [3:0]       HPROTD, 
    output  wire                HWRITED, 
    output  wire    [31:0]      HWDATAD, 
    input   wire    [31:0]      HRDATAD,
    input   wire                HREADYD,
    input   wire    [1:0]       HRESPD,
    input   wire                DMAstart,
    output  wire                DMAdone,
    input   wire    [31:0]      DMAsrc,
    input   wire    [31:0]      DMAdst,
    input   wire    [1:0]       DMAsize,
    input   wire    [31:0]      DMAlen
);

//--------------------------------------------------------------
//  FIFO 
//--------------------------------------------------------------

wire        FifoRdEn;
wire        FifoWrEn;
wire        FifoFull;
wire        FifoEmpty;
reg  [31:0] FifoWrData;
wire [31:0] FifoRdData;

FIFO FIFO(
    .clock      (HCLK),
    .sclr       (HRESETn),
    .rdreq      (FifoRdEn),
    .wrreq      (FifoWrEn),
    .full       (FifoFull),
    .empty      (FifoEmpty),
    .data       (FifoWrData),
    .q          (FifoRdData)
);

//--------------------------------------------------------------
//  FSM
//--------------------------------------------------------------

localparam      IDLE    =   3'b001;   
localparam      READ    =   3'b010;
localparam      WRITE   =   3'b100;

reg     [2:0]   StateCr;
wire    [2:0]   StateNxt;

always@(posedge HCLK or negedge HRESETn) begin
    if(~HRESETn)
        StateCr <=  IDLE;
    else
        StateCr <=  StateNxt;
end

//--------------------------------------------------------------
//  FSM TRANS
//--------------------------------------------------------------

wire    ChanDone;

assign  StateNxt    =   StateCr[0]  &   DMAstart    ?   READ    :   (
                        StateCr[1]  &   ChanDone    ?   WRITE   :   (
                        StateCr[2]  &   DMAdone     ?   IDLE    :   (
                        StateCr[2]  &   ChanDone    ?   READ    :   StateCr)));       

//--------------------------------------------------------------
//  DMA Initial
//--------------------------------------------------------------

wire    DmaIniEn;

assign  DmaIniEn    =   StateCr[0]  &   DMAstart;

reg     [1:0]   Size;
wire    [2:0]   SizeDec;
reg     [31:0]  SrcEnd;
wire    [31:0]  SrcEndNxt;
reg     [31:0]  DstEnd;
wire    [31:0]  DstEndNxt;
wire    [31:0]  Len;

assign  Len         =   (DMAlen - 1'b1) <<  DMAsize;

assign  SrcEndNxt   =   DMAsrc + Len;

assign  DstEndNxt   =   DMAdst + Len;

always@(posedge HCLK or negedge HRESETn) begin
    if(~HRESETn) begin
        Size    <=  2'b0;
        SrcEnd  <=  32'b0;
        DstEnd  <=  32'b0; 
    end else if(DmaIniEn) begin
        Size    <=  DMAsize;
        SrcEnd  <=  SrcEndNxt;
        DstEnd  <=  DstEndNxt;
    end
end

assign SizeDec  = (Size == 2'b00) ? 3'b001 : (
                  (Size == 2'b01) ? 3'b010 : (
                  (Size == 2'b10) ? 3'b100 : 3'b000));     

//--------------------------------------------------------------
//  CHANNEL COUNTER
//--------------------------------------------------------------

reg     [3:0]   ChanCnt;
wire    [3:0]   ChanCntNxt;

assign  ChanDone    =   ChanCnt ==  4'hf;

assign  ChanCntNxt  =   ChanDone                ?   4'h0            :   (
                        StateCr[0]              ?   4'h0            :   (
                        ~HREADYD                ?   ChanCnt         :   (
                        StateCr[1] | StateCr[2] ?  ChanCnt + 1'b1   :   ChanCnt)));

always@(posedge HCLK or negedge HRESETn) begin
    if(~HRESETn) 
        ChanCnt <=  4'h0;
    else
        ChanCnt <=  ChanCntNxt;
end

//--------------------------------------------------------------
//  READ ADDRESS CAL
//--------------------------------------------------------------

reg     [31:0]  RdAddr;
wire            RdAddrEn;
wire    [31:0]  RdAddrNxt;

assign  RdAddrEn    =   HREADYD &   StateCr[1];

assign  RdAddrNxt   =   DmaIniEn    ?   DMAsrc              :   (
                        StateCr[0]  ?   32'b0               :   (
                        RdAddrEn    ?   RdAddr + SizeDec    :   RdAddr));

always@(posedge HCLK or negedge HRESETn) begin
    if(~HRESETn)
        RdAddr  <=  32'b0;
    else 
        RdAddr  <=  RdAddrNxt;
end

//--------------------------------------------------------------
//  WRITE ADDRESS CAL
//--------------------------------------------------------------

reg     [31:0]  WrAddr;
wire            WrAddrEn;
wire    [31:0]  WrAddrNxt;

assign  DMAdone     =   StateCr[2]  &   WrAddr  ==  DstEnd;

assign  WrAddrEn    =   HREADYD &   StateCr[2];

assign  WrAddrNxt   =   DmaIniEn    ?   DMAdst              :   (
                        StateCr[0]  ?   32'b0               :   (
                        WrAddrEn    ?   WrAddr + SizeDec    :   WrAddr));

always@(posedge HCLK or negedge HRESETn) begin
    if(~HRESETn)
        WrAddr  <=  32'b0;
    else 
        WrAddr  <=  WrAddrNxt;
end

//--------------------------------------------------------------
//  FIFO CONTROL
//--------------------------------------------------------------

reg     RdEn;
reg     WrEn;

always@(posedge HCLK or negedge HRESETn) begin
    if(~HRESETn) begin
        RdEn    <=  1'b0;
        WrEn    <=  1'b0;
    end else begin
        RdEn    <=  StateCr[1];
        WrEn    <=  StateCr[2];
    end
end

assign  FifoWrEn    =   HREADYD &   ~FifoFull   &   RdEn;
assign  FifoRdEn    =   StateCr[0]  ?   ~FifoEmpty  :   WrEn & HREADYD;  

reg     [31:0]    RdAddrReg;

always@(posedge HCLK or negedge HRESETn) begin
    if(~HRESETn) 
        RdAddrReg   <=  32'b0;
    else if(HREADYD)
        RdAddrReg   <=  RdAddr;
end

always@(*) begin
    case(Size)
        2'b00 : begin
            case(RdAddrReg[1:0])
                2'b00 : FifoWrData  =   {4{HRDATAD[7:0]}};
                2'b01 : FifoWrData  =   {4{HRDATAD[15:8]}};
                2'b10 : FifoWrData  =   {4{HRDATAD[23:16]}};
                2'b11 : FifoWrData  =   {4{HRDATAD[31:24]}};
            endcase
        end 2'b01 : begin
            case(RdAddrReg[1])
                1'b0 : FifoWrData   =   {2{HRDATAD[15:0]}};
                1'b1 : FifoWrData   =   {2{HRDATAD[31:16]}};
            endcase
        end 2'b10 : begin
            FifoWrData  =   HRDATAD;
        end default : begin
            FifoWrData  =   32'b0;
        end
    endcase
end

//--------------------------------------------------------------
//  BUS SIGNALS
//--------------------------------------------------------------

assign HPROTD   =   4'b0011;
assign HBURSTD  =   3'b000;
assign HSIZED   =   {1'b0,Size};
assign HTRANSD  =   StateCr[1] | StateCr[2]   ?   2'b10   :   2'b00;
assign HADDRD   =   ({32{StateCr[1]}}   &   RdAddr) |
                    ({32{StateCr[2]}}   &   WrAddr) ;
assign HWDATAD  =   FifoRdData; 
assign HWRITED  =   StateCr[2];

endmodule