module AHBlite_BusMatrix_Outputstage_DTCM(
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

    input   HSEL_ACC,
    input   [31:0]  HADDR_ACC,
    input   [1:0]   HTRANS_ACC,
    input   HWRITE_ACC,
    input   [2:0]   HSIZE_ACC,
    input   [2:0]   HBURST_ACC,
    input   [3:0]   HPROT_ACC,
    input   [31:0]  HWDATA_ACC,
    input           TRANS_HOLD_ACC,

    input   HREADYOUT,

    output  wire    ACTIVE_SYS,
    output  wire    ACTIVE_DMA,
    output  wire    ACTIVE_ACC,

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
wire    REQ_ACC;

assign  REQ_SYS     =   TRANS_HOLD_SYS      &   HSEL_SYS;
assign  REQ_DMA     =   TRANS_HOLD_DMA      &   HSEL_DMA;
assign  REQ_ACC     =   TRANS_HOLD_ACC      &   HSEL_ACC;

wire    noport;
wire    [1:0]   selport;

AHBlite_BusMatrix_Arbiter_DTCM   DTCM_arb(
    .HCLK       (HCLK),
    .HRESETn    (HRESETn),
    .REQ_SYS    (REQ_SYS),
    .REQ_DMA    (REQ_DMA),
    .REQ_ACC    (REQ_ACC),
    .HREADY_Outputstage_DTCM (HREADY),
    .HSEL_Outputstage_DTCM   (HSEL),
    .HTRANS_Outputstage_DTCM (HTRANS),
    .HBURST_Outputstage_DTCM (HBURST),
    .PORT_SEL_ARBITER_DTCM   (selport),
    .PORT_NOSEL_ARBITER_DTCM (noport)
);

assign  ACTIVE_SYS    =   (~noport)   &   (selport    ==  2'b01);
assign  ACTIVE_DMA    =   (~noport)   &   (selport    ==  2'b10);
assign  ACTIVE_ACC    =   (~noport)   &   (selport    ==  2'b11);

assign  HSEL    =   noport  ?   1'b0    :
                    ((selport   ==  2'b01)  ?   HSEL_SYS  :
                    ((selport   ==  2'b10)  ?   HSEL_DMA  :
                    ((selport   ==  2'b11)  ?   HSEL_ACC  :     1'b0)));

assign  HADDR   =   noport  ?   32'b0    :
                    ((selport   ==  2'b01)  ?   HADDR_SYS  :
                    ((selport   ==  2'b10)  ?   HADDR_DMA  :
                    ((selport   ==  2'b11)  ?   HADDR_ACC  :    32'b0)));

assign  HTRANS  =   noport  ?   2'b0    :
                    ((selport   ==  2'b01)  ?   HTRANS_SYS  :
                    ((selport   ==  2'b10)  ?   HTRANS_DMA  :
                    ((selport   ==  2'b11)  ?   HTRANS_ACC  :   2'b0)));               

assign  HWRITE  =   noport  ?   1'b0    :
                    ((selport   ==  2'b01)  ?   HWRITE_SYS  :
                    ((selport   ==  2'b10)  ?   HWRITE_DMA  :
                    ((selport   ==  2'b11)  ?   HWRITE_ACC  :   1'b0)));

assign  HSIZE   =    noport  ?   3'b0    :
                    ((selport   ==  2'b01)  ?   HSIZE_SYS  :
                    ((selport   ==  2'b10)  ?   HSIZE_DMA  :
                    ((selport   ==  2'b11)  ?   HSIZE_ACC  :    3'b0)));      

assign  HBURST  =   noport  ?   3'b0    :
                    ((selport   ==  2'b01)  ?   HBURST_SYS  :
                    ((selport   ==  2'b10)  ?   HBURST_DMA  :
                    ((selport   ==  2'b11)  ?   HBURST_ACC  :   3'b0)));

assign  HPROT   =   noport  ?   4'b0    :
                    ((selport   ==  2'b01)  ?   HPROT_SYS   :
                    ((selport   ==  2'b10)  ?   HPROT_DMA   :
                    ((selport   ==  2'b11)  ?   HPROT_ACC   :   4'b0)));                                                        

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

assign  HWDATA  =   (selport_data   ==  2'b01)  ?   HWDATA_SYS    :
                    ((selport_data  ==  2'b10)  ?   HWDATA_DMA    : 32'b0);

endmodule