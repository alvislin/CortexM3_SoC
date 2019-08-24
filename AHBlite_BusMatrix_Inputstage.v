module AHBlite_BusMatrix_Inputstage(
    input           HCLK,
    input           HRESETn,
    input   [31:0]  HADDR,
    input   [1:0]   HTRANS,
    input           HWRITE,
    input   [2:0]   HSIZE,
    input   [2:0]   HBURST,
    input   [3:0]   HPROT,
    input           HREADY,
    input           ACTIVE_Decoder,
    input           HREADYOUT_Decoder,
    input   [1:0]   HRESP_Decoder,

    output  wire            HREADYOUT,
    output  wire    [1:0]   HRESP,
    output  wire    [31:0]  HADDR_Inputstage,
    output  wire    [1:0]   HTRANS_Inputstage,
    output  wire            HWRITE_Inputstage,
    output  wire    [2:0]   HSIZE_Inputstage,
    output  wire    [2:0]   HBURST_Inputstage,
    output  wire    [3:0]   HPROT_Inputstage,
    output  wire            TRANS_HOLD
);

//  TRANS START CONTRL
wire    trans_req;
wire    trans_valid;

assign trans_req = HTRANS[1];
assign trans_valid = trans_req & HREADY;

//  SIGNAL REG
reg [1:0]   trans_reg;
reg [31:0]  addr_reg;
reg         write_reg;
reg [2:0]   size_reg;
reg [2:0]   burst_reg;
reg [3:0]   prot_reg;

always@(posedge HCLK or negedge HRESETn) begin
    if(~HRESETn) begin
        trans_reg   <= 2'b0;
        addr_reg    <= 32'b0;
        write_reg   <= 1'b0;
        size_reg    <= 3'b0;
        burst_reg   <= 3'b0;
        prot_reg    <= 4'b0;
    end else if(trans_valid) begin
        trans_reg   <= HTRANS;
        addr_reg    <= HADDR;
        write_reg   <= HWRITE;
        size_reg    <= HSIZE;
        burst_reg   <= HBURST;
        prot_reg    <= HPROT;
    end
end

//  TRANS STATE
reg trans_state;

always@(posedge HCLK or negedge HRESETn) begin
    if(~HRESETn)
        trans_state <= 1'b0;
    else if(HREADY) 
        trans_state <= trans_req;
end

// TRANS PENDING
reg trans_pend;
wire    trans_wait;
wire    trans_done;

assign trans_wait   = trans_valid & (~ACTIVE_Decoder);
assign trans_done   = ACTIVE_Decoder & HREADYOUT_Decoder;

always@(posedge HCLK or negedge HRESETn) begin
    if(~HRESETn)
        trans_pend  <= 1'b0;
    else if(trans_wait)
        trans_pend  <= 1'b1;
    else if(trans_done)
        trans_pend  <= 1'b0;
end

assign TRANS_HOLD = trans_valid | trans_pend;

assign HTRANS_Inputstage    = trans_pend ? trans_reg : HTRANS;
assign HADDR_Inputstage     = trans_pend ? addr_reg  : HADDR;
assign HWRITE_Inputstage    = trans_pend ? write_reg : HWRITE;
assign HSIZE_Inputstage     = trans_pend ? size_reg  : HSIZE;
assign HBURST_Inputstage    = trans_pend ? burst_reg : HBURST;
assign HPROT_Inputstage     = trans_pend ? prot_reg  : HPROT;

assign HREADYOUT    = (~trans_state)    ? 1'b1  :
                      ((trans_pend)     ? 1'b0  : HREADYOUT_Decoder);
assign HRESP        = (~trans_state)    ? 2'b00 :
                      ((trans_pend)     ? 2'b00 : HRESP_Decoder);

endmodule


