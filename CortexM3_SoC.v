
module CortexM3_SoC #(
    parameter                   SimPresent = 0
)   (
    input       wire            clk_50m,
    input       wire            RSTn,

    // SWD
    inout       wire            SWDIO,
    input       wire            SWCLK,

    // KEYBOARD
    input       wire    [3:0]   col,

    // GPIO
    inout       wire    [15:0]  GPIO_PIN,

    // OLED
    output      wire            OLED_SCLK,
    output      wire            OLED_SDIN,

    // CAMERA
    output      wire            CAMERA_PWDN,
    output      wire            CAMERA_RST,
    output      wire            CAMERA_SCL,
    inout       wire            CAMERA_SDA,
    input       wire            CAMERA_PCLK,
    input       wire            CAMERA_VSYNC,
    input       wire            CAMERA_HREF,
    input       wire    [7:0]   CAMERA_DATA,

    // UART
    output      wire            TXD,
    input       wire            RXD,

    // TIMER
    output  wire    [3:0]       Sec,
    output  wire    [6:0]       Tenth,
    output  wire    [6:0]       Perc
);

//------------------------------------------------------------------------------
// GLOBAL BUF
//------------------------------------------------------------------------------

wire clk;
wire swck;
wire pclk;

generate 
        if(SimPresent) begin : SimClock

                assign swck = SWCLK;
                assign pclk = CAMERA_PCLK;
                assign clk  = clk_50m;
        
        end else begin : SynClock

                GLOBAL sw_clk(
                        .in                     (SWCLK),
                        .out                    (swck)
                );
                GLOBAL camera_clk(
                        .in                     (CAMERA_PCLK),
                        .out                    (pclk)
                );
                PLL PLL(
                        .refclk                 (clk_50m),
                        .rst                    (~RSTn),
                        .outclk_0               (clk)
                );
        end    
endgenerate         


//------------------------------------------------------------------------------
// DEBUG IOBUF 
//------------------------------------------------------------------------------

wire SWDO;
wire SWDOEN;
wire SWDI;

generate
        if(SimPresent) begin : SimIOBuf

                assign SWDI = SWDIO;
                assign SWDIO = (SWDOEN) ?  SWDO : 1'bz;

        end else begin : SynIOBuf

                IOBUF SWIOBUF(
                        .datain                 (SWDO),
                        .oe                     (SWDOEN),
                        .dataout                (SWDI),
                        .dataio                 (SWDIO)
                );

        end
endgenerate

//------------------------------------------------------------------------------
// RESET
//------------------------------------------------------------------------------

wire SYSRESETREQ;
reg cpuresetn;

always @(posedge clk or negedge RSTn)begin
        if (~RSTn) 
                cpuresetn <= 1'b0;
        else if (SYSRESETREQ) 
                cpuresetn <= 1'b0;
        else 
                cpuresetn <= 1'b1;
end

wire SLEEPing;

//------------------------------------------------------------------------------
// DEBUG CONFIG
//------------------------------------------------------------------------------


wire    CDBGPWRUPREQ;
reg     CDBGPWRUPACK;

always @(posedge clk or negedge RSTn)begin
        if (~RSTn) 
                CDBGPWRUPACK <= 1'b0;
        else 
                CDBGPWRUPACK <= CDBGPWRUPREQ;
end

//------------------------------------------------------------------------------
// INTERRUPT 
//------------------------------------------------------------------------------

wire    [239:0] IRQ;
wire    [3:0]   key_interrupt;
wire    DMA_Event;
wire    uart_interrupt;

assign  IRQ = {234'b0,uart_interrupt,DMA_Event,key_interrupt};

KeyBoard KeyBoard_IRQ(
        .HCLK                   (clk),
        .HRESETn                (RSTn),
        .col    (col),
        .key_interrupt          (key_interrupt)
);

//------------------------------------------------------------------------------
// BUS MTX
//------------------------------------------------------------------------------


// CPU I-Code 
wire   [31:0] HADDRI;
wire    [1:0] HTRANSI;
wire    [2:0] HSIZEI;
wire    [2:0] HBURSTI;
wire    [3:0] HPROTI;
wire   [31:0] HRDATAI;
wire          HREADYI;
wire    [1:0] HRESPI;

// CPU D-Code 
wire   [31:0] HADDRD;
wire    [1:0] HTRANSD;
wire    [2:0] HSIZED;
wire    [2:0] HBURSTD;
wire    [3:0] HPROTD;
wire   [31:0] HWDATAD;
wire          HWRITED;
wire   [31:0] HRDATAD;
wire          HREADYD;
wire    [1:0] HRESPD;

// CPU System bus 
wire   [31:0] HADDRS;
wire    [1:0] HTRANSS;
wire          HWRITES;
wire    [2:0] HSIZES;
wire   [31:0] HWDATAS;
wire    [2:0] HBURSTS;
wire    [3:0] HPROTS;
wire          HREADYS;
wire   [31:0] HRDATAS;
wire    [1:0] HRESPS;

// DMA bus 
wire   [31:0] HADDRDM;
wire    [1:0] HTRANSDM;
wire          HWRITEDM;
wire    [2:0] HSIZEDM;
wire   [31:0] HWDATADM;
wire    [2:0] HBURSTDM;
wire    [3:0] HPROTDM;
wire          HREADYDM;
wire   [31:0] HRDATADM;
wire    [1:0] HRESPDM;

// ACC bus 
wire   [31:0] HADDRA;
wire    [1:0] HTRANSA;
wire          HWRITEA;
wire    [2:0] HSIZEA;
wire   [31:0] HWDATAA;
wire    [2:0] HBURSTA;
wire    [3:0] HPROTA;
wire          HREADYA;
wire   [31:0] HRDATAA;
wire    [1:0] HRESPA;
assign HADDRA = 0;
assign HTRANSA = 0;
assign HWRITEA = 0;
assign HSIZEA= 0;
assign HWDATAA = 0;
assign HBURSTA = 0;
assign HPROTA = 0;

//------------------------------------------------------------------------------
// Instantiate Cortex-M3 processor 
//------------------------------------------------------------------------------

cortexm3ds_logic ulogic(
    // PMU
    .ISOLATEn                           (1'b1),
    .RETAINn                            (1'b1),

    // RESETS
    .PORESETn                           (RSTn),
    .SYSRESETn                          (cpuresetn),
    .SYSRESETREQ                        (SYSRESETREQ),
    .RSTBYPASS                          (1'b0),
    .CGBYPASS                           (1'b0),
    .SE                                 (1'b0),

    // CLOCKS
    .FCLK                               (clk),
    .HCLK                               (clk),
    .TRACECLKIN                         (1'b0),

    // SYSTICK
    .STCLK                              (1'b0),
    .STCALIB                            (26'b0),
    .AUXFAULT                           (32'b0),

    // CONFIG - SYSTEM
    .BIGEND                             (1'b0),
    .DNOTITRANS                         (1'b1),
    
    // SWJDAP
    .nTRST                              (1'b1),
    .SWDITMS                            (SWDI),
    .SWCLKTCK                           (swck),
    .TDI                                (1'b0),
    .CDBGPWRUPACK                       (CDBGPWRUPACK),
    .CDBGPWRUPREQ                       (CDBGPWRUPREQ),
    .SWDO                               (SWDO),
    .SWDOEN                             (SWDOEN),

    // IRQS
    .INTISR                             (IRQ),
    .INTNMI                             (1'b0),
    
    // I-CODE BUS
    .HREADYI                            (HREADYI),
    .HRDATAI                            (HRDATAI),
    .HRESPI                             (HRESPI),
    .IFLUSH                             (1'b0),
    .HADDRI                             (HADDRI),
    .HTRANSI                            (HTRANSI),
    .HSIZEI                             (HSIZEI),
    .HBURSTI                            (HBURSTI),
    .HPROTI                             (HPROTI),

    // D-CODE BUS
    .HREADYD                            (HREADYD),
    .HRDATAD                            (HRDATAD),
    .HRESPD                             (HRESPD),
    .EXRESPD                            (1'b0),
    .HADDRD                             (HADDRD),
    .HTRANSD                            (HTRANSD),
    .HSIZED                             (HSIZED),
    .HBURSTD                            (HBURSTD),
    .HPROTD                             (HPROTD),
    .HWDATAD                            (HWDATAD),
    .HWRITED                            (HWRITED),

    // SYSTEM BUS
    .HREADYS                            (HREADYS),
    .HRDATAS                            (HRDATAS),
    .HRESPS                             (HRESPS),
    .EXRESPS                            (1'b0),
    .HADDRS                             (HADDRS),
    .HTRANSS                            (HTRANSS),
    .HSIZES                             (HSIZES),
    .HBURSTS                            (HBURSTS),
    .HPROTS                             (HPROTS),
    .HWDATAS                            (HWDATAS),
    .HWRITES                            (HWRITES),

    // SLEEP
    .RXEV                               (1'b0),
    .SLEEPHOLDREQn                      (1'b1),
    .SLEEPING                           (SLEEPing),
    
    // EXTERNAL DEBUG REQUEST
    .EDBGRQ                             (1'b0),
    .DBGRESTART                         (1'b0),
    
    // DAP HMASTER OVERRIDE
    .FIXMASTERTYPE                      (1'b0),

    // WIC
    .WICENREQ                           (1'b0),

    // TIMESTAMP INTERFACE
    .TSVALUEB                           (48'b0),

    // CONFIG - DEBUG
    .DBGEN                              (1'b1),
    .NIDEN                              (1'b1),
    .MPUDISABLE                         (1'b0)
);

//------------------------------------------------------------------------------
// AHB DMA
//------------------------------------------------------------------------------

wire    DMAstart;
wire    [31:0]  DMAsrc;
wire    [31:0]  DMAdst;
wire    [1:0]   DMAsize;
wire    [31:0]  DMAlen;

DMA MicroDMA(
        .HCLK                           (clk),
        .HRESETn                        (RSTn),
        .HADDRD                         (HADDRDM),
        .HTRANSD                        (HTRANSDM),
        .HSIZED                         (HSIZEDM),
        .HBURSTD                        (HBURSTDM),
        .HPROTD                         (HPROTDM),
        .HWRITED                        (HWRITEDM),
        .HWDATAD                        (HWDATADM),
        .HRDATAD                        (HRDATADM),
        .HREADYD                        (HREADYDM),
        .HRESPD                         (HRESPDM),
        .DMAstart                       (DMAstart),
        .DMAdst                         (DMAdst),
        .DMAdone                        (DMA_Event),
        .DMAsrc                         (DMAsrc),
        .DMAsize                        (DMAsize),
        .DMAlen                         (DMAlen)
);

//------------------------------------------------------------------------------
// AHB BUS MATRIX
//------------------------------------------------------------------------------

wire   [31:0] HADDR_ITCM;
wire    [1:0] HTRANS_ITCM;
wire          HWRITE_ITCM;
wire    [2:0] HSIZE_ITCM;
wire   [31:0] HWDATA_ITCM;
wire    [2:0] HBURST_ITCM;
wire    [3:0] HPROT_ITCM;
wire          HREADY_ITCM;
wire   [31:0] HRDATA_ITCM;
wire    [1:0] HRESP_ITCM;
wire          HREADYOUT_ITCM;
wire          HSEL_ITCM;

wire   [31:0] HADDR_ROM;
wire    [1:0] HTRANS_ROM;
wire          HWRITE_ROM;
wire    [2:0] HSIZE_ROM;
wire   [31:0] HWDATA_ROM;
wire    [2:0] HBURST_ROM;
wire    [3:0] HPROT_ROM;
wire          HREADY_ROM;
wire   [31:0] HRDATA_ROM;
wire    [1:0] HRESP_ROM;
wire          HREADYOUT_ROM;
wire          HSEL_ROM;

wire   [31:0] HADDR_DTCM;
wire    [1:0] HTRANS_DTCM;
wire          HWRITE_DTCM;
wire    [2:0] HSIZE_DTCM;
wire   [31:0] HWDATA_DTCM;
wire    [2:0] HBURST_DTCM;
wire    [3:0] HPROT_DTCM;
wire          HREADY_DTCM;
wire   [31:0] HRDATA_DTCM;
wire    [1:0] HRESP_DTCM;
wire          HREADYOUT_DTCM;
wire          HSEL_DTCM;

wire   [31:0] HADDR_DMAC;
wire    [1:0] HTRANS_DMAC;
wire          HWRITE_DMAC;
wire    [2:0] HSIZE_DMAC;
wire   [31:0] HWDATA_DMAC;
wire    [2:0] HBURST_DMAC;
wire    [3:0] HPROT_DMAC;
wire          HREADY_DMAC;
wire   [31:0] HRDATA_DMAC;
wire    [1:0] HRESP_DMAC;
wire          HREADYOUT_DMAC;
wire          HSEL_DMAC;

wire   [31:0] HADDR_GPIO;
wire    [1:0] HTRANS_GPIO;
wire          HWRITE_GPIO;
wire    [2:0] HSIZE_GPIO;
wire   [31:0] HWDATA_GPIO;
wire    [2:0] HBURST_GPIO;
wire    [3:0] HPROT_GPIO;
wire          HREADY_GPIO;
wire   [31:0] HRDATA_GPIO;
wire    [1:0] HRESP_GPIO;
wire          HREADYOUT_GPIO;
wire          HSEL_GPIO;

wire   [31:0] HADDR_TIMER;
wire    [1:0] HTRANS_TIMER;
wire          HWRITE_TIMER;
wire    [2:0] HSIZE_TIMER;
wire   [31:0] HWDATA_TIMER;
wire    [2:0] HBURST_TIMER;
wire    [3:0] HPROT_TIMER;
wire          HREADY_TIMER;
wire   [31:0] HRDATA_TIMER;
wire    [1:0] HRESP_TIMER;
wire          HREADYOUT_TIMER;
wire          HSEL_TIMER;

wire   [31:0] HADDR_SUB;
wire    [1:0] HTRANS_SUB;
wire          HWRITE_SUB;
wire    [2:0] HSIZE_SUB;
wire   [31:0] HWDATA_SUB;
wire    [2:0] HBURST_SUB;
wire    [3:0] HPROT_SUB;
wire          HREADY_SUB;
wire   [31:0] HRDATA_SUB;
wire    [1:0] HRESP_SUB;
wire          HREADYOUT_SUB;
wire          HSEL_SUB;

wire   [31:0] HADDR_UART;
wire    [1:0] HTRANS_UART;
wire          HWRITE_UART;
wire    [2:0] HSIZE_UART;
wire   [31:0] HWDATA_UART;
wire    [2:0] HBURST_UART;
wire    [3:0] HPROT_UART;
wire          HREADY_UART;
wire   [31:0] HRDATA_UART;
wire    [1:0] HRESP_UART;
wire          HREADYOUT_UART;
wire          HSEL_UART;

wire   [31:0] HADDR_CAMERA;
wire    [1:0] HTRANS_CAMERA;
wire          HWRITE_CAMERA;
wire    [2:0] HSIZE_CAMERA;
wire   [31:0] HWDATA_CAMERA;
wire    [2:0] HBURST_CAMERA;
wire    [3:0] HPROT_CAMERA;
wire          HREADY_CAMERA;
wire   [31:0] HRDATA_CAMERA;
wire    [1:0] HRESP_CAMERA;
wire          HREADYOUT_CAMERA;
wire          HSEL_CAMERA;

wire   [31:0] HADDR_OLED;
wire    [1:0] HTRANS_OLED;
wire          HWRITE_OLED;
wire    [2:0] HSIZE_OLED;
wire   [31:0] HWDATA_OLED;
wire    [2:0] HBURST_OLED;
wire    [3:0] HPROT_OLED;
wire          HREADY_OLED;
wire   [31:0] HRDATA_OLED;
wire    [1:0] HRESP_OLED;
wire          HREADYOUT_OLED;
wire          HSEL_OLED;

wire   [31:0] HADDR_ACCC;
wire    [1:0] HTRANS_ACCC;
wire          HWRITE_ACCC;
wire    [2:0] HSIZE_ACCC;
wire   [31:0] HWDATA_ACCC;
wire    [2:0] HBURST_ACCC;
wire    [3:0] HPROT_ACCC;
wire          HREADY_ACCC;
wire   [31:0] HRDATA_ACCC;
wire    [1:0] HRESP_ACCC;
wire          HREADYOUT_ACCC;
wire          HSEL_ACCC;

AHBlite_BusMatrix       BusMatrix(
        //      COMMON SINGALS
        .HCLK                           (clk),
        .HRESETn                        (cpuresetn),

        //      DCODE SIDE
        .HADDR_DCODE                    (HADDRD),
        .HTRANS_DCODE                   (HTRANSD),
        .HWRITE_DCODE                   (HWRITED),
        .HSIZE_DCODE                    (HSIZED),
        .HBURST_DCODE                   (HBURSTD),
        .HPROT_DCODE                    (HPROTD),
        .HWDATA_DCODE                   (HWDATAD),
        .HRDATA_DCODE                   (HRDATAD),
        .HREADY_DCODE                   (HREADYD),
        .HRESP_DCODE                    (HRESPD),

        //      ICODE SIDE
        .HADDR_ICODE                    (HADDRI),
        .HTRANS_ICODE                   (HTRANSI),
        .HWRITE_ICODE                   (1'b0),
        .HSIZE_ICODE                    (HSIZEI),
        .HBURST_ICODE                   (HBURSTI),
        .HPROT_ICODE                    (HPROTI),
        .HWDATA_ICODE                   (32'b0),
        .HRDATA_ICODE                   (HRDATAI),
        .HREADY_ICODE                   (HREADYI),
        .HRESP_ICODE                    (HRESPI),

        //      SYS SIDE
        .HADDR_SYS                      (HADDRS),
        .HTRANS_SYS                     (HTRANSS),
        .HWRITE_SYS                     (HWRITES),
        .HSIZE_SYS                      (HSIZES),
        .HBURST_SYS                     (HBURSTS),
        .HPROT_SYS                      (HPROTS),
        .HWDATA_SYS                     (HWDATAS),
        .HRDATA_SYS                     (HRDATAS),
        .HREADY_SYS                     (HREADYS),
        .HRESP_SYS                      (HRESPS),

        //      DMA SIDE
        .HADDR_DMA                      (HADDRDM),
        .HTRANS_DMA                     (HTRANSDM),
        .HWRITE_DMA                     (HWRITEDM),
        .HSIZE_DMA                      (HSIZEDM),
        .HBURST_DMA                     (HBURSTDM),
        .HPROT_DMA                      (HPROTDM),
        .HWDATA_DMA                     (HWDATADM),
        .HRDATA_DMA                     (HRDATADM),
        .HREADY_DMA                     (HREADYDM),
        .HRESP_DMA                      (HRESPDM),

        //      ACC SIDE
        .HADDR_ACC                      (HADDRA),
        .HTRANS_ACC                     (HTRANSA),
        .HWRITE_ACC                     (HWRITEA),
        .HSIZE_ACC                      (HSIZEA),
        .HBURST_ACC                     (HBURSTA),
        .HPROT_ACC                      (HPROTA),
        .HWDATA_ACC                     (HWDATAA),
        .HRDATA_ACC                     (HRDATAA),
        .HREADY_ACC                     (HREADYA),
        .HRESP_ACC                      (HRESPA),

        //      ITCM
        .HRDATA_ITCM                    (HRDATA_ITCM),
        .HREADYOUT_ITCM                 (HREADYOUT_ITCM),
        .HRESP_ITCM                     (HRESP_ITCM),
        .HSEL_ITCM                      (HSEL_ITCM),
        .HADDR_ITCM                     (HADDR_ITCM),
        .HTRANS_ITCM                    (HTRANS_ITCM),
        .HWRITE_ITCM                    (HWRITE_ITCM),
        .HSIZE_ITCM                     (HSIZE_ITCM),
        .HBURST_ITCM                    (HBURST_ITCM),
        .HPROT_ITCM                     (HPROT_ITCM),
        .HWDATA_ITCM                    (HWDATA_ITCM),
        .HREADY_ITCM                    (HREADY_ITCM),

        //      ROM
        .HRDATA_ROM                     (HRDATA_ROM),
        .HREADYOUT_ROM                  (HREADYOUT_ROM),
        .HRESP_ROM                      (HRESP_ROM),
        .HSEL_ROM                       (HSEL_ROM),
        .HADDR_ROM                      (HADDR_ROM),
        .HTRANS_ROM                     (HTRANS_ROM),
        .HWRITE_ROM                     (HWRITE_ROM),
        .HSIZE_ROM                      (HSIZE_ROM),
        .HBURST_ROM                     (HBURST_ROM),
        .HPROT_ROM                      (HPROT_ROM),
        .HWDATA_ROM                     (HWDATA_ROM),
        .HREADY_ROM                     (HREADY_ROM),

        //      DTCM
        .HRDATA_DTCM                    (HRDATA_DTCM),
        .HREADYOUT_DTCM                 (HREADYOUT_DTCM),
        .HRESP_DTCM                     (HRESP_DTCM),
        .HSEL_DTCM                      (HSEL_DTCM),
        .HADDR_DTCM                     (HADDR_DTCM),
        .HTRANS_DTCM                    (HTRANS_DTCM),
        .HWRITE_DTCM                    (HWRITE_DTCM),
        .HSIZE_DTCM                     (HSIZE_DTCM),
        .HBURST_DTCM                    (HBURST_DTCM),
        .HPROT_DTCM                     (HPROT_DTCM),
        .HWDATA_DTCM                    (HWDATA_DTCM),
        .HREADY_DTCM                    (HREADY_DTCM),

        //      CAMERA
        .HRDATA_CAMERA                  (HRDATA_CAMERA),
        .HREADYOUT_CAMERA               (HREADYOUT_CAMERA),
        .HRESP_CAMERA                   (HRESP_CAMERA),
        .HSEL_CAMERA                    (HSEL_CAMERA),
        .HADDR_CAMERA                   (HADDR_CAMERA),
        .HTRANS_CAMERA                  (HTRANS_CAMERA),
        .HWRITE_CAMERA                  (HWRITE_CAMERA),
        .HSIZE_CAMERA                   (HSIZE_CAMERA),
        .HBURST_CAMERA                  (HBURST_CAMERA),
        .HPROT_CAMERA                   (HPROT_CAMERA),
        .HWDATA_CAMERA                  (HWDATA_CAMERA),
        .HREADY_CAMERA                  (HREADY_CAMERA),

        //      SUB
        .HRDATA_SUB                     (HRDATA_SUB),
        .HREADYOUT_SUB                  (HREADY_SUB),
        .HRESP_SUB                      (HRESP_SUB),
        .HSEL_SUB                       (HSEL_SUB),
        .HADDR_SUB                      (HADDR_SUB),
        .HTRANS_SUB                     (HTRANS_SUB),
        .HWRITE_SUB                     (HWRITE_SUB),
        .HSIZE_SUB                      (HSIZE_SUB),
        .HBURST_SUB                     (HBURST_SUB),
        .HPROT_SUB                      (HPROT_SUB),
        .HWDATA_SUB                     (HWDATA_SUB),
        .HREADY_SUB                     (/*********/),

        //      ACCC
        .HRDATA_ACCC                    (HRDATA_ACCC),
        .HREADYOUT_ACCC                 (HREADYOUT_ACCC),
        .HRESP_ACCC                     (HRESP_ACCC),
        .HSEL_ACCC                      (HSEL_ACCC),
        .HADDR_ACCC                     (HADDR_ACCC),
        .HTRANS_ACCC                    (HTRANS_ACCC),
        .HWRITE_ACCC                    (HWRITE_ACCC),
        .HSIZE_ACCC                     (HSIZE_ACCC),
        .HBURST_ACCC                    (HBURST_ACCC),
        .HPROT_ACCC                     (HPROT_ACCC),
        .HWDATA_ACCC                    (HWDATA_ACCC),
        .HREADY_ACCC                    (HREADY_ACCC)
);

AHBlite_SubBus       SubBus(
        //      COMMON SINGALS
        .HCLK                           (clk),
        .HRESETn                        (cpuresetn),

        //      DMA SIDE
        .HADDR_SUB                      (HADDR_SUB),
        .HTRANS_SUB                     (HTRANS_SUB),
        .HWRITE_SUB                     (HWRITE_SUB),
        .HSIZE_SUB                      (HSIZE_SUB),
        .HBURST_SUB                     (HBURST_SUB),
        .HPROT_SUB                      (HPROT_SUB),
        .HWDATA_SUB                     (HWDATA_SUB),
        .HRDATA_SUB                     (HRDATA_SUB),
        .HREADY_SUB                     (HREADY_SUB),
        .HRESP_SUB                      (HRESP_SUB),

        //      DMAC
        .HRDATA_DMAC                    (HRDATA_DMAC),
        .HREADYOUT_DMAC                 (HREADYOUT_DMAC),
        .HRESP_DMAC                     (HRESP_DMAC),
        .HSEL_DMAC                      (HSEL_DMAC),
        .HADDR_DMAC                     (HADDR_DMAC),
        .HTRANS_DMAC                    (HTRANS_DMAC),
        .HWRITE_DMAC                    (HWRITE_DMAC),
        .HSIZE_DMAC                     (HSIZE_DMAC),
        .HBURST_DMAC                    (HBURST_DMAC),
        .HPROT_DMAC                     (HPROT_DMAC),
        .HWDATA_DMAC                    (HWDATA_DMAC),
        .HREADY_DMAC                    (HREADY_DMAC),

        //      GPIO
        .HRDATA_GPIO                    (HRDATA_GPIO),
        .HREADYOUT_GPIO                 (HREADYOUT_GPIO),
        .HRESP_GPIO                     (HRESP_GPIO),
        .HSEL_GPIO                      (HSEL_GPIO),
        .HADDR_GPIO                     (HADDR_GPIO),
        .HTRANS_GPIO                    (HTRANS_GPIO),
        .HWRITE_GPIO                    (HWRITE_GPIO),
        .HSIZE_GPIO                     (HSIZE_GPIO),
        .HBURST_GPIO                    (HBURST_GPIO),
        .HPROT_GPIO                     (HPROT_GPIO),
        .HWDATA_GPIO                    (HWDATA_GPIO),
        .HREADY_GPIO                    (HREADY_GPIO),

        //      UART
        .HRDATA_UART                    (HRDATA_UART),
        .HREADYOUT_UART                 (HREADYOUT_UART),
        .HRESP_UART                     (HRESP_UART),
        .HSEL_UART                      (HSEL_UART),
        .HADDR_UART                     (HADDR_UART),
        .HTRANS_UART                    (HTRANS_UART),
        .HWRITE_UART                    (HWRITE_UART),
        .HSIZE_UART                     (HSIZE_UART),
        .HBURST_UART                    (HBURST_UART),
        .HPROT_UART                     (HPROT_UART),
        .HWDATA_UART                    (HWDATA_UART),
        .HREADY_UART                    (HREADY_UART),

        //      OLED
        .HRDATA_OLED                    (HRDATA_OLED),
        .HREADYOUT_OLED                 (HREADYOUT_OLED),
        .HRESP_OLED                     (HRESP_OLED),
        .HSEL_OLED                      (HSEL_OLED),
        .HADDR_OLED                     (HADDR_OLED),
        .HTRANS_OLED                    (HTRANS_OLED),
        .HWRITE_OLED                    (HWRITE_OLED),
        .HSIZE_OLED                     (HSIZE_OLED),
        .HBURST_OLED                    (HBURST_OLED),
        .HPROT_OLED                     (HPROT_OLED),
        .HWDATA_OLED                    (HWDATA_OLED),
        .HREADY_OLED                    (HREADY_OLED),

        //      TIMER
        .HRDATA_TIMER                    (HRDATA_TIMER),
        .HREADYOUT_TIMER                 (HREADYOUT_TIMER),
        .HRESP_TIMER                     (HRESP_TIMER),
        .HSEL_TIMER                      (HSEL_TIMER),
        .HADDR_TIMER                     (HADDR_TIMER),
        .HTRANS_TIMER                    (HTRANS_TIMER),
        .HWRITE_TIMER                    (HWRITE_TIMER),
        .HSIZE_TIMER                     (HSIZE_TIMER),
        .HBURST_TIMER                    (HBURST_TIMER),
        .HPROT_TIMER                     (HPROT_TIMER),
        .HWDATA_TIMER                    (HWDATA_TIMER),
        .HREADY_TIMER                    (HREADY_TIMER)
);

//------------------------------------------------------------------------------
// AHB ITCM
//------------------------------------------------------------------------------

wire [12:0] ITCM_RDADDR;
wire [12:0] ITCM_WRADDR;
wire [31:0] ITCM_RDATA,ITCM_WDATA;
wire [3:0] ITCM_WRITE;

AHBlite_Block_RAM #(
        .ADDR_WIDTH                     (13)
)       ITCM_Interface(
        .HCLK                           (clk),
        .HREADY                         (HREADY_ITCM),
        .HRESETn                        (cpuresetn),
        .HSEL                           (HSEL_ITCM),
        .HADDR                          (HADDR_ITCM),
        .HPROT                          (HPROT_ITCM),
        .HSIZE                          (HSIZE_ITCM),
        .HTRANS                         (HTRANS_ITCM),
        .HWRITE                         (HWRITE_ITCM),
        .HRDATA                         (HRDATA_ITCM),
        .HREADYOUT                      (HREADYOUT_ITCM),
        .HRESP                          (HRESP_ITCM),
        .HWDATA                         (HWDATA_ITCM),
        .BRAM_RDADDR                    (ITCM_RDADDR),
        .BRAM_WRADDR                    (ITCM_WRADDR),
        .BRAM_RDATA                     (ITCM_RDATA),
        .BRAM_WDATA                     (ITCM_WDATA),
        .BRAM_WRITE                     (ITCM_WRITE)
);

//------------------------------------------------------------------------------
// AHB ROM
//------------------------------------------------------------------------------

wire [12:0] ROM_ADDR;
wire [31:0] ROM_RDATA;

AHBlite_Block_ROM #(
        .ADDR_WIDTH                     (13)
)       ROM_Interface(
        .HCLK                           (clk),
        .HREADY                         (HREADY_ROM),
        .HRESETn                        (cpuresetn),
        .HSEL                           (HSEL_ROM),
        .HADDR                          (HADDR_ROM),
        .HPROT                          (HPROT_ROM),
        .HSIZE                          (HSIZE_ROM),
        .HTRANS                         (HTRANS_ROM),
        .HWRITE                         (HWRITE_ROM),
        .HRDATA                         (HRDATA_ROM),
        .HREADYOUT                      (HREADYOUT_ROM),
        .HRESP                          (HRESP_ROM),
        .HWDATA                         (HWDATA_ROM),
        .BRAM_ADDR                      (ROM_ADDR),
        .BRAM_RDATA                     (ROM_RDATA)
);

//------------------------------------------------------------------------------
// AHB DTCM
//------------------------------------------------------------------------------

wire [9:0] DTCM_RDADDR;
wire [9:0] DTCM_WRADDR;
wire [31:0] DTCM_RDATA,DTCM_WDATA;
wire [3:0] DTCM_WRITE;

AHBlite_Block_RAM #(
        .ADDR_WIDTH                     (10)
)       DTCM_Interface(
        .HCLK                           (clk),
        .HRESETn                        (cpuresetn),
        .HADDR                          (HADDR_DTCM),
        .HPROT                          (HPROT_DTCM),
        .HSEL                           (HSEL_DTCM),
        .HSIZE                          (HSIZE_DTCM),
        .HTRANS                         (HTRANS_DTCM),
        .HWRITE                         (HWRITE_DTCM),
        .HRDATA                         (HRDATA_DTCM),
        .HREADY                         (HREADY_DTCM),
        .HREADYOUT                      (HREADYOUT_DTCM),
        .HRESP                          (HRESP_DTCM),
        .HWDATA                         (HWDATA_DTCM),
        .BRAM_RDADDR                    (DTCM_RDADDR),
        .BRAM_WRADDR                    (DTCM_WRADDR),
        .BRAM_RDATA                     (DTCM_RDATA),
        .BRAM_WDATA                     (DTCM_WDATA),
        .BRAM_WRITE                     (DTCM_WRITE)
);

//------------------------------------------------------------------------------
// AHB DMAC
//------------------------------------------------------------------------------

AHBlite_DMAC DMAC_Interface(
        .HCLK                           (clk),
        .HRESETn                        (cpuresetn),
        .HADDR                          (HADDR_DMAC),
        .HPROT                          (HPROT_DMAC),
        .HSEL                           (HSEL_DMAC),
        .HSIZE                          (HSIZE_DMAC),
        .HTRANS                         (HTRANS_DMAC),
        .HWRITE                         (HWRITE_DMAC),
        .HRDATA                         (HRDATA_DMAC),
        .HREADY                         (HREADY_DMAC),
        .HREADYOUT                      (HREADYOUT_DMAC),
        .HRESP                          (HRESP_DMAC),
        .HWDATA                         (HWDATA_DMAC),
        .SLEEPing                       (SLEEPing),
        .DMAstart                       (DMAstart),
        .DMAdst                         (DMAdst),
        .DMAsrc                         (DMAsrc),
        .DMAsize                        (DMAsize),
        .DMAlen                         (DMAlen)
);

//------------------------------------------------------------------------------
// AHB GPIO
//------------------------------------------------------------------------------

wire    [15:0]    DIR;
wire    [15:0]    WDATA;
wire    [15:0]    RDATA;

AHBlite_GPIO #(
        .GPIO_WIDTH                     (16)
)       GPIO_Interface(
        .HCLK                           (clk),
        .HRESETn                        (cpuresetn),
        .HADDR                          (HADDR_GPIO),
        .HPROT                          (HPROT_GPIO),
        .HSEL                           (HSEL_GPIO),
        .HSIZE                          (HSIZE_GPIO),
        .HTRANS                         (HTRANS_GPIO),
        .HWRITE                         (HWRITE_GPIO),
        .HRDATA                         (HRDATA_GPIO),
        .HREADY                         (HREADY_GPIO),
        .HREADYOUT                      (HREADYOUT_GPIO),
        .HRESP                          (HRESP_GPIO),
        .HWDATA                         (HWDATA_GPIO),
        .DIR                            (DIR),
        .WDATA                          (WDATA),
        .RDATA                          (RDATA)
);

//------------------------------------------------------------------------------
// AHB CAMERA
//------------------------------------------------------------------------------

wire    [12:0]    Camera_ADDR;
wire    [31:0]    Camera_RDATA;
wire              Camera_VALID;
wire              Camera_READY;
wire              REG_READY;
wire    [31:0]    CNT;

AHBlite_CAMERA #(
        .SimPresent                     (SimPresent)
)       CAMERA_Interface(
        .HCLK                           (clk),
        .HRESETn                        (cpuresetn),
        .HADDR                          (HADDR_CAMERA),
        .HPROT                          (HPROT_CAMERA),
        .HSEL                           (HSEL_CAMERA),
        .HSIZE                          (HSIZE_CAMERA),
        .HTRANS                         (HTRANS_CAMERA),
        .HWRITE                         (HWRITE_CAMERA),
        .HRDATA                         (HRDATA_CAMERA),
        .HREADY                         (HREADY_CAMERA),
        .HREADYOUT                      (HREADYOUT_CAMERA),
        .HRESP                          (HRESP_CAMERA),
        .HWDATA                         (HWDATA_CAMERA),
        .ADDR                           (Camera_ADDR),
        .RDATA                          (Camera_RDATA),
        .DATA_VALID                     (Camera_VALID),
        .DATA_READY                     (Camera_READY),
        .PWDN                           (CAMERA_PWDN),
        .RST                            (CAMERA_RST),
        .CAMERA_SCL                     (CAMERA_SCL),
        .CAMERA_SDA                     (CAMERA_SDA)
);

//------------------------------------------------------------------------------
// AHB OLED
//------------------------------------------------------------------------------

AHBlite_OLED OLED_Interface(
        .HCLK                           (clk),
        .HRESETn                        (cpuresetn),
        .HADDR                          (HADDR_OLED),
        .HPROT                          (HPROT_OLED),
        .HSEL                           (HSEL_OLED),
        .HSIZE                          (HSIZE_OLED),
        .HTRANS                         (HTRANS_OLED),
        .HWRITE                         (HWRITE_OLED),
        .HRDATA                         (HRDATA_OLED),
        .HREADY                         (HREADY_OLED),
        .HREADYOUT                      (HREADYOUT_OLED),
        .HRESP                          (HRESP_OLED),
        .HWDATA                         (HWDATA_OLED),
        .OLED_SCLK                      (OLED_SCLK),
        .OLED_SDIN                      (OLED_SDIN)
);

//------------------------------------------------------------------------------
// AHB TIMER
//------------------------------------------------------------------------------

wire    TimerRst;
wire    TimerEn;

AHBlite_TIMER TIMER_Interface(
        .HCLK                           (clk),
        .HRESETn                        (cpuresetn),
        .HADDR                          (HADDR_TIMER),
        .HPROT                          (HPROT_TIMER),
        .HSEL                           (HSEL_TIMER),
        .HSIZE                          (HSIZE_TIMER),
        .HTRANS                         (HTRANS_TIMER),
        .HWRITE                         (HWRITE_TIMER),
        .HRDATA                         (HRDATA_TIMER),
        .HREADY                         (HREADY_TIMER),
        .HREADYOUT                      (HREADYOUT_TIMER),
        .HRESP                          (HRESP_TIMER),
        .HWDATA                         (HWDATA_TIMER),
        .TimerRst_o                     (TimerRst),
        .TimerEn_o                      (TimerEn)
);

//------------------------------------------------------------------------------
// AHB ACCC   
//------------------------------------------------------------------------------

wire    [5:0]               Data_RAM_RD_Addr;
wire    [23:0]              Data_RAM_RD_Data;
wire    [8:0]               Weight_RAM_RD_Addr;
wire    [191:0]             Weight_RAM_RD_Data;
wire    [7:0]               Num0;
wire    [7:0]               Num1;
wire    [7:0]               Num2;
wire    [7:0]               Num3;
wire    [7:0]               Num4;
wire    [7:0]               Num5;
wire    [7:0]               Num6;
wire    [7:0]               Num7;
wire    [7:0]               Num8;
wire    [7:0]               Num9;
wire                        ACC_VALID;
wire                        ACC_READY;

AHBlite_ACCC ACCC_Interface(
        .HCLK                           (clk),
        .HRESETn                        (cpuresetn),
        .HADDR                          (HADDR_ACCC),
        .HPROT                          (HPROT_ACCC),
        .HSEL                           (HSEL_ACCC),
        .HSIZE                          (HSIZE_ACCC),
        .HTRANS                         (HTRANS_ACCC),
        .HWRITE                         (HWRITE_ACCC),
        .HRDATA                         (HRDATA_ACCC),
        .HREADY                         (HREADY_ACCC),
        .HREADYOUT                      (HREADYOUT_ACCC),
        .HRESP                          (HRESP_ACCC),
        .HWDATA                         (HWDATA_ACCC),
        .Data_RAM_RD_Addr               (Data_RAM_RD_Addr),
        .Data_RAM_RD_Data               (Data_RAM_RD_Data),
        .Weight_RAM_RD_Addr             (Weight_RAM_RD_Addr),
        .Weight_RAM_RD_Data             (Weight_RAM_RD_Data),
        .Num0                           (Num0),
        .Num1                           (Num1),
        .Num2                           (Num2),
        .Num3                           (Num3),
        .Num4                           (Num4),
        .Num5                           (Num5),
        .Num6                           (Num6),
        .Num7                           (Num7),
        .Num8                           (Num8),
        .Num9                           (Num9),
        .ACC_READY                      (ACC_READY),
        .ACC_VALID                      (ACC_VALID)
);

//------------------------------------------------------------------------------
// AHB UART
//------------------------------------------------------------------------------

wire state;
wire [7:0] UART_RX_data;
wire [7:0] UART_TX_data;
wire tx_en;

AHBlite_UART UART_Interface(
        .HCLK                           (clk),
        .HRESETn                        (cpuresetn),
        .HSEL                           (HSEL_UART),
        .HADDR                          (HADDR_UART),
        .HPROT                          (HPROT_UART),
        .HSIZE                          (HSIZE_UART),
        .HTRANS                         (HTRANS_UART),
        .HWDATA                         (HWDATA_UART),
        .HWRITE                         (HWRITE_UART),
        .HRDATA                         (HRDATA_UART),
        .HREADY                         (HREADY_UART),
        .HREADYOUT                      (HREADYOUT_UART),
        .HRESP                          (HRESP_UART),
        .UART_RX                        (UART_RX_data),
        .state                          (state),
        .tx_en                          (tx_en),
        .UART_TX                        (UART_TX_data)
);

//------------------------------------------------------------------------------
// Block TCM RAM
//------------------------------------------------------------------------------

Block_RAM #(
        .ADDR_WIDTH                     (13)
)       ITCM(
        .clka                           (clk),
        .addra                          (ITCM_WRADDR),
        .addrb                          (ITCM_RDADDR),
        .dina                           (ITCM_WDATA),
        .doutb                          (ITCM_RDATA),
        .wea                            (ITCM_WRITE)
);

Block_RAM #(
        .ADDR_WIDTH                     (10)
)       DTCM(
        .clka                           (clk),
        .addra                          (DTCM_WRADDR),
        .addrb                          (DTCM_RDADDR),
        .dina                           (DTCM_WDATA),
        .doutb                          (DTCM_RDATA),
        .wea                            (DTCM_WRITE)
);

//------------------------------------------------------------------------------
// Block ROM RAM
//------------------------------------------------------------------------------

Block_ROM #(
        .ADDR_WIDTH                     (13)
)       ROM(
        .clka                           (clk),
        .addra                          (ROM_ADDR),
        .douta                          (ROM_RDATA)
);

//------------------------------------------------------------------------------
// GPIO TRI BUF
//------------------------------------------------------------------------------

GPIO #(
        .GPIO_WIDTH                     (16),
        .SimPresent                     (SimPresent)
)       GPIO(
        .DIR                            (DIR),
        .RDATA                          (RDATA),
        .WDATA                          (WDATA),
        .GPIO                           (GPIO_PIN)
);

//------------------------------------------------------------------------------
// CAMERA
//------------------------------------------------------------------------------

CAMERA_Capture CAMERA(
        .HCLK                           (clk),
        .PCLK                           (pclk),
        .HRESETn                        (cpuresetn),
        .DATA_VALID                     (Camera_VALID),
        .DATA_READY                     (Camera_READY),
        .DualRAM_RADDR                  (Camera_ADDR),
        .DualRAM_RDATA                  (Camera_RDATA),
        .Camera_idata                   (CAMERA_DATA),
        .VSYNC                          (CAMERA_VSYNC),
        .HREF                           (CAMERA_HREF)
);

//------------------------------------------------------------------------------
// UART
//------------------------------------------------------------------------------

wire clk_uart;
wire bps_en;
wire bps_en_rx,bps_en_tx;

assign bps_en = bps_en_rx | bps_en_tx;

clkuart_pwm clkuart_pwm(
        .clk                            (clk),
        .RSTn                           (cpuresetn),
        .clk_uart                       (clk_uart),
        .bps_en                         (bps_en)
);

UART_RX UART_RX(
        .clk                            (clk),
        .clk_uart                       (clk_uart),
        .RSTn                           (cpuresetn),
        .RXD                            (RXD),
        .data                           (UART_RX_data),
        .interrupt                      (uart_interrupt),
        .bps_en                         (bps_en_rx)
);

UART_TX UART_TX(
        .clk                            (clk),
        .clk_uart                       (clk_uart),
        .RSTn                           (cpuresetn),
        .data                           (UART_TX_data),
        .tx_en                          (tx_en),
        .TXD                            (TXD),
        .state                          (state),
        .bps_en                         (bps_en_tx)
);

//------------------------------------------------------------------------------
// ACC
//------------------------------------------------------------------------------

ACC     ACC(
        .clk                            (clk),
        .rstn                           (cpuresetn),
        .AccValid_i                     (ACC_VALID),
        .AccReady_o                     (ACC_READY),
        .DataRamAddr_o                  (Data_RAM_RD_Addr),
        .DataRamData_i                  (Data_RAM_RD_Data),
        .WtRamAddr_o                    (Weight_RAM_RD_Addr),
        .WtRamData_i                    (Weight_RAM_RD_Data),
        .Num0_o                         (Num0),
        .Num1_o                         (Num1),
        .Num2_o                         (Num2),
        .Num3_o                         (Num3),
        .Num4_o                         (Num4),
        .Num5_o                         (Num5),
        .Num6_o                         (Num6),
        .Num7_o                         (Num7),
        .Num8_o                         (Num8),
        .Num9_o                         (Num9)
);

//------------------------------------------------------------------------------
// TIMER
//------------------------------------------------------------------------------

clktimer_pwm clktimer_pwm(
        .clk                            (clk),
        .RSTn                           (cpuresetn),
        .clk_timer                      (clk_timer)
);

Timer Timer(
        .clk                            (clk),
        .rstn                           (cpuresetn),
        .clk_timer                      (clk_timer),
        .TimerRst_i                     (TimerRst),
        .TimerEn_i                      (TimerEn),
        .Sec_o                          (Sec),
        .Tenth_o                        (Tenth),
        .Perc_o                         (Perc)
);

endmodule