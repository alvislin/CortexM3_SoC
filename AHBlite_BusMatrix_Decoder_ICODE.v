module AHBlite_BusMatrix_Decoder_ICODE(

    input   HCLK,
    input   HRESETn,

    //  FROM INPUTSTAGE
    input   HREADY,
    input   [31:0]  HADDR,
    input   [1:0]   HTRANS,

    //  FROM OUTPUTSTAGE
    input   ACTIVE_Outputstage_ITCM,
    input   HREADYOUT_Outputstage_ITCM,
    input   [1:0]   HRESP_ITCM,
    input   [31:0]  HRDATA_ITCM,

    //  FROM OUTPUTSTAGE
    input   ACTIVE_Outputstage_ROM,
    input   HREADYOUT_Outputstage_ROM,
    input   [1:0]   HRESP_ROM,
    input   [31:0]  HRDATA_ROM,

    //  OUTPUTSTAGE HSEL
    output  wire    HSEL_Decoder_ICODE_ITCM,
    output  wire    HSEL_Decoder_ICODE_ROM,

    //  SELOUTPUT
    output  wire    ACTIVE_Decoder_ICODE,
    output  wire    HREADYOUT,
    output  wire    [1:0]   HRESP,
    output  wire    [31:0]  HRDATA 
);

assign  HSEL_Decoder_ICODE_ITCM    = (HADDR[31:15]  ==  17'h1);
assign  HSEL_Decoder_ICODE_ROM     = (HADDR[31:15]  ==  17'b0);

assign  ACTIVE_Decoder_ICODE    = HSEL_Decoder_ICODE_ITCM   ? ACTIVE_Outputstage_ITCM    :
                                 (HSEL_Decoder_ICODE_ROM    ? ACTIVE_Outputstage_ROM     : 1'b1);

reg [1:0] sel_reg;

always@(posedge HCLK or negedge HRESETn) begin
    if(~HRESETn)
        sel_reg <=  2'b0;
    else if(HREADY)
        sel_reg <=  {HSEL_Decoder_ICODE_ITCM,HSEL_Decoder_ICODE_ROM};
end

assign  HREADYOUT   =   (sel_reg == 2'b10) ?   HREADYOUT_Outputstage_ITCM   :
                       ((sel_reg == 2'b01) ?   HREADYOUT_Outputstage_ROM    :  1'b1);

assign  HRESP       =   (sel_reg == 2'b10) ?   HRESP_ITCM   :
                       ((sel_reg == 2'b01) ?   HRESP_ROM    :  2'b0);

assign  HRDATA      =   (sel_reg == 2'b10) ?   HRDATA_ITCM   :
                       ((sel_reg == 2'b01) ?   HRDATA_ROM    :  32'b0);


endmodule