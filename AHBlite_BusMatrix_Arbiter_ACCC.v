module AHBlite_BusMatrix_Arbiter_ACCC(
    input   HCLK,
    input   HRESETn,
    input   REQ_SYS,
    input   REQ_DMA,
    input   HREADY_Outputstage_ACCC,
    input   HSEL_Outputstage_ACCC,
    input   [1:0]   HTRANS_Outputstage_ACCC,
    input   [2:0]   HBURST_Outputstage_ACCC,
    output  wire [1:0]  PORT_SEL_ARBITER_ACCC,
    output  wire        PORT_NOSEL_ARBITER_ACCC
);

reg     noport;
wire    noport_next;

assign  noport_next     =   (~REQ_DMA)  &   (~REQ_SYS)    &   (~HSEL_Outputstage_ACCC);        

reg     [1:0] selport;
wire    [1:0] selport_next;

assign  selport_next    =   REQ_SYS     ?   2'b01   : (
                            REQ_DMA     ?   2'b10   : 2'b00);
                        
always@(posedge HCLK or negedge HRESETn) begin
    if(~HRESETn) begin
        noport  <=  1'b1;
        selport <=  2'b00;
    end else if(HREADY_Outputstage_ACCC) begin
        noport  <=  noport_next;
        selport <=  selport_next;
    end
end

assign  PORT_NOSEL_ARBITER_ACCC  =   noport;
assign  PORT_SEL_ARBITER_ACCC    =   selport;

endmodule