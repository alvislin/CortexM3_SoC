module AHBlite_BusMatrix_Decoder_SUB(

    input   HCLK,
    input   HRESETn,

    //  FROM INPUTSTAGE
    input   HREADY,
    input   [31:0]  HADDR,
    input   [1:0]   HTRANS,

    //  FROM OUTPUTSTAGE
    input   ACTIVE_Outputstage_DMAC,
    input   HREADYOUT_Outputstage_DMAC,
    input   [1:0]   HRESP_DMAC,
    input   [31:0]  HRDATA_DMAC,

    //  FROM OUTPUTSTAGE
    input   ACTIVE_Outputstage_GPIO,
    input   HREADYOUT_Outputstage_GPIO,
    input   [1:0]   HRESP_GPIO,
    input   [31:0]  HRDATA_GPIO,

    //  FROM OUTPUTSTAGE
    input   ACTIVE_Outputstage_OLED,
    input   HREADYOUT_Outputstage_OLED,
    input   [1:0]   HRESP_OLED,
    input   [31:0]  HRDATA_OLED,

    //  FROM OUTPUTSTAGE
    input   ACTIVE_Outputstage_TIMER,
    input   HREADYOUT_Outputstage_TIMER,
    input   [1:0]   HRESP_TIMER,
    input   [31:0]  HRDATA_TIMER,

    //  FROM OUTPUTSTAGE
    input   ACTIVE_Outputstage_UART,
    input   HREADYOUT_Outputstage_UART,
    input   [1:0]   HRESP_UART,
    input   [31:0]  HRDATA_UART,

    //  OUTPUTSTAGE HSEL
    output  wire    HSEL_Decoder_SUB_DMAC,
    output  wire    HSEL_Decoder_SUB_GPIO,
    output  wire    HSEL_Decoder_SUB_OLED,
    output  wire    HSEL_Decoder_SUB_TIMER,
    output  wire    HSEL_Decoder_SUB_UART,
    
    //  SELOUTPUT
    output  wire    ACTIVE_Decoder_SUB,
    output  wire    HREADYOUT,
    output  wire    [1:0]   HRESP,
    output  wire    [31:0]  HRDATA 
);

assign  HSEL_Decoder_SUB_DMAC   = (HADDR[31:8]  ==  28'h400002);
assign  HSEL_Decoder_SUB_UART   = (HADDR[31:8]  ==  28'h400001);
assign  HSEL_Decoder_SUB_GPIO   = (HADDR[31:8]  ==  28'h400000);
assign  HSEL_Decoder_SUB_OLED   = (HADDR[31:8]  ==  24'h400003);
assign  HSEL_Decoder_SUB_TIMER  = (HADDR[31:8]  ==  24'h400004);

assign  ACTIVE_Decoder_SUB    = HSEL_Decoder_SUB_DMAC   ?   ACTIVE_Outputstage_DMAC :
                                (HSEL_Decoder_SUB_GPIO  ?   ACTIVE_Outputstage_GPIO :
                                (HSEL_Decoder_SUB_OLED  ?   ACTIVE_Outputstage_OLED :
                                (HSEL_Decoder_SUB_UART  ?   ACTIVE_Outputstage_UART :
                                (HSEL_Decoder_SUB_TIMER ?   ACTIVE_Outputstage_TIMER:   1'b1))));

reg [4:0] sel_reg;

always@(posedge HCLK or negedge HRESETn) begin
    if(~HRESETn)
        sel_reg <=  5'b0;
    else if(HREADY)
        sel_reg <=  {HSEL_Decoder_SUB_TIMER,
                     HSEL_Decoder_SUB_UART,
                     HSEL_Decoder_SUB_DMAC,
                     HSEL_Decoder_SUB_GPIO,
                     HSEL_Decoder_SUB_OLED};
end

assign  HREADYOUT   =   (sel_reg    ==  5'b00001)  ?   HREADYOUT_Outputstage_OLED    :
                        ((sel_reg   ==  5'b00010)  ?   HREADYOUT_Outputstage_GPIO    :
                        ((sel_reg   ==  5'b00100)  ?   HREADYOUT_Outputstage_DMAC    :
                        ((sel_reg   ==  5'b01000)  ?   HREADYOUT_Outputstage_UART    :
                        ((sel_reg   ==  5'b10000)  ?   HREADYOUT_Outputstage_TIMER   :   1'b1))));

assign  HRESP       =   (sel_reg    ==  5'b00001)  ?   HRESP_OLED    :
                        ((sel_reg   ==  5'b00010)  ?   HRESP_GPIO    :
                        ((sel_reg   ==  5'b00100)  ?   HRESP_DMAC    :
                        ((sel_reg   ==  5'b01000)  ?   HRESP_UART    :
                        ((sel_reg   ==  5'b10000)  ?   HRESP_TIMER   :   2'b00))));
                      
assign  HRDATA      =   (sel_reg    ==  5'b00001)  ?   HRDATA_OLED   :
                        ((sel_reg   ==  5'b00010)  ?   HRDATA_GPIO   :
                        ((sel_reg   ==  5'b00100)  ?   HRDATA_DMAC   :
                        ((sel_reg   ==  5'b01000)  ?   HRDATA_UART   :
                        ((sel_reg   ==  5'b10000)  ?   HRDATA_TIMER  :   32'b0))));

endmodule