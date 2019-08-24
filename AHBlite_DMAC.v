module AHBlite_DMAC(
    //AHB SLAVE
    input  wire          HCLK,    
    input  wire          HRESETn, 
    input  wire          HSEL,    
    input  wire   [31:0] HADDR,   
    input  wire    [1:0] HTRANS,  
    input  wire    [2:0] HSIZE,   
    input  wire    [3:0] HPROT,   
    input  wire          HWRITE,  
    input  wire   [31:0] HWDATA,    
    input  wire          HREADY,
    output wire          HREADYOUT, 
    output wire   [31:0] HRDATA,  
    output wire    [1:0] HRESP,
    //DMA CONTROL
    input  wire          SLEEPing,
    output wire          DMAstart,
    output reg    [31:0] DMAsrc,
    output reg    [31:0] DMAdst,
    output reg     [1:0] DMAsize,
    output reg    [31:0] DMAlen
);

assign HRESP = 2'b00;
assign HREADYOUT = 1'b1;


wire write_en;
assign write_en = HSEL & HTRANS[1] & HWRITE & HREADY;

reg wr_en_reg;
always@(posedge HCLK or negedge HRESETn) begin
  if(~HRESETn) wr_en_reg <= 1'b0;
  else if(write_en) wr_en_reg <= 1'b1;
  else wr_en_reg <= 1'b0;
end

reg [1:0] addr_reg;
always@(posedge HCLK or negedge HRESETn) begin
  if(~HRESETn) addr_reg <= 2'b0;
  else if(write_en) addr_reg <= HADDR[3:2];
end


always@(posedge HCLK) begin
    if(~HRESETn) begin
        DMAsrc <= 32'b0;
        DMAdst <= 32'b0;
        DMAsize <= 2'b0;
        DMAlen <= 32'b0;
    end else if(wr_en_reg) begin
        if(addr_reg == 2'b0)
            DMAsrc <= HWDATA;
        else if(addr_reg == 2'b01)
            DMAdst <= HWDATA;
        else if(addr_reg == 2'b10)
            DMAsize <= HWDATA[1:0];
        else begin
            DMAlen <= HWDATA;
        end
    end
end

reg dma;
wire dma_nxt;

assign dma_nxt = (~dma) ? (wr_en_reg & (addr_reg == 2'b11)) : (~SLEEPing);  
always@(posedge HCLK or negedge HRESETn) begin
    if(~HRESETn) dma <= 1'b0;
    else dma <= dma_nxt;
end

assign DMAstart = dma & SLEEPing;

assign HRDATA = (addr_reg == 2'b00) ? DMAsrc :
                ((addr_reg == 2'b01) ? DMAdst :
                ((addr_reg == 2'b10) ? DMAsize :
                ((addr_reg == 2'b11) ? DMAlen : 32'b0)));

endmodule