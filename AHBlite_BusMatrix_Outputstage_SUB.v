module AHBlite_BusMatrix_Outputstage_SUB(
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

    input   HREADYOUT,

    output  wire    ACTIVE_SYS,

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

assign  REQ_SYS     =   TRANS_HOLD_SYS      &   HSEL_SYS;

wire    noport;
wire    [1:0]   selport;

AHBlite_BusMatrix_Arbiter_SUB   sub_arb(
    .HCLK       (HCLK),
    .HRESETn    (HRESETn),
    .REQ_SYS    (REQ_SYS),
    .HREADY_Outputstage_SUB (HREADY),
    .HSEL_Outputstage_SUB   (HSEL),
    .HTRANS_Outputstage_SUB (HTRANS),
    .HBURST_Outputstage_SUB (HBURST),
    .PORT_SEL_ARBITER_SUB   (selport),
    .PORT_NOSEL_ARBITER_SUB (noport)
);

assign  ACTIVE_SYS    =   (~noport)   &   (selport    ==  2'b11);

assign  HSEL    =   noport  ?   1'b0    :
                    ((selport   ==  2'b11)  ?   HSEL_SYS  :     1'b0);

assign  HADDR   =   noport  ?   32'b0    :
                    ((selport   ==  2'b11)  ?   HADDR_SYS  :    32'b0);

assign  HTRANS  =   noport  ?   2'b0    :
                    ((selport   ==  2'b11)  ?   HTRANS_SYS  :   2'b0);                

assign  HWRITE  =   noport  ?   1'b0    :
                    ((selport   ==  2'b11)  ?   HWRITE_SYS  :   1'b0);

assign  HSIZE   =    noport  ?   3'b0    :
                    ((selport   ==  2'b11)  ?   HSIZE_SYS  :    3'b0);    

assign  HBURST  =   noport  ?   3'b0    :
                    ((selport   ==  2'b11)  ?   HBURST_SYS  :   3'b0);

assign  HPROT   =   noport  ?   4'b0    :
                    ((selport   ==  2'b11)  ?   HPROT_SYS   :   4'b0);                                                       

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

assign  HWDATA  =   (selport_data   ==  2'b11)  ?   HWDATA_SYS    : 32'b0;

endmodule