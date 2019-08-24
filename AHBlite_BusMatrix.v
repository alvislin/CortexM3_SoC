module AHBlite_BusMatrix    (
    //  COMMON SIGANLS
    input               HCLK,
    input               HRESETn,

    //  INPUTPORT DCODE
    input       [31:0]  HADDR_DCODE,
    input       [1:0]   HTRANS_DCODE,
    input               HWRITE_DCODE,
    input       [2:0]   HSIZE_DCODE,
    input       [2:0]   HBURST_DCODE,
    input       [3:0]   HPROT_DCODE,
    input       [31:0]  HWDATA_DCODE,
    //  OUTPUTPORT DCODE
    output wire [31:0]  HRDATA_DCODE,
    output wire         HREADY_DCODE,
    output wire [1:0]   HRESP_DCODE,

    //  INPUTPORT ICODE
    input       [31:0]  HADDR_ICODE,
    input       [1:0]   HTRANS_ICODE,
    input               HWRITE_ICODE,
    input       [2:0]   HSIZE_ICODE,
    input       [2:0]   HBURST_ICODE,
    input       [3:0]   HPROT_ICODE,
    input       [31:0]  HWDATA_ICODE,
    //  OUTPUTPORT ICODE
    output wire [31:0]  HRDATA_ICODE,
    output wire         HREADY_ICODE,
    output wire [1:0]   HRESP_ICODE,

    //  INPUTPORT SYS
    input       [31:0]  HADDR_SYS,
    input       [1:0]   HTRANS_SYS,
    input               HWRITE_SYS,
    input       [2:0]   HSIZE_SYS,
    input       [2:0]   HBURST_SYS,
    input       [3:0]   HPROT_SYS,
    input       [31:0]  HWDATA_SYS,
    //  OUTPUTPORT SYS
    output wire [31:0]  HRDATA_SYS,
    output wire         HREADY_SYS,
    output wire [1:0]   HRESP_SYS,

    //  INPUTPORT DMA
    input       [31:0]  HADDR_DMA,
    input       [1:0]   HTRANS_DMA,
    input               HWRITE_DMA,
    input       [2:0]   HSIZE_DMA,
    input       [2:0]   HBURST_DMA,
    input       [3:0]   HPROT_DMA,
    input       [31:0]  HWDATA_DMA,
    //  OUTPUTPORT DMA
    output wire [31:0]  HRDATA_DMA,
    output wire         HREADY_DMA,
    output wire [1:0]   HRESP_DMA,

    //  INPUTPORT ACC
    input       [31:0]  HADDR_ACC,
    input       [1:0]   HTRANS_ACC,
    input               HWRITE_ACC,
    input       [2:0]   HSIZE_ACC,
    input       [2:0]   HBURST_ACC,
    input       [3:0]   HPROT_ACC,
    input       [31:0]  HWDATA_ACC,
    //  OUTPUTPORT DCODE
    output wire [31:0]  HRDATA_ACC,
    output wire         HREADY_ACC,
    output wire [1:0]   HRESP_ACC,

    //  INPUTPORT  ITCM
    input       [31:0]  HRDATA_ITCM,
    input               HREADYOUT_ITCM,
    input       [1:0]   HRESP_ITCM,
    //  OUTPUTPORT  ITCM
    output wire         HSEL_ITCM,
    output wire [31:0]  HADDR_ITCM,
    output wire [1:0]   HTRANS_ITCM,
    output wire         HWRITE_ITCM,
    output wire [2:0]   HSIZE_ITCM,
    output wire [2:0]   HBURST_ITCM,
    output wire [3:0]   HPROT_ITCM,
    output wire [31:0]  HWDATA_ITCM,
    output wire         HREADY_ITCM, 

    //  INPUTPORT  ROM
    input       [31:0]  HRDATA_ROM,
    input               HREADYOUT_ROM,
    input       [1:0]   HRESP_ROM,
    //  OUTPUTPORT  ROM
    output wire         HSEL_ROM,
    output wire [31:0]  HADDR_ROM,
    output wire [1:0]   HTRANS_ROM,
    output wire         HWRITE_ROM,
    output wire [2:0]   HSIZE_ROM,
    output wire [2:0]   HBURST_ROM,
    output wire [3:0]   HPROT_ROM,
    output wire [31:0]  HWDATA_ROM,
    output wire         HREADY_ROM,       

    //  INPUTPORT  DTCM
    input       [31:0]  HRDATA_DTCM,
    input               HREADYOUT_DTCM,
    input       [1:0]   HRESP_DTCM,
    //  OUTPUTPORT  DTCM
    output wire         HSEL_DTCM,
    output wire [31:0]  HADDR_DTCM,
    output wire [1:0]   HTRANS_DTCM,
    output wire         HWRITE_DTCM,
    output wire [2:0]   HSIZE_DTCM,
    output wire [2:0]   HBURST_DTCM,
    output wire [3:0]   HPROT_DTCM,
    output wire [31:0]  HWDATA_DTCM,
    output wire         HREADY_DTCM,     

    //  INPUTPORT  SUB
    input       [31:0]  HRDATA_SUB,
    input               HREADYOUT_SUB,
    input       [1:0]   HRESP_SUB,
    //  OUTPUTPORT  GPIO
    output wire         HSEL_SUB,
    output wire [31:0]  HADDR_SUB,
    output wire [1:0]   HTRANS_SUB,
    output wire         HWRITE_SUB,
    output wire [2:0]   HSIZE_SUB,
    output wire [2:0]   HBURST_SUB,
    output wire [3:0]   HPROT_SUB,
    output wire [31:0]  HWDATA_SUB,
    output wire         HREADY_SUB,  

    //  INPUTPORT  CAMERA
    input       [31:0]  HRDATA_CAMERA,
    input               HREADYOUT_CAMERA,
    input       [1:0]   HRESP_CAMERA,
    //  OUTPUTPORT  CAMERA
    output wire         HSEL_CAMERA,
    output wire [31:0]  HADDR_CAMERA,
    output wire [1:0]   HTRANS_CAMERA,
    output wire         HWRITE_CAMERA,
    output wire [2:0]   HSIZE_CAMERA,
    output wire [2:0]   HBURST_CAMERA,
    output wire [3:0]   HPROT_CAMERA,
    output wire [31:0]  HWDATA_CAMERA,
    output wire         HREADY_CAMERA,  

    //  INPUTPORT  ACCC
    input       [31:0]  HRDATA_ACCC,
    input               HREADYOUT_ACCC,
    input       [1:0]   HRESP_ACCC,
    //  OUTPUTPORT  ACCC
    output wire         HSEL_ACCC,
    output wire [31:0]  HADDR_ACCC,
    output wire [1:0]   HTRANS_ACCC,
    output wire         HWRITE_ACCC,
    output wire [2:0]   HSIZE_ACCC,
    output wire [2:0]   HBURST_ACCC,
    output wire [3:0]   HPROT_ACCC,
    output wire [31:0]  HWDATA_ACCC,
    output wire         HREADY_ACCC

);

wire    HREADYOUT_DCODE;
assign  HREADY_DCODE    =   HREADYOUT_DCODE;
wire    active_decoder_dcode;
wire    hreadyout_decoder_dcode;
wire    [1:0]   hresp_decoder_dcode;
wire    [31:0]  haddr_inputstage_dcode;
wire    [1:0]   htrans_inputstage_dcode;
wire            hwrite_inputstage_dcode;
wire    [2:0]   hsize_inputstage_dcode;
wire    [2:0]   hburst_inputstage_dcode;
wire    [3:0]   hprot_inputstage_dcode;
wire            trans_hold_dcode;

AHBlite_BusMatrix_Inputstage DCODE_INPUT(
    //  COMMON SIGNALS
    .HCLK       (HCLK),
    .HRESETn    (HRESETn),

    //  MASTOR  SIDE
    .HADDR      (HADDR_DCODE),
    .HTRANS     (HTRANS_DCODE),
    .HWRITE     (HWRITE_DCODE),
    .HSIZE      (HSIZE_DCODE),
    .HBURST     (HBURST_DCODE),
    .HPROT      (HPROT_DCODE),
    .HREADY     (HREADYOUT_DCODE),
    .HREADYOUT  (HREADYOUT_DCODE),
    .HRESP      (HRESP_DCODE),

    //  INTERNAL SIDE
    .ACTIVE_Decoder (active_decoder_dcode),
    .HREADYOUT_Decoder  (hreadyout_decoder_dcode),
    .HRESP_Decoder  (hresp_decoder_dcode),
    .HADDR_Inputstage   (haddr_inputstage_dcode),
    .HTRANS_Inputstage  (htrans_inputstage_dcode),
    .HWRITE_Inputstage  (hwrite_inputstage_dcode),
    .HSIZE_Inputstage   (hsize_inputstage_dcode),
    .HBURST_Inputstage  (hburst_inputstage_dcode),
    .HPROT_Inputstage   (hprot_inputstage_dcode),
    .TRANS_HOLD        (trans_hold_dcode)
);

wire    HREADYOUT_ICODE;
assign  HREADY_ICODE    =   HREADYOUT_ICODE;
wire    active_decoder_icode;
wire    hreadyout_decoder_icode;
wire    [1:0]   hresp_decoder_icode;
wire    [31:0]  haddr_inputstage_icode;
wire    [1:0]   htrans_inputstage_icode;
wire            hwrite_inputstage_icode;
wire    [2:0]   hsize_inputstage_icode;
wire    [2:0]   hburst_inputstage_icode;
wire    [3:0]   hprot_inputstage_icode;
wire            trans_hold_icode;

AHBlite_BusMatrix_Inputstage ICODE_INPUT(
    //  COMMON SIGNALS
    .HCLK       (HCLK),
    .HRESETn    (HRESETn),

    //  MASTOR  SIDE
    .HADDR      (HADDR_ICODE),
    .HTRANS     (HTRANS_ICODE),
    .HWRITE     (HWRITE_ICODE),
    .HSIZE      (HSIZE_ICODE),
    .HBURST     (HBURST_ICODE),
    .HPROT      (HPROT_ICODE),
    .HREADY     (HREADYOUT_ICODE),
    .HREADYOUT  (HREADYOUT_ICODE),
    .HRESP      (HRESP_ICODE),

    //  INTERNAL SIDE
    .ACTIVE_Decoder (active_decoder_icode),
    .HREADYOUT_Decoder  (hreadyout_decoder_icode),
    .HRESP_Decoder  (hresp_decoder_icode),
    .HADDR_Inputstage   (haddr_inputstage_icode),
    .HTRANS_Inputstage  (htrans_inputstage_icode),
    .HWRITE_Inputstage  (hwrite_inputstage_icode),
    .HSIZE_Inputstage   (hsize_inputstage_icode),
    .HBURST_Inputstage  (hburst_inputstage_icode),
    .HPROT_Inputstage   (hprot_inputstage_icode),
    .TRANS_HOLD        (trans_hold_icode)
);

wire    HREADYOUT_SYS;
assign  HREADY_SYS    =   HREADYOUT_SYS;
wire    active_decoder_sys;
wire    hreadyout_decoder_sys;
wire    [1:0]   hresp_decoder_sys;
wire    [31:0]  haddr_inputstage_sys;
wire    [1:0]   htrans_inputstage_sys;
wire            hwrite_inputstage_sys;
wire    [2:0]   hsize_inputstage_sys;
wire    [2:0]   hburst_inputstage_sys;
wire    [3:0]   hprot_inputstage_sys;
wire            trans_hold_sys;

AHBlite_BusMatrix_Inputstage SYS_INPUT(
    //  COMMON SIGNALS
    .HCLK       (HCLK),
    .HRESETn    (HRESETn),

    //  MASTOR  SIDE
    .HADDR      (HADDR_SYS),
    .HTRANS     (HTRANS_SYS),
    .HWRITE     (HWRITE_SYS),
    .HSIZE      (HSIZE_SYS),
    .HBURST     (HBURST_SYS),
    .HPROT      (HPROT_SYS),
    .HREADY     (HREADYOUT_SYS),
    .HREADYOUT  (HREADYOUT_SYS),
    .HRESP      (HRESP_SYS),

    //  INTERNAL SIDE
    .ACTIVE_Decoder (active_decoder_sys),
    .HREADYOUT_Decoder  (hreadyout_decoder_sys),
    .HRESP_Decoder  (hresp_decoder_sys),
    .HADDR_Inputstage   (haddr_inputstage_sys),
    .HTRANS_Inputstage  (htrans_inputstage_sys),
    .HWRITE_Inputstage  (hwrite_inputstage_sys),
    .HSIZE_Inputstage   (hsize_inputstage_sys),
    .HBURST_Inputstage  (hburst_inputstage_sys),
    .HPROT_Inputstage   (hprot_inputstage_sys),
    .TRANS_HOLD        (trans_hold_sys)
);

wire    HREADYOUT_DMA;
assign  HREADY_DMA    =   HREADYOUT_DMA;
wire    active_decoder_dma;
wire    hreadyout_decoder_dma;
wire    [1:0]   hresp_decoder_dma;
wire    [31:0]  haddr_inputstage_dma;
wire    [1:0]   htrans_inputstage_dma;
wire            hwrite_inputstage_dma;
wire    [2:0]   hsize_inputstage_dma;
wire    [2:0]   hburst_inputstage_dma;
wire    [3:0]   hprot_inputstage_dma;
wire            trans_hold_dma;

AHBlite_BusMatrix_Inputstage DMA_INPUT(
    //  COMMON SIGNALS
    .HCLK       (HCLK),
    .HRESETn    (HRESETn),

    //  MASTOR  SIDE
    .HADDR      (HADDR_DMA),
    .HTRANS     (HTRANS_DMA),
    .HWRITE     (HWRITE_DMA),
    .HSIZE      (HSIZE_DMA),
    .HBURST     (HBURST_DMA),
    .HPROT      (HPROT_DMA),
    .HREADY     (HREADYOUT_DMA),
    .HREADYOUT  (HREADYOUT_DMA),
    .HRESP      (HRESP_DMA),

    //  INTERNAL SIDE
    .ACTIVE_Decoder (active_decoder_dma),
    .HREADYOUT_Decoder  (hreadyout_decoder_dma),
    .HRESP_Decoder  (hresp_decoder_dma),
    .HADDR_Inputstage   (haddr_inputstage_dma),
    .HTRANS_Inputstage  (htrans_inputstage_dma),
    .HWRITE_Inputstage  (hwrite_inputstage_dma),
    .HSIZE_Inputstage   (hsize_inputstage_dma),
    .HBURST_Inputstage  (hburst_inputstage_dma),
    .HPROT_Inputstage   (hprot_inputstage_dma),
    .TRANS_HOLD        (trans_hold_dma)
);

wire    HREADYOUT_ACC;
assign  HREADY_ACC    =   HREADYOUT_ACC;
wire    active_decoder_acc;
wire    hreadyout_decoder_acc;
wire    [1:0]   hresp_decoder_acc;
wire    [31:0]  haddr_inputstage_acc;
wire    [1:0]   htrans_inputstage_acc;
wire            hwrite_inputstage_acc;
wire    [2:0]   hsize_inputstage_acc;
wire    [2:0]   hburst_inputstage_acc;
wire    [3:0]   hprot_inputstage_acc;
wire            trans_hold_acc;

AHBlite_BusMatrix_Inputstage ACC_INPUT(
    //  COMMON SIGNALS
    .HCLK       (HCLK),
    .HRESETn    (HRESETn),

    //  MASTOR  SIDE
    .HADDR      (HADDR_ACC),
    .HTRANS     (HTRANS_ACC),
    .HWRITE     (HWRITE_ACC),
    .HSIZE      (HSIZE_ACC),
    .HBURST     (HBURST_ACC),
    .HPROT      (HPROT_ACC),
    .HREADY     (HREADYOUT_ACC),
    .HREADYOUT  (HREADYOUT_ACC),
    .HRESP      (HRESP_ACC),

    //  INTERNAL SIDE
    .ACTIVE_Decoder (active_decoder_acc),
    .HREADYOUT_Decoder  (hreadyout_decoder_acc),
    .HRESP_Decoder  (hresp_decoder_acc),
    .HADDR_Inputstage   (haddr_inputstage_acc),
    .HTRANS_Inputstage  (htrans_inputstage_acc),
    .HWRITE_Inputstage  (hwrite_inputstage_acc),
    .HSIZE_Inputstage   (hsize_inputstage_acc),
    .HBURST_Inputstage  (hburst_inputstage_acc),
    .HPROT_Inputstage   (hprot_inputstage_acc),
    .TRANS_HOLD        (trans_hold_acc)
);

wire    active_outputstage_itcm;
wire    hreadyout_outputstage_itcm;
wire    hsel_decoder_dcode_itcm; 
wire    active_outputstage_itcm_dcode;

wire    active_outputstage_rom;
wire    hreadyout_outputstage_rom;
wire    hsel_decoder_dcode_rom; 
wire    active_outputstage_rom_dcode;

AHBlite_BusMatrix_Decoder_DCODE DCODE_DECODER(
    //  COMMON SIGNALS
    .HCLK       (HCLK),
    .HRESETn    (HRESETn),

    //  FROM INPUTSTAGE
    .HREADY     (HREADYOUT_DCODE),
    .HADDR      (haddr_inputstage_dcode),
    .HTRANS     (htrans_inputstage_dcode),
    
    //  FROM OUTPUTSTAGE
    .ACTIVE_Outputstage_ITCM (active_outputstage_itcm_dcode),
    .HREADYOUT_Outputstage_ITCM  (hreadyout_outputstage_itcm),
    .HRESP_ITCM  (HRESP_ITCM),
    .HRDATA_ITCM (HRDATA_ITCM),

    //  FROM OUTPUTSTAGE
    .ACTIVE_Outputstage_ROM (active_outputstage_rom_dcode),
    .HREADYOUT_Outputstage_ROM  (hreadyout_outputstage_rom),
    .HRESP_ROM  (HRESP_ROM),
    .HRDATA_ROM (HRDATA_ROM),

    .HSEL_Decoder_DCODE_ITCM (hsel_decoder_dcode_itcm),
    .HSEL_Decoder_DCODE_ROM (hsel_decoder_dcode_rom),

    .ACTIVE_Decoder_DCODE   (active_decoder_dcode),
    .HREADYOUT  (hreadyout_decoder_dcode),
    .HRESP  (hresp_decoder_dcode),
    .HRDATA (HRDATA_DCODE)
);

wire    hsel_decoder_icode_itcm;   
wire    active_outputstage_itcm_icode; 
wire    hsel_decoder_icode_rom;   
wire    active_outputstage_rom_icode; 

AHBlite_BusMatrix_Decoder_ICODE ICODE_DECODER(
    //  COMMON SIGNALS
    .HCLK       (HCLK),
    .HRESETn    (HRESETn),

    //  FROM INPUTSTAGE
    .HREADY     (HREADYOUT_ICODE),
    .HADDR      (haddr_inputstage_icode),
    .HTRANS     (htrans_inputstage_icode),
    
    //  FROM OUTPUTSTAGE
    .ACTIVE_Outputstage_ITCM (active_outputstage_itcm_icode),
    .HREADYOUT_Outputstage_ITCM  (hreadyout_outputstage_itcm),
    .HRESP_ITCM  (HRESP_ITCM),
    .HRDATA_ITCM (HRDATA_ITCM),

    //  FROM OUTPUTSTAGE
    .ACTIVE_Outputstage_ROM (active_outputstage_rom_icode),
    .HREADYOUT_Outputstage_ROM  (hreadyout_outputstage_rom),
    .HRESP_ROM  (HRESP_ROM),
    .HRDATA_ROM (HRDATA_ROM),

    .HSEL_Decoder_ICODE_ITCM (hsel_decoder_icode_itcm),
    .HSEL_Decoder_ICODE_ROM (hsel_decoder_icode_rom),
    
    .ACTIVE_Decoder_ICODE   (active_decoder_icode),
    .HREADYOUT  (hreadyout_decoder_icode),
    .HRESP  (hresp_decoder_icode),
    .HRDATA (HRDATA_ICODE)
);

wire    active_outputstage_dtcm;
wire    hreadyout_outputstage_dtcm;
wire    active_outputstage_camera;
wire    hreadyout_outputstage_camera;
wire    active_outputstage_accc;
wire    hreadyout_outputstage_accc;
wire    active_outputstage_sub;
wire    hreadyout_outputstage_sub;
wire    hsel_decoder_sys_dtcm; 
wire    hsel_decoder_sys_camera; 
wire    hsel_decoder_sys_accc; 
wire    hsel_decoder_sys_sub; 
wire    active_outputstage_dtcm_sys; 
wire    active_outputstage_camera_sys;
wire    active_outputstage_accc_sys;
wire    active_outputstage_sub_sys;

AHBlite_BusMatrix_Decoder_SYS SYS_DECODER(
    //  COMMON SIGNALS
    .HCLK       (HCLK),
    .HRESETn    (HRESETn),

    //  FROM INPUTSTAGE
    .HREADY     (HREADYOUT_SYS),
    .HADDR      (haddr_inputstage_sys),
    .HTRANS     (htrans_inputstage_sys),
    
    //  FROM OUTPUTSTAGE
    .ACTIVE_Outputstage_DTCM (active_outputstage_dtcm_sys),
    .HREADYOUT_Outputstage_DTCM  (hreadyout_outputstage_dtcm),
    .HRESP_DTCM  (HRESP_DTCM),
    .HRDATA_DTCM (HRDATA_DTCM),

    .ACTIVE_Outputstage_SUB (active_outputstage_sub_sys),
    .HREADYOUT_Outputstage_SUB  (hreadyout_outputstage_sub),
    .HRESP_SUB  (HRESP_SUB),
    .HRDATA_SUB (HRDATA_SUB),

    .ACTIVE_Outputstage_CAMERA (active_outputstage_camera_sys),
    .HREADYOUT_Outputstage_CAMERA  (hreadyout_outputstage_camera),
    .HRESP_CAMERA  (HRESP_CAMERA),
    .HRDATA_CAMERA (HRDATA_CAMERA),

    .ACTIVE_Outputstage_ACCC (active_outputstage_accc_sys),
    .HREADYOUT_Outputstage_ACCC  (hreadyout_outputstage_accc),
    .HRESP_ACCC  (HRESP_ACCC),
    .HRDATA_ACCC (HRDATA_ACCC),

    .HSEL_Decoder_SYS_DTCM (hsel_decoder_sys_dtcm),
    .HSEL_Decoder_SYS_CAMERA (hsel_decoder_sys_camera),
    .HSEL_Decoder_SYS_ACCC (hsel_decoder_sys_accc),
    .HSEL_Decoder_SYS_SUB (hsel_decoder_sys_sub),

    .ACTIVE_Decoder_SYS   (active_decoder_sys),
    .HREADYOUT  (hreadyout_decoder_sys),
    .HRESP  (hresp_decoder_sys),
    .HRDATA (HRDATA_SYS)
);

wire    hsel_decoder_dma_itcm; 
wire    hsel_decoder_dma_dtcm; 
wire    hsel_decoder_dma_camera; 
wire    hsel_decoder_dma_accc; 
wire    active_outputstage_itcm_dma;
wire    active_outputstage_dtcm_dma;
wire    active_outputstage_camera_dma;
wire    active_outputstage_accc_dma;

AHBlite_BusMatrix_Decoder_DMA DMA_DECODER(
    //  COMMON SIGNALS
    .HCLK       (HCLK),
    .HRESETn    (HRESETn),

    //  FROM INPUTSTAGE
    .HREADY     (HREADYOUT_DMA),
    .HADDR      (haddr_inputstage_dma),
    .HTRANS     (htrans_inputstage_dma),
    
    //  FROM OUTPUTSTAGE
    .ACTIVE_Outputstage_DTCM (active_outputstage_dtcm_dma),
    .HREADYOUT_Outputstage_DTCM  (hreadyout_outputstage_dtcm),
    .HRESP_DTCM  (HRESP_DTCM),
    .HRDATA_DTCM (HRDATA_DTCM),

    .ACTIVE_Outputstage_CAMERA (active_outputstage_camera_dma),
    .HREADYOUT_Outputstage_CAMERA  (hreadyout_outputstage_camera),
    .HRESP_CAMERA  (HRESP_CAMERA),
    .HRDATA_CAMERA (HRDATA_CAMERA),

    .ACTIVE_Outputstage_ACCC (active_outputstage_accc_dma),
    .HREADYOUT_Outputstage_ACCC  (hreadyout_outputstage_accc),
    .HRESP_ACCC  (HRESP_ACCC),
    .HRDATA_ACCC (HRDATA_ACCC),

    .HSEL_Decoder_DMA_DTCM      (hsel_decoder_dma_dtcm),
    .HSEL_Decoder_DMA_ACCC       (hsel_decoder_dma_accc),
    .HSEL_Decoder_DMA_CAMERA    (hsel_decoder_dma_camera),

    .ACTIVE_Decoder_DMA   (active_decoder_dma),
    .HREADYOUT  (hreadyout_decoder_dma),
    .HRESP  (hresp_decoder_dma),
    .HRDATA (HRDATA_DMA)
);
 
wire    hsel_decoder_acc_dtcm; 
wire    hsel_decoder_acc_camera;
wire    active_outputstage_dtcm_acc;
wire    active_outputstage_camera_acc;

AHBlite_BusMatrix_Decoder_ACC ACC_DECODER(
    //  COMMON SIGNALS
    .HCLK       (HCLK),
    .HRESETn    (HRESETn),

    //  FROM INPUTSTAGE
    .HREADY     (HREADYOUT_DMA),
    .HADDR      (haddr_inputstage_dma),
    .HTRANS     (htrans_inputstage_dma),
    
    //  FROM OUTPUTSTAGE
    .ACTIVE_Outputstage_DTCM (active_outputstage_dtcm_acc),
    .HREADYOUT_Outputstage_DTCM  (hreadyout_outputstage_dtcm),
    .HRESP_DTCM  (HRESP_DTCM),
    .HRDATA_DTCM (HRDATA_DTCM),

    .ACTIVE_Outputstage_CAMERA (active_outputstage_camera_acc),
    .HREADYOUT_Outputstage_CAMERA  (hreadyout_outputstage_camera),
    .HRESP_CAMERA  (HRESP_CAMERA),
    .HRDATA_CAMERA (HRDATA_CAMERA),

    .HSEL_Decoder_ACC_DTCM      (hsel_decoder_acc_dtcm),
    .HSEL_Decoder_ACC_CAMERA    (hsel_decoder_acc_camera),

    .ACTIVE_Decoder_ACC   (active_decoder_acc),
    .HREADYOUT  (hreadyout_decoder_acc),
    .HRESP  (hresp_decoder_acc),
    .HRDATA (HRDATA_ACC)
);

AHBlite_BusMatrix_Outputstage_ITCM ITCM_OUTPUT(
    //  COMMON SIGNALS
    .HCLK       (HCLK),
    .HRESETn    (HRESETn),

    //  ICODE
    .HSEL_ICODE (hsel_decoder_icode_itcm),
    .HADDR_ICODE    (haddr_inputstage_icode),
    .HTRANS_ICODE   (htrans_inputstage_icode),
    .HWRITE_ICODE   (hwrite_inputstage_icode),
    .HSIZE_ICODE    (hsize_inputstage_icode),
    .HBURST_ICODE   (hburst_inputstage_icode),
    .HPROT_ICODE    (hprot_inputstage_icode),
    .HWDATA_ICODE   (HWDATA_ICODE),
    .TRANS_HOLD_ICODE   (trans_hold_icode),

    //  DCODE
    .HSEL_DCODE (hsel_decoder_dcode_itcm),
    .HADDR_DCODE    (haddr_inputstage_dcode),
    .HTRANS_DCODE   (htrans_inputstage_dcode),
    .HWRITE_DCODE   (hwrite_inputstage_dcode),
    .HSIZE_DCODE    (hsize_inputstage_dcode),
    .HBURST_DCODE   (hburst_inputstage_dcode),
    .HPROT_DCODE    (hprot_inputstage_dcode),
    .HWDATA_DCODE   (HWDATA_DCODE),
    .TRANS_HOLD_DCODE   (trans_hold_dcode),

    .HREADYOUT      (HREADYOUT_ITCM),

    .ACTIVE_DCODE   (active_outputstage_itcm_dcode),
    .ACTIVE_ICODE   (active_outputstage_itcm_icode),

    .HSEL       (HSEL_ITCM),
    .HADDR      (HADDR_ITCM),
    .HTRANS     (HTRANS_ITCM),
    .HWRITE     (HWRITE_ITCM),
    .HSIZE      (HSIZE_ITCM),
    .HBURST     (HBURST_ITCM),
    .HPROT      (HPROT_ITCM),
    .HREADY     (hreadyout_outputstage_itcm),
    .HWDATA     (HWDATA_ITCM)
);

assign HREADY_ITCM = hreadyout_outputstage_itcm;

AHBlite_BusMatrix_Outputstage_ROM ROM_OUTPUT(
    //  COMMON SIGNALS
    .HCLK       (HCLK),
    .HRESETn    (HRESETn),

    //  ICODE
    .HSEL_ICODE (hsel_decoder_icode_rom),
    .HADDR_ICODE    (haddr_inputstage_icode),
    .HTRANS_ICODE   (htrans_inputstage_icode),
    .HWRITE_ICODE   (hwrite_inputstage_icode),
    .HSIZE_ICODE    (hsize_inputstage_icode),
    .HBURST_ICODE   (hburst_inputstage_icode),
    .HPROT_ICODE    (hprot_inputstage_icode),
    .HWDATA_ICODE   (HWDATA_ICODE),
    .TRANS_HOLD_ICODE   (trans_hold_icode),

    //  DCODE
    .HSEL_DCODE (hsel_decoder_dcode_rom),
    .HADDR_DCODE    (haddr_inputstage_dcode),
    .HTRANS_DCODE   (htrans_inputstage_dcode),
    .HWRITE_DCODE   (hwrite_inputstage_dcode),
    .HSIZE_DCODE    (hsize_inputstage_dcode),
    .HBURST_DCODE   (hburst_inputstage_dcode),
    .HPROT_DCODE    (hprot_inputstage_dcode),
    .HWDATA_DCODE   (HWDATA_DCODE),
    .TRANS_HOLD_DCODE   (trans_hold_dcode),

    .HREADYOUT      (HREADYOUT_ROM),

    .ACTIVE_DCODE   (active_outputstage_rom_dcode),
    .ACTIVE_ICODE   (active_outputstage_rom_icode),

    .HSEL       (HSEL_ROM),
    .HADDR      (HADDR_ROM),
    .HTRANS     (HTRANS_ROM),
    .HWRITE     (HWRITE_ROM),
    .HSIZE      (HSIZE_ROM),
    .HBURST     (HBURST_ROM),
    .HPROT      (HPROT_ROM),
    .HREADY     (hreadyout_outputstage_rom),
    .HWDATA     (HWDATA_ROM)
);

assign HREADY_ROM = hreadyout_outputstage_rom;

AHBlite_BusMatrix_Outputstage_DTCM DTCM_OUTPUT(
    //  COMMON SIGNALS
    .HCLK       (HCLK),
    .HRESETn    (HRESETn),

    //  SYS
    .HSEL_SYS (hsel_decoder_sys_dtcm),
    .HADDR_SYS    (haddr_inputstage_sys),
    .HTRANS_SYS   (htrans_inputstage_sys),
    .HWRITE_SYS   (hwrite_inputstage_sys),
    .HSIZE_SYS    (hsize_inputstage_sys),
    .HBURST_SYS   (hburst_inputstage_sys),
    .HPROT_SYS    (hprot_inputstage_sys),
    .HWDATA_SYS   (HWDATA_SYS),
    .TRANS_HOLD_SYS   (trans_hold_sys),

    //  DMA
    .HSEL_DMA (hsel_decoder_dma_dtcm),
    .HADDR_DMA    (haddr_inputstage_dma),
    .HTRANS_DMA   (htrans_inputstage_dma),
    .HWRITE_DMA   (hwrite_inputstage_dma),
    .HSIZE_DMA    (hsize_inputstage_dma),
    .HBURST_DMA   (hburst_inputstage_dma),
    .HPROT_DMA    (hprot_inputstage_dma),
    .HWDATA_DMA   (HWDATA_DMA),
    .TRANS_HOLD_DMA   (trans_hold_dma),

    //  ACC
    .HSEL_ACC (hsel_decoder_acc_dtcm),
    .HADDR_ACC    (haddr_inputstage_acc),
    .HTRANS_ACC   (htrans_inputstage_acc),
    .HWRITE_ACC   (hwrite_inputstage_acc),
    .HSIZE_ACC    (hsize_inputstage_acc),
    .HBURST_ACC   (hburst_inputstage_acc),
    .HPROT_ACC    (hprot_inputstage_acc),
    .HWDATA_ACC   (HWDATA_DMA),
    .TRANS_HOLD_ACC   (trans_hold_acc),

    .HREADYOUT      (HREADYOUT_DTCM),

    .ACTIVE_SYS   (active_outputstage_dtcm_sys),
    .ACTIVE_DMA     (active_outputstage_dtcm_dma),
    .ACTIVE_ACC     (active_outputstage_dtcm_acc),

    .HSEL       (HSEL_DTCM),
    .HADDR      (HADDR_DTCM),
    .HTRANS     (HTRANS_DTCM),
    .HWRITE     (HWRITE_DTCM),
    .HSIZE      (HSIZE_DTCM),
    .HBURST     (HBURST_DTCM),
    .HPROT      (HPROT_DTCM),
    .HREADY     (hreadyout_outputstage_dtcm),
    .HWDATA     (HWDATA_DTCM)
);

assign  HREADY_DTCM  =   hreadyout_outputstage_dtcm;

AHBlite_BusMatrix_Outputstage_SUB SUB_OUTPUT(
    //  COMMON SIGNALS
    .HCLK       (HCLK),
    .HRESETn    (HRESETn),

    //  SYS
    .HSEL_SYS     (hsel_decoder_sys_sub),
    .HADDR_SYS    (haddr_inputstage_sys),
    .HTRANS_SYS   (htrans_inputstage_sys),
    .HWRITE_SYS   (hwrite_inputstage_sys),
    .HSIZE_SYS    (hsize_inputstage_sys),
    .HBURST_SYS   (hburst_inputstage_sys),
    .HPROT_SYS    (hprot_inputstage_sys),
    .HWDATA_SYS   (HWDATA_SYS),
    .TRANS_HOLD_SYS   (trans_hold_sys),


    .HREADYOUT      (HREADYOUT_SUB),

    .ACTIVE_SYS   (active_outputstage_sub_sys),

    .HSEL       (HSEL_SUB),
    .HADDR      (HADDR_SUB),
    .HTRANS     (HTRANS_SUB),
    .HWRITE     (HWRITE_SUB),
    .HSIZE      (HSIZE_SUB),
    .HBURST     (HBURST_SUB),
    .HPROT      (HPROT_SUB),
    .HREADY     (hreadyout_outputstage_sub),
    .HWDATA     (HWDATA_SUB)
);

assign HREADY_SUB  =   hreadyout_outputstage_sub;

AHBlite_BusMatrix_Outputstage_CAMERA CAMERA_OUTPUT(
    //  COMMON SIGNALS
    .HCLK       (HCLK),
    .HRESETn    (HRESETn),

    //  SYS
    .HSEL_SYS     (hsel_decoder_sys_camera),
    .HADDR_SYS    (haddr_inputstage_sys),
    .HTRANS_SYS   (htrans_inputstage_sys),
    .HWRITE_SYS   (hwrite_inputstage_sys),
    .HSIZE_SYS    (hsize_inputstage_sys),
    .HBURST_SYS   (hburst_inputstage_sys),
    .HPROT_SYS    (hprot_inputstage_sys),
    .HWDATA_SYS   (HWDATA_SYS),
    .TRANS_HOLD_SYS   (trans_hold_sys),

    //  DMA
    .HSEL_DMA     (hsel_decoder_dma_camera),
    .HADDR_DMA    (haddr_inputstage_dma),
    .HTRANS_DMA   (htrans_inputstage_dma),
    .HWRITE_DMA   (hwrite_inputstage_dma),
    .HSIZE_DMA    (hsize_inputstage_dma),
    .HBURST_DMA   (hburst_inputstage_dma),
    .HPROT_DMA    (hprot_inputstage_dma),
    .HWDATA_DMA   (HWDATA_DMA),
    .TRANS_HOLD_DMA   (trans_hold_dma),

    //  ACC
    .HSEL_ACC     (hsel_decoder_acc_camera),
    .HADDR_ACC    (haddr_inputstage_acc),
    .HTRANS_ACC   (htrans_inputstage_acc),
    .HWRITE_ACC   (hwrite_inputstage_acc),
    .HSIZE_ACC    (hsize_inputstage_acc),
    .HBURST_ACC   (hburst_inputstage_acc),
    .HPROT_ACC   (hprot_inputstage_acc),
    .HWDATA_ACC   (HWDATA_ACC),
    .TRANS_HOLD_ACC   (trans_hold_acc),

    .HREADYOUT      (HREADYOUT_CAMERA),

    .ACTIVE_SYS   (active_outputstage_camera_sys),
    .ACTIVE_DMA     (active_outputstage_camera_dma),
    .ACTIVE_ACC     (active_outputstage_camera_acc),

    .HSEL       (HSEL_CAMERA),
    .HADDR      (HADDR_CAMERA),
    .HTRANS     (HTRANS_CAMERA),
    .HWRITE     (HWRITE_CAMERA),
    .HSIZE      (HSIZE_CAMERA),
    .HBURST     (HBURST_CAMERA),
    .HPROT      (HPROT_CAMERA),
    .HREADY     (hreadyout_outputstage_camera),
    .HWDATA     (HWDATA_CAMERA)
);

assign  HREADY_CAMERA  =   hreadyout_outputstage_camera;

AHBlite_BusMatrix_Outputstage_ACCC ACCC_OUTPUT(
    //  COMMON SIGNALS
    .HCLK       (HCLK),
    .HRESETn    (HRESETn),

    //  SYS
    .HSEL_SYS     (hsel_decoder_sys_accc),
    .HADDR_SYS    (haddr_inputstage_sys),
    .HTRANS_SYS   (htrans_inputstage_sys),
    .HWRITE_SYS   (hwrite_inputstage_sys),
    .HSIZE_SYS    (hsize_inputstage_sys),
    .HBURST_SYS   (hburst_inputstage_sys),
    .HPROT_SYS    (hprot_inputstage_sys),
    .HWDATA_SYS   (HWDATA_SYS),
    .TRANS_HOLD_SYS   (trans_hold_sys),

    //  DMA
    .HSEL_DMA     (hsel_decoder_dma_accc),
    .HADDR_DMA    (haddr_inputstage_dma),
    .HTRANS_DMA   (htrans_inputstage_dma),
    .HWRITE_DMA   (hwrite_inputstage_dma),
    .HSIZE_DMA    (hsize_inputstage_dma),
    .HBURST_DMA   (hburst_inputstage_dma),
    .HPROT_DMA    (hprot_inputstage_dma),
    .HWDATA_DMA   (HWDATA_DMA),
    .TRANS_HOLD_DMA   (trans_hold_dma),

    .HREADYOUT      (HREADYOUT_ACCC),

    .ACTIVE_SYS   (active_outputstage_accc_sys),
    .ACTIVE_DMA   (active_outputstage_accc_dma),

    .HSEL       (HSEL_ACCC),
    .HADDR      (HADDR_ACCC),
    .HTRANS     (HTRANS_ACCC),
    .HWRITE     (HWRITE_ACCC),
    .HSIZE      (HSIZE_ACCC),
    .HBURST     (HBURST_ACCC),
    .HPROT      (HPROT_ACCC),
    .HREADY     (hreadyout_outputstage_accc),
    .HWDATA     (HWDATA_ACCC)
);

assign  HREADY_ACCC  =   hreadyout_outputstage_accc;

endmodule