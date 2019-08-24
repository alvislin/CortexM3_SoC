module AHBlite_Block_ROM #(
    parameter            ADDR_WIDTH = 13)(
    input  wire          HCLK,    
    input  wire          HRESETn, 
    input  wire          HSEL,    
    input  wire   [31:0] HADDR,   
    input  wire    [1:0] HTRANS,  
    input  wire    [2:0] HSIZE,   
    input  wire    [3:0] HPROT,   
    input  wire          HWRITE,  
    input  wire   [31:0] HWDATA,   
    input wire           HREADY, 
    output wire          HREADYOUT, 
    output wire   [31:0] HRDATA,  
    output wire    [1:0] HRESP,
    output wire   [ADDR_WIDTH-1:0]  BRAM_ADDR,
    input  wire   [31:0] BRAM_RDATA
);

assign HRESP = 2'b0;
assign HRDATA = BRAM_RDATA;
assign BRAM_ADDR = HADDR[(ADDR_WIDTH+1):2];
assign HREADYOUT = 1'b1;

endmodule
