module AHBlite_SubBus    (
    //  COMMON SIGANLS
    input               HCLK,
    input               HRESETn,

    //  INPUTPORT SUB
    input       [31:0]  HADDR_SUB,
    input       [1:0]   HTRANS_SUB,
    input               HWRITE_SUB,
    input       [2:0]   HSIZE_SUB,
    input       [2:0]   HBURST_SUB,
    input       [3:0]   HPROT_SUB,
    input       [31:0]  HWDATA_SUB,
    //  OUTPUTPORT SUB
    output wire [31:0]  HRDATA_SUB,
    output wire         HREADY_SUB,
    output wire [1:0]   HRESP_SUB,      

    //  INPUTPORT  DMAC
    input       [31:0]  HRDATA_DMAC,
    input               HREADYOUT_DMAC,
    input       [1:0]   HRESP_DMAC,
    //  OUTPUTPORT  DMAC
    output wire         HSEL_DMAC,
    output wire [31:0]  HADDR_DMAC,
    output wire [1:0]   HTRANS_DMAC,
    output wire         HWRITE_DMAC,
    output wire [2:0]   HSIZE_DMAC,
    output wire [2:0]   HBURST_DMAC,
    output wire [3:0]   HPROT_DMAC,
    output wire [31:0]  HWDATA_DMAC,
    output wire         HREADY_DMAC,

    //  INPUTPORT  GPIO
    input       [31:0]  HRDATA_GPIO,
    input               HREADYOUT_GPIO,
    input       [1:0]   HRESP_GPIO,
    //  OUTPUTPORT  GPIO
    output wire         HSEL_GPIO,
    output wire [31:0]  HADDR_GPIO,
    output wire [1:0]   HTRANS_GPIO,
    output wire         HWRITE_GPIO,
    output wire [2:0]   HSIZE_GPIO,
    output wire [2:0]   HBURST_GPIO,
    output wire [3:0]   HPROT_GPIO,
    output wire [31:0]  HWDATA_GPIO,
    output wire         HREADY_GPIO,  

    //  INPUTPORT  UART
    input       [31:0]  HRDATA_UART,
    input               HREADYOUT_UART,
    input       [1:0]   HRESP_UART,
    //  OUTPUTPORT  GPIO
    output wire         HSEL_UART,
    output wire [31:0]  HADDR_UART,
    output wire [1:0]   HTRANS_UART,
    output wire         HWRITE_UART,
    output wire [2:0]   HSIZE_UART,
    output wire [2:0]   HBURST_UART,
    output wire [3:0]   HPROT_UART,
    output wire [31:0]  HWDATA_UART,
    output wire         HREADY_UART,  

    //  INPUTPORT  OLED
    input       [31:0]  HRDATA_OLED,
    input               HREADYOUT_OLED,
    input       [1:0]   HRESP_OLED,
    //  OUTPUTPORT  OLED
    output wire         HSEL_OLED,
    output wire [31:0]  HADDR_OLED,
    output wire [1:0]   HTRANS_OLED,
    output wire         HWRITE_OLED,
    output wire [2:0]   HSIZE_OLED,
    output wire [2:0]   HBURST_OLED,
    output wire [3:0]   HPROT_OLED,
    output wire [31:0]  HWDATA_OLED,
    output wire         HREADY_OLED,

    //  INPUTPORT  TIMER
    input       [31:0]  HRDATA_TIMER,
    input               HREADYOUT_TIMER,
    input       [1:0]   HRESP_TIMER,
    //  OUTPUTPORT  TIMER
    output wire         HSEL_TIMER,
    output wire [31:0]  HADDR_TIMER,
    output wire [1:0]   HTRANS_TIMER,
    output wire         HWRITE_TIMER,
    output wire [2:0]   HSIZE_TIMER,
    output wire [2:0]   HBURST_TIMER,
    output wire [3:0]   HPROT_TIMER,
    output wire [31:0]  HWDATA_TIMER,
    output wire         HREADY_TIMER

);

wire    HREADYOUT_SUB;
assign  HREADY_SUB    =   HREADYOUT_SUB;
wire    active_decoder_sub;
wire    hreadyout_decoder_sub;
wire    [1:0]   hresp_decoder_sub;
wire    [31:0]  haddr_inputstage_sub;
wire    [1:0]   htrans_inputstage_sub;
wire            hwrite_inputstage_sub;
wire    [2:0]   hsize_inputstage_sub;
wire    [2:0]   hburst_inputstage_sub;
wire    [3:0]   hprot_inputstage_sub;
wire            trans_hold_sub;

AHBlite_BusMatrix_Inputstage SUB_INPUT(
    //  COMMON SIGNALS
    .HCLK       (HCLK),
    .HRESETn    (HRESETn),

    //  MASTOR  SIDE
    .HADDR      (HADDR_SUB),
    .HTRANS     (HTRANS_SUB),
    .HWRITE     (HWRITE_SUB),
    .HSIZE      (HSIZE_SUB),
    .HBURST     (HBURST_SUB),
    .HPROT      (HPROT_SUB),
    .HREADY     (HREADYOUT_SUB),
    .HREADYOUT  (HREADYOUT_SUB),
    .HRESP      (HRESP_SUB),

    //  INTERNAL SIDE
    .ACTIVE_Decoder (active_decoder_sub),
    .HREADYOUT_Decoder  (hreadyout_decoder_sub),
    .HRESP_Decoder  (hresp_decoder_sub),
    .HADDR_Inputstage   (haddr_inputstage_sub),
    .HTRANS_Inputstage  (htrans_inputstage_sub),
    .HWRITE_Inputstage  (hwrite_inputstage_sub),
    .HSIZE_Inputstage   (hsize_inputstage_sub),
    .HBURST_Inputstage  (hburst_inputstage_sub),
    .HPROT_Inputstage   (hprot_inputstage_sub),
    .TRANS_HOLD        (trans_hold_sub)
);

wire    active_outputstage_dmac;
wire    hreadyout_outputstage_dmac;
wire    active_outputstage_timer;
wire    hreadyout_outputstage_timer;
wire    active_outputstage_gpio;
wire    hreadyout_outputstage_gpio;
wire    active_outputstage_oled;
wire    hreadyout_outputstage_oled;
wire    active_outputstage_uart;
wire    hreadyout_outputstage_uart;
wire    hsel_decoder_sub_dmac; 
wire    hsel_decoder_sub_gpio; 
wire    hsel_decoder_sub_oled; 
wire    hsel_decoder_sub_uart; 
wire    hsel_decoder_sub_timer; 
wire    active_outputstage_dmac_sub; 
wire    active_outputstage_gpio_sub; 
wire    active_outputstage_oled_sub; 
wire    active_outputstage_uart_sub;
wire    active_outputstage_timer_sub;

AHBlite_BusMatrix_Decoder_SUB SUB_DECODER(
    //  COMMON SIGNALS
    .HCLK       (HCLK),
    .HRESETn    (HRESETn),

    //  FROM INPUTSTAGE
    .HREADY     (HREADYOUT_SUB),
    .HADDR      (haddr_inputstage_sub),
    .HTRANS     (htrans_inputstage_sub),
    
    //  FROM OUTPUTSTAGE

    .ACTIVE_Outputstage_DMAC (active_outputstage_dmac_sub),
    .HREADYOUT_Outputstage_DMAC  (hreadyout_outputstage_dmac),
    .HRESP_DMAC  (HRESP_DMAC),
    .HRDATA_DMAC (HRDATA_DMAC),

    .ACTIVE_Outputstage_GPIO (active_outputstage_gpio_sub),
    .HREADYOUT_Outputstage_GPIO  (hreadyout_outputstage_gpio),
    .HRESP_GPIO  (HRESP_GPIO),
    .HRDATA_GPIO (HRDATA_GPIO),

    .ACTIVE_Outputstage_UART (active_outputstage_uart_sub),
    .HREADYOUT_Outputstage_UART  (hreadyout_outputstage_uart),
    .HRESP_UART  (HRESP_UART),
    .HRDATA_UART (HRDATA_UART),

    .ACTIVE_Outputstage_OLED (active_outputstage_oled_sub),
    .HREADYOUT_Outputstage_OLED  (hreadyout_outputstage_oled),
    .HRESP_OLED  (HRESP_OLED),
    .HRDATA_OLED (HRDATA_OLED),

    .ACTIVE_Outputstage_TIMER (active_outputstage_timer_sub),
    .HREADYOUT_Outputstage_TIMER  (hreadyout_outputstage_timer),
    .HRESP_TIMER  (HRESP_TIMER),
    .HRDATA_TIMER (HRDATA_TIMER),

    .HSEL_Decoder_SUB_DMAC (hsel_decoder_sub_dmac),
    .HSEL_Decoder_SUB_GPIO (hsel_decoder_sub_gpio),
    .HSEL_Decoder_SUB_OLED (hsel_decoder_sub_oled),
    .HSEL_Decoder_SUB_UART (hsel_decoder_sub_uart),
    .HSEL_Decoder_SUB_TIMER(hsel_decoder_sub_timer),

    .ACTIVE_Decoder_SUB   (active_decoder_sub),
    .HREADYOUT  (hreadyout_decoder_sub),
    .HRESP  (hresp_decoder_sub),
    .HRDATA (HRDATA_SUB)
);

AHBlite_BusMatrix_Outputstage_DMAC DMAC_OUTPUT(
    //  COMMON SIGNALS
    .HCLK       (HCLK),
    .HRESETn    (HRESETn),

    //  SUB
    .HSEL_SUB (hsel_decoder_sub_dmac),
    .HADDR_SUB    (haddr_inputstage_sub),
    .HTRANS_SUB   (htrans_inputstage_sub),
    .HWRITE_SUB   (hwrite_inputstage_sub),
    .HSIZE_SUB    (hsize_inputstage_sub),
    .HBURST_SUB   (hburst_inputstage_sub),
    .HPROT_SUB    (hprot_inputstage_sub),
    .HWDATA_SUB   (HWDATA_SUB),
    .TRANS_HOLD_SUB   (trans_hold_sub),


    .HREADYOUT      (HREADYOUT_DMAC),

    .ACTIVE_SUB   (active_outputstage_dmac_sub),

    .HSEL       (HSEL_DMAC),
    .HADDR      (HADDR_DMAC),
    .HTRANS     (HTRANS_DMAC),
    .HWRITE     (HWRITE_DMAC),
    .HSIZE      (HSIZE_DMAC),
    .HBURST     (HBURST_DMAC),
    .HPROT      (HPROT_DMAC),
    .HREADY     (hreadyout_outputstage_dmac),
    .HWDATA     (HWDATA_DMAC)
);

assign HREADY_DMAC  =   hreadyout_outputstage_dmac;

AHBlite_BusMatrix_Outputstage_GPIO GPIO_OUTPUT(
    //  COMMON SIGNALS
    .HCLK       (HCLK),
    .HRESETn    (HRESETn),

    //  SUB
    .HSEL_SUB     (hsel_decoder_sub_gpio),
    .HADDR_SUB    (haddr_inputstage_sub),
    .HTRANS_SUB   (htrans_inputstage_sub),
    .HWRITE_SUB   (hwrite_inputstage_sub),
    .HSIZE_SUB    (hsize_inputstage_sub),
    .HBURST_SUB   (hburst_inputstage_sub),
    .HPROT_SUB    (hprot_inputstage_sub),
    .HWDATA_SUB   (HWDATA_SUB),
    .TRANS_HOLD_SUB   (trans_hold_sub),


    .HREADYOUT      (HREADYOUT_GPIO),

    .ACTIVE_SUB   (active_outputstage_gpio_sub),

    .HSEL       (HSEL_GPIO),
    .HADDR      (HADDR_GPIO),
    .HTRANS     (HTRANS_GPIO),
    .HWRITE     (HWRITE_GPIO),
    .HSIZE      (HSIZE_GPIO),
    .HBURST     (HBURST_GPIO),
    .HPROT      (HPROT_GPIO),
    .HREADY     (hreadyout_outputstage_gpio),
    .HWDATA     (HWDATA_GPIO)
);

assign HREADY_GPIO  =   hreadyout_outputstage_gpio;

AHBlite_BusMatrix_Outputstage_UART UART_OUTPUT(
    //  COMMON SIGNALS
    .HCLK       (HCLK),
    .HRESETn    (HRESETn),

    //  SUB
    .HSEL_SUB     (hsel_decoder_sub_uart),
    .HADDR_SUB    (haddr_inputstage_sub),
    .HTRANS_SUB   (htrans_inputstage_sub),
    .HWRITE_SUB   (hwrite_inputstage_sub),
    .HSIZE_SUB    (hsize_inputstage_sub),
    .HBURST_SUB   (hburst_inputstage_sub),
    .HPROT_SUB    (hprot_inputstage_sub),
    .HWDATA_SUB   (HWDATA_SUB),
    .TRANS_HOLD_SUB   (trans_hold_sub),


    .HREADYOUT      (HREADYOUT_UART),

    .ACTIVE_SUB   (active_outputstage_uart_sub),

    .HSEL       (HSEL_UART),
    .HADDR      (HADDR_UART),
    .HTRANS     (HTRANS_UART),
    .HWRITE     (HWRITE_UART),
    .HSIZE      (HSIZE_UART),
    .HBURST     (HBURST_UART),
    .HPROT      (HPROT_UART),
    .HREADY     (hreadyout_outputstage_uart),
    .HWDATA     (HWDATA_UART)
);

assign HREADY_UART  =   hreadyout_outputstage_uart;

AHBlite_BusMatrix_Outputstage_OLED OLED_OUTPUT(
    //  COMMON SIGNALS
    .HCLK       (HCLK),
    .HRESETn    (HRESETn),

    //  SUB
    .HSEL_SUB     (hsel_decoder_sub_oled),
    .HADDR_SUB    (haddr_inputstage_sub),
    .HTRANS_SUB   (htrans_inputstage_sub),
    .HWRITE_SUB   (hwrite_inputstage_sub),
    .HSIZE_SUB    (hsize_inputstage_sub),
    .HBURST_SUB   (hburst_inputstage_sub),
    .HPROT_SUB    (hprot_inputstage_sub),
    .HWDATA_SUB   (HWDATA_SUB),
    .TRANS_HOLD_SUB   (trans_hold_sub),

    .HREADYOUT      (HREADYOUT_OLED),

    .ACTIVE_SUB   (active_outputstage_oled_sub),

    .HSEL       (HSEL_OLED),
    .HADDR      (HADDR_OLED),
    .HTRANS     (HTRANS_OLED),
    .HWRITE     (HWRITE_OLED),
    .HSIZE      (HSIZE_OLED),
    .HBURST     (HBURST_OLED),
    .HPROT      (HPROT_OLED),
    .HREADY     (hreadyout_outputstage_oled),
    .HWDATA     (HWDATA_OLED)
);

assign  HREADY_OLED  =   hreadyout_outputstage_oled;

AHBlite_BusMatrix_Outputstage_TIMER TIMER_OUTPUT(
    //  COMMON SIGNALS
    .HCLK       (HCLK),
    .HRESETn    (HRESETn),

    //  SUB
    .HSEL_SUB     (hsel_decoder_sub_timer),
    .HADDR_SUB    (haddr_inputstage_sub),
    .HTRANS_SUB   (htrans_inputstage_sub),
    .HWRITE_SUB   (hwrite_inputstage_sub),
    .HSIZE_SUB    (hsize_inputstage_sub),
    .HBURST_SUB   (hburst_inputstage_sub),
    .HPROT_SUB    (hprot_inputstage_sub),
    .HWDATA_SUB   (HWDATA_SUB),
    .TRANS_HOLD_SUB   (trans_hold_sub),

    .HREADYOUT      (HREADYOUT_TIMER),

    .ACTIVE_SUB   (active_outputstage_timer_sub),

    .HSEL       (HSEL_TIMER),
    .HADDR      (HADDR_TIMER),
    .HTRANS     (HTRANS_TIMER),
    .HWRITE     (HWRITE_TIMER),
    .HSIZE      (HSIZE_TIMER),
    .HBURST     (HBURST_TIMER),
    .HPROT      (HPROT_TIMER),
    .HREADY     (hreadyout_outputstage_timer),
    .HWDATA     (HWDATA_TIMER)
);

assign  HREADY_TIMER  =   hreadyout_outputstage_timer;

endmodule