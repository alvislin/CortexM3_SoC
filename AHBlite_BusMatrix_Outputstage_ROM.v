module AHBlite_BusMatrix_Outputstage_ROM(
    input   HCLK,
    input   HRESETn,

    input   HSEL_ICODE,
    input   [31:0]  HADDR_ICODE,
    input   [1:0]   HTRANS_ICODE,
    input   HWRITE_ICODE,
    input   [2:0]   HSIZE_ICODE,
    input   [2:0]   HBURST_ICODE,
    input   [3:0]   HPROT_ICODE,
    input   [31:0]  HWDATA_ICODE,
    input           TRANS_HOLD_ICODE,

    input   HSEL_DCODE,
    input   [31:0]  HADDR_DCODE,
    input   [1:0]   HTRANS_DCODE,
    input   HWRITE_DCODE,
    input   [2:0]   HSIZE_DCODE,
    input   [2:0]   HBURST_DCODE,
    input   [3:0]   HPROT_DCODE,
    input   [31:0]  HWDATA_DCODE,
    input           TRANS_HOLD_DCODE,

    input   HREADYOUT,

    output  wire    ACTIVE_DCODE,
    output  wire    ACTIVE_ICODE,

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

wire    REQ_DCODE;
wire    REQ_ICODE;

assign  REQ_DCODE   =   TRANS_HOLD_DCODE    &   HSEL_DCODE;
assign  REQ_ICODE   =   TRANS_HOLD_ICODE    &   HSEL_ICODE;

wire    noport;
wire    [1:0]   selport;

AHBlite_BusMatrix_Arbiter_ROM   ROM_arb(
    .HCLK   (HCLK),
    .HRESETn    (HRESETn),
    .REQ_DCODE  (REQ_DCODE),
    .REQ_ICODE  (REQ_ICODE),
    .HREADY_Outputstage_ROM (HREADY),
    .HSEL_Outputstage_ROM   (HSEL),
    .HTRANS_Outputstage_ROM (HTRANS),
    .HBURST_Outputstage_ROM (HBURST),
    .PORT_SEL_ARBITER_ROM   (selport),
    .PORT_NOSEL_ARBITER_ROM (noport)
);

assign  ACTIVE_DCODE    =   (~noport)   &   (selport    ==  2'b01);
assign  ACTIVE_ICODE    =   (~noport)   &   (selport    ==  2'b10);

assign  HSEL    =   noport  ?   1'b0    :
                    ((selport   ==  2'b01)  ?   HSEL_DCODE  :
                    ((selport   ==  2'b10)  ?   HSEL_ICODE  :    1'b0));

assign  HADDR   =   noport  ?   32'b0    :
                    ((selport   ==  2'b01)  ?   HADDR_DCODE  :
                    ((selport   ==  2'b10)  ?   HADDR_ICODE  :    32'b0));

assign  HTRANS  =   noport  ?   2'b0    :
                    ((selport   ==  2'b01)  ?   HTRANS_DCODE  :
                    ((selport   ==  2'b10)  ?   HTRANS_ICODE  :   2'b0));                

assign  HWRITE  =   noport  ?   1'b0    :
                    ((selport   ==  2'b01)  ?   HWRITE_DCODE  :
                    ((selport   ==  2'b10)  ?   HWRITE_ICODE  :   1'b0)); 

assign  HSIZE   =    noport  ?   3'b0    :
                    ((selport   ==  2'b01)  ?   HSIZE_DCODE  :
                    ((selport   ==  2'b10)  ?   HSIZE_ICODE  :    3'b0));       

assign  HBURST  =   noport  ?   3'b0    :
                    ((selport   ==  2'b01)  ?   HBURST_DCODE  :
                    ((selport   ==  2'b10)  ?   HBURST_ICODE  :   3'b0)); 

assign  HPROT   =   noport  ?   4'b0    :
                    ((selport   ==  2'b01)  ?   HPROT_DCODE   :
                    ((selport   ==  2'b10)  ?   HPROT_ICODE   :   4'b0));                                                           

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

assign  HWDATA  =   (selport_data   ==  2'b01)  ?   HWDATA_DCODE    :
                    ((selport_data  ==  2'b10)  ?   HWDATA_ICODE    :   32'b0);

endmodule