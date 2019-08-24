module AHBlite_BusMatrix_Outputstage_ACCC(
    input   HCLK,
    input   HRESETn,

    input   HSEL_SYS,
    input   [31:0]  HADDR_SYS,
    input   [1:0]   HTRANS_SYS,
    input   HWRITE_SYS,
    input   [2:0]   HSIZE_SYS,
    input   [2:0]   HBURST_SYS,
    input   [3:0]   HPROT_SYS,
    input   [31:0]  HWDATA_SYS,
    input           TRANS_HOLD_SYS,

    input   HSEL_DMA,
    input   [31:0]  HADDR_DMA,
    input   [1:0]   HTRANS_DMA,
    input   HWRITE_DMA,
    input   [2:0]   HSIZE_DMA,
    input   [2:0]   HBURST_DMA,
    input   [3:0]   HPROT_DMA,
    input   [31:0]  HWDATA_DMA,
    input           TRANS_HOLD_DMA,

    input   HREADYOUT,

    output  wire    ACTIVE_SYS,
    output  wire    ACTIVE_DMA,

    output  wire    HSEL,
    output  wire    [31:0]  HADDR,
    output  wire    [1:0]   HTRANS,
    output  wire    HWRITE,
    output  wire    [2:0]   HSIZE,
    output  wire    [2:0]   HBURST,
    output  wire    [3:0]   HPROT,
    output  wire    HREADY,
    output  wire    [31:0]  HWDATA
);

wire    REQ_SYS;
wire    REQ_DMA;

assign  REQ_SYS     =   TRANS_HOLD_SYS      &   HSEL_SYS;
assign  REQ_DMA     =   TRANS_HOLD_DMA      &   HSEL_DMA;

wire    noport;
wire    [1:0]   selport;

AHBlite_BusMatrix_Arbiter_ACCC   accc_arb(
    .HCLK       (HCLK),
    .HRESETn    (HRESETn),
    .REQ_SYS    (REQ_SYS),
    .REQ_DMA    (REQ_DMA),
    .HREADY_Outputstage_ACCC (HREADY),
    .HSEL_Outputstage_ACCC   (HSEL),
    .HTRANS_Outputstage_ACCC (HTRANS),
    .HBURST_Outputstage_ACCC (HBURST),
    .PORT_SEL_ARBITER_ACCC   (selport),
    .PORT_NOSEL_ARBITER_ACCC (noport)
);

assign  ACTIVE_SYS    =   (~noport)   &   (selport    ==  2'b01);
assign  ACTIVE_DMA    =   (~noport)   &   (selport    ==  2'b10);     

assign  HSEL    =   noport  ?   1'b0    :
                    ((selport   ==  2'b01)  ?   HSEL_SYS  :
                    ((selport   ==  2'b10)  ?   HSEL_DMA  :     1'b0));

assign  HADDR   =   noport  ?   32'b0    :
                    ((selport   ==  2'b01)  ?   HADDR_SYS  :
                    ((selport   ==  2'b10)  ?   HADDR_DMA  :    32'b0));

assign  HTRANS  =   noport  ?   2'b0    :
                    ((selport   ==  2'b01)  ?   HTRANS_SYS  :
                    ((selport   ==  2'b10)  ?   HTRANS_DMA  :   2'b0));               

assign  HWRITE  =   noport  ?   1'b0    :
                    ((selport   ==  2'b01)  ?   HWRITE_SYS  :
                    ((selport   ==  2'b10)  ?   HWRITE_DMA  :   1'b0));

assign  HSIZE   =    noport  ?   3'b0    :
                    ((selport   ==  2'b01)  ?   HSIZE_SYS  :
                    ((selport   ==  2'b10)  ?   HSIZE_DMA  :    3'b0));      

assign  HBURST  =   noport  ?   3'b0    :
                    ((selport   ==  2'b01)  ?   HBURST_SYS  :
                    ((selport   ==  2'b10)  ?   HBURST_DMA  :   3'b0));

assign  HPROT   =   noport  ?   4'b0    :
                    ((selport   ==  2'b01)  ?   HPROT_SYS   :
                    ((selport   ==  2'b10)  ?   HPROT_DMA   :   4'b0));                                                        

reg trans_state;

assign  HREADY  =   trans_state ?   HREADYOUT   :   1'b1;

always@(posedge HCLK or negedge HRESETn) begin
    if(~HRESETn)    trans_state <=  1'b0;
    else if(HREADY) trans_state <=  HSEL;
end

reg [1:0] selport_data;

always@(posedge HCLK or negedge HRESETn) begin
    if(~HRESETn)    selport_data <=  2'b0;
    else if(HREADY) selport_data <=  selport;
end

assign  HWDATA  =   (selport_data   ==  2'b01)  ?   HWDATA_SYS    :     (
                    (selport_data   ==  2'b10)  ?   HWDATA_DMA    :     32'b0);

endmodule