module AHBlite_BusMatrix_Outputstage_UART(
    input   HCLK,
    input   HRESETn,

    input   HSEL_SUB,
    input   [31:0]  HADDR_SUB,
    input   [1:0]   HTRANS_SUB,
    input   HWRITE_SUB,
    input   [2:0]   HSIZE_SUB,
    input   [2:0]   HBURST_SUB,
    input   [3:0]   HPROT_SUB,
    input   [31:0]  HWDATA_SUB,
    input           TRANS_HOLD_SUB,

    input   HREADYOUT,

    output  wire    ACTIVE_SUB,

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

wire    REQ_SUB;

assign  REQ_SUB     =   TRANS_HOLD_SUB      &   HSEL_SUB;

wire    noport;
wire    [1:0]   selport;

AHBlite_BusMatrix_Arbiter_UART   uart_arb(
    .HCLK       (HCLK),
    .HRESETn    (HRESETn),
    .REQ_SUB    (REQ_SUB),
    .HREADY_Outputstage_UART (HREADY),
    .HSEL_Outputstage_UART   (HSEL),
    .HTRANS_Outputstage_UART (HTRANS),
    .HBURST_Outputstage_UART (HBURST),
    .PORT_SEL_ARBITER_UART   (selport),
    .PORT_NOSEL_ARBITER_UART (noport)
);

assign  ACTIVE_SUB    =   (~noport)   &   (selport    ==  2'b11);

assign  HSEL    =   noport  ?   1'b0    :
                    ((selport   ==  2'b11)  ?   HSEL_SUB  :     1'b0);

assign  HADDR   =   noport  ?   32'b0    :
                    ((selport   ==  2'b11)  ?   HADDR_SUB  :    32'b0);

assign  HTRANS  =   noport  ?   2'b0    :
                    ((selport   ==  2'b11)  ?   HTRANS_SUB  :   2'b0);                

assign  HWRITE  =   noport  ?   1'b0    :
                    ((selport   ==  2'b11)  ?   HWRITE_SUB  :   1'b0);

assign  HSIZE   =    noport  ?   3'b0    :
                    ((selport   ==  2'b11)  ?   HSIZE_SUB  :    3'b0);    

assign  HBURST  =   noport  ?   3'b0    :
                    ((selport   ==  2'b11)  ?   HBURST_SUB  :   3'b0);

assign  HPROT   =   noport  ?   4'b0    :
                    ((selport   ==  2'b11)  ?   HPROT_SUB   :   4'b0);                                                       

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

assign  HWDATA  =   (selport_data   ==  2'b11)  ?   HWDATA_SUB    : 32'b0;

endmodule