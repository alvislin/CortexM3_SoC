module AHBlite_BusMatrix_Decoder_ACC(

    input   HCLK,
    input   HRESETn,

    //  FROM INPUTSTAGE
    input   HREADY,
    input   [31:0 ] HADDR,
    input   [1:0]   HTRANS,

    //  FROM OUTPUTSTAGE
    input   ACTIVE_Outputstage_DTCM,
    input   HREADYOUT_Outputstage_DTCM,
    input   [1:0]   HRESP_DTCM,
    input   [31:0]  HRDATA_DTCM,


    //  FROM OUTPUTSTAGE
    input   ACTIVE_Outputstage_CAMERA,
    input   HREADYOUT_Outputstage_CAMERA,
    input   [1:0]   HRESP_CAMERA,
    input   [31:0]  HRDATA_CAMERA,

    //  OUTPUTSTAGE HSEL
    output  wire    HSEL_Decoder_ACC_DTCM,
    output  wire    HSEL_Decoder_ACC_CAMERA,
    
    //  SELOUTPUT
    output  wire    ACTIVE_Decoder_ACC,
    output  wire    HREADYOUT,
    output  wire    [1:0]   HRESP,
    output  wire    [31:0]  HRDATA 
);

assign  HSEL_Decoder_ACC_DTCM   = (HADDR[31:12]  ==  20'h20000);
assign  HSEL_Decoder_ACC_CAMERA     = (HADDR[31:16]  ==  16'h4001);

assign  ACTIVE_Decoder_ACC          = HSEL_Decoder_ACC_DTCM     ?   ACTIVE_Outputstage_DTCM     :                
                                     (HSEL_Decoder_ACC_CAMERA   ?   ACTIVE_Outputstage_CAMERA   :   1'b1);

reg [1:0] sel_reg;

always@(posedge HCLK or negedge HRESETn) begin
    if(~HRESETn)
        sel_reg <=  2'b0;
    else if(HREADY)
        sel_reg <=  {HSEL_Decoder_ACC_DTCM,
                     HSEL_Decoder_ACC_CAMERA};
end

assign  HREADYOUT   =    (sel_reg   ==  2'b01)  ?   HREADYOUT_Outputstage_CAMERA :
                        ((sel_reg   ==  2'b10)  ?   HREADYOUT_Outputstage_DTCM   :   1'b1);

assign  HRESP       =    (sel_reg   ==  2'b01)  ?   HRESP_CAMERA :
                        ((sel_reg   ==  2'b10)  ?   HRESP_DTCM   :   2'b00);

assign  HRDATA      =    (sel_reg   ==  2'b01)  ?   HRDATA_CAMERA :
                        ((sel_reg   ==  2'b10)  ?   HRDATA_DTCM   :   32'b0);

endmodule