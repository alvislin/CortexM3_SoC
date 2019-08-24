/**********************************************/
/*   OLED_SCLK     0X40020000                 */
/*   OLED_SDIN     0X40020004                 */
/**********************************************/

module AHBlite_TIMER (
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

    output  wire                        TimerRst_o,
    output  wire                        TimerEn_o
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

reg addr_reg;
always@(posedge HCLK or negedge HRESETn) begin
  if(~HRESETn) addr_reg <= 1'b0;
  else if(trans_en) addr_reg <= HADDR[2];
end

reg rst;
reg en;

always@(posedge HCLK or negedge HRESETn) begin
    if(~HRESETn) begin
        rst <= 1'b0;
        en <= 1'b0;
    end else if(wr_en_reg) begin
        if(~addr_reg) rst <= HWDATA[0];
        else en <= HWDATA[0];
    end else
        rst <=  1'b0;
end

assign TimerRst_o = rst;
assign TimerEn_o = en;

assign HRDATA = addr_reg ? {31'b0,en} : {31'b0,rst};

endmodule