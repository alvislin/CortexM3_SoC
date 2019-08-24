module CAMERA(
    input   wire            HCLK,
    input   wire            HRESETn,

    input   wire            REG_VALID,
    input   wire    [31:0]  REG_CONTRL,
    output  wire            REG_READY,

    input   wire            DATA_VALID,
    output  wire            DATA_READY,
    output  wire    [31:0]  RDATA,
    input   wire    [14:0]  ADDR,

    output  wire            SCL,
    output  wire            SDA,
    input   wire    [7:0]   D,
    input   wire            VSYNC,
    input   wire            HREF,
    input   wire            PCLK,
    output  wire            state_led            
);

sccb SCCB(
    .reg_ctrl(REG_CONTRL),
    .reset_n(HRESETn),
    .clock(HCLK),
    .valid(REG_VALID),
    .sccb_data(SDA),
    .sccb_clk(SCL),
    .ready(REG_READY),
    .respond(/* not used */)
);

CAMERA_Capture CC(
    .HCLK(HCLK),
    .PCLK(PCLK),
    .HRESETn(HRESETn),
    .DATA_VALID(DATA_VALID),
    .DATA_READY(DATA_READY),
    .DualRAM_RADDR(ADDR),
    .DualRAM_RDATA(RDATA),
    .Camera_idata(D),
    .VSYNC(VSYNC),
    .HREF(HREF),
    .state_led(state_led)
);

endmodule