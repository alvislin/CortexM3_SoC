module AHBlite_BusMatrix_Decoder_DMA(

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

    //  FROM OUTPUTSTAGE
    input   ACTIVE_Outputstage_ACCC,
    input   HREADYOUT_Outputstage_ACCC,
    input   [1:0]   HRESP_ACCC,
    input   [31:0]  HRDATA_ACCC,

    //  OUTPUTSTAGE HSEL
    output  wire    HSEL_Decoder_DMA_DTCM,
    output  wire    HSEL_Decoder_DMA_CAMERA,
    output  wire    HSEL_Decoder_DMA_ACCC,
    
    //  SELOUTPUT
    output  wire    ACTIVE_Decoder_DMA,
    output  wire    HREADYOUT,
    output  wire    [1:0]   HRESP,
    output  wire    [31:0]  HRDATA 
);

assign  HSEL_Decoder_DMA_DTCM       = (HADDR[31:12]  ==  20'h20000);
assign  HSEL_Decoder_DMA_CAMERA     = (HADDR[31:16]  ==  16'h4001);
assign  HSEL_Decoder_DMA_ACCC       = (HADDR[31:16]  ==  16'h4003);

assign  ACTIVE_Decoder_DMA          = HSEL_Decoder_DMA_DTCM     ?   ACTIVE_Outputstage_DTCM     :                
                                      (HSEL_Decoder_DMA_CAMERA  ?   ACTIVE_Outputstage_CAMERA   :  
                                      (HSEL_Decoder_DMA_ACCC    ?   ACTIVE_Outputstage_ACCC     :1'b1));

reg [2:0] sel_reg;

always@(posedge HCLK or negedge HRESETn) begin
    if(~HRESETn)
        sel_reg <=  3'b0;
    else if(HREADY)
        sel_reg <=  {HSEL_Decoder_DMA_DTCM,
                     HSEL_Decoder_DMA_CAMERA,
                     HSEL_Decoder_DMA_ACCC};
end

assign  HREADYOUT   =   (sel_reg   ==  3'b001)  ?   HREADYOUT_Outputstage_ACCC    :  
                        ((sel_reg   ==  3'b010)  ?   HREADYOUT_Outputstage_CAMERA :
                        ((sel_reg   ==  3'b100)  ?   HREADYOUT_Outputstage_DTCM   :   1'b1));

assign  HRESP       =   (sel_reg   ==  3'b001)  ?   HRESP_ACCC    :  
                        ((sel_reg   ==  3'b010)  ?   HRESP_CAMERA :
                        ((sel_reg   ==  3'b100)  ?   HRESP_DTCM   :   2'b00));

assign  HRDATA      =   (sel_reg   ==  3'b0001)  ?   HRDATA_ACCC    :    
                        ((sel_reg   ==  3'b010)  ?   HRDATA_CAMERA :
                        ((sel_reg   ==  3'b100)  ?   HRDATA_DTCM   :   32'b0));

endmodule