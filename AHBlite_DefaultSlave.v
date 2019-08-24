module AHBlite_DefaultSlave (
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
    output wire    [1:0] HRESP
);

assign HRESP = 2'b0;
assign HREADYOUT = 1'b1;
assign HRDATA = 32'b0;

endmodule
