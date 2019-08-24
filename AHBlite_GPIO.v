module AHBlite_GPIO #(
    parameter   GPIO_WIDTH = 24
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
    output  wire    [GPIO_WIDTH-1:0]    DIR,
    output  wire    [GPIO_WIDTH-1:0]    WDATA,
    input   wire    [GPIO_WIDTH-1:0]    RDATA  
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
  else if(write_en) wr_en_reg <= 1'b1;
  else wr_en_reg <= 1'b0;
end

reg [1:0] addr_reg;
always@(posedge HCLK or negedge HRESETn) begin
  if(~HRESETn) addr_reg <= 2'b0;
  else if(trans_en) addr_reg <= HADDR[3:2];
end

reg [GPIO_WIDTH-1:0] wdata_reg;
reg [GPIO_WIDTH-1:0] dir_reg;
always@(posedge HCLK or negedge HRESETn) begin
    if(~HRESETn) begin
        wdata_reg <= 0;
        dir_reg <= 0;
    end else if(wr_en_reg)begin
        if(~addr_reg[1]&addr_reg[0]) dir_reg <= HWDATA[GPIO_WIDTH-1:0];
        if(~addr_reg[0]&addr_reg[1]) wdata_reg <= HWDATA[GPIO_WIDTH-1:0];
    end
end

reg [GPIO_WIDTH-1:0] rdata_reg;
always@(posedge HCLK or negedge HRESETn) begin
    if(~HRESETn) begin 
        rdata_reg <= 0;
    end else begin
        rdata_reg <= RDATA;
    end
end

assign DIR = dir_reg;
assign HRDATA = (addr_reg == 2'b00) ? rdata_reg : 
               ((addr_reg == 2'b01) ? dir_reg :
               ((addr_reg == 2'b10) ? wdata_reg : 32'b0));

assign WDATA = wdata_reg;

endmodule