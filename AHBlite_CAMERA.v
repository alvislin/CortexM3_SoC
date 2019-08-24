/**********************************************/
/*   RAM 0X40010000--0X4001FFEF               */
/*   RST           0X4001FFD0                 */
/*   PWDN          0X4001FFD4                 */
/*   SCL           0X4001FFD8                 */
/*   SDAO          0X4001FFDC                 */
/*   SDAI          0X4001FFE0                 */
/*   SDAOEN        0X4001FFE4                 */
/*   RAM STATE     0X4001FFE8                 */
/**********************************************/

module AHBlite_CAMERA #(
    parameter                           SimPresent = 1
)   (
    input   wire                        HCLK,    
    input   wire                        HRESETn, 
    input   wire                        HSEL,    
    input   wire    [31:0]              HADDR,   
    input   wire    [1:0]               HTRANS,  
    input   wire    [2:0]               HSIZE,   
    input   wire    [3:0]               HPROT,   
    input   wire                        HWRITE,  
    input   wire    [31:0]              HWDATA,   
    input   wire                        HREADY, 
    output  wire                        HREADYOUT, 
    output  wire    [31:0]              HRDATA,  
    output  wire    [1:0]               HRESP,

    output  wire                        CAMERA_SCL,
    inout   wire                        CAMERA_SDA,

    output  wire                        DATA_VALID,
    input   wire                        DATA_READY,
    input   wire    [31:0]              RDATA,
    output  wire    [12:0]              ADDR,

    output  wire                        PWDN,
    output  wire                        RST
);


assign HRESP = 2'b0;
assign HREADYOUT = 1'b1;

wire trans_en;
assign trans_en = HSEL & HTRANS[1] & HREADY;

wire write_en;
assign write_en = trans_en & HWRITE;


reg wr_en_reg;
always@(posedge HCLK or negedge HRESETn) begin
  if(~HRESETn) wr_en_reg <= 1'b0;
  else wr_en_reg <= write_en;
end

reg [13:0] addr_reg;
always@(posedge HCLK or negedge HRESETn) begin
  if(~HRESETn) addr_reg <= 14'b0;
  else if(trans_en) addr_reg <= HADDR[15:2];
end

wire sel;
assign sel = addr_reg[13:4] == 10'h3ff;

reg ram_state;
wire ram_state_nxt;

assign ram_state_en = wr_en_reg & sel & (addr_reg[3:0] == 4'b1010) & HWDATA[0];
assign ram_state_nxt = ram_state ? (~DATA_READY) : ram_state_en;

always@(posedge HCLK or negedge HRESETn) begin
  if(~HRESETn) ram_state <= 1'b0;
  else ram_state <= ram_state_nxt;
end

reg scl,sdao,sdaoen,pwdn,rst;
wire sdai;

always@(posedge HCLK or negedge HRESETn) begin
  if(~HRESETn) begin
    scl     <= 1'b1;
    sdao    <= 1'b1;
    sdaoen  <= 1'b1;
    pwdn    <= 1'b1;
    rst     <= 1'b0;
  end else if(sel & wr_en_reg) begin
    if(addr_reg[3:0] == 4'b0100) rst    <= HWDATA[0];
    if(addr_reg[3:0] == 4'b0101) pwdn   <= HWDATA[0];
    if(addr_reg[3:0] == 4'b0110) scl    <= HWDATA[0];
    if(addr_reg[3:0] == 4'b0111) sdao   <= HWDATA[0];
    if(addr_reg[3:0] == 4'b1001) sdaoen <= HWDATA[0];
  end
end

assign HRDATA = (~sel) ?    RDATA   :
                ((addr_reg[3:0] == 4'b0100)   ?   {31'b0,rst}         :
                ((addr_reg[3:0] == 4'b0101)   ?   {31'b0,pwdn}        :
                ((addr_reg[3:0] == 4'b0110)   ?   {31'b0,scl}         :
                ((addr_reg[3:0] == 4'b0111)   ?   {31'b0,sdao}        :
                ((addr_reg[3:0] == 4'b1000)   ?   {31'b0,sdai}        :
                ((addr_reg[3:0] == 4'b1001)   ?   {31'b0,sdaoen}      :
                ((addr_reg[3:0] == 4'b1010)   ?   {31'b0,ram_state}   :  32'b0)))))));

assign ADDR = HADDR[14:2];
assign DATA_VALID = ram_state;
assign PWDN = pwdn;
assign RST = rst;
assign CAMERA_SCL = scl;

generate
  if(SimPresent) begin : Sim

    assign CAMERA_SDA = sdaoen ? sdao : 1'bz;
    assign sdai = sdaoen ? 1'b0 : CAMERA_SDA;

  end else begin : Syn

    IOBUF SCCBBUF(
            .datain(sdao),
            .oe(sdaoen),
            .dataout(sdai),
            .dataio(CAMERA_SDA)
    );

  end
endgenerate

endmodule