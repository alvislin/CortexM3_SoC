module AHBlite_BusMatrix_Arbiter_DTCM(
    input   HCLK,
    input   HRESETn,
    input   REQ_SYS,
    input   REQ_DMA,
    input   REQ_ACC,
    input   HREADY_Outputstage_DTCM,
    input   HSEL_Outputstage_DTCM,
    input   [1:0]   HTRANS_Outputstage_DTCM,
    input   [2:0]   HBURST_Outputstage_DTCM,
    output  wire [1:0]  PORT_SEL_ARBITER_DTCM,
    output  wire        PORT_NOSEL_ARBITER_DTCM
);

reg noport;
wire    noport_next;

assign noport_next  =   (~REQ_SYS)   &   (~REQ_DMA)    &   (~REQ_ACC)   &   (~HSEL_Outputstage_DTCM);        

reg [1:0] selport;
wire    [1:0] selport_next;

assign  selport_next    =   REQ_SYS   ?   2'b01   :
                            (REQ_DMA  ?   2'b10   :
                            (REQ_ACC  ?   2'b11   : 2'b00));
                        
always@(posedge HCLK or negedge HRESETn) begin
    if(~HRESETn) begin
        noport  <=  1'b1;
        selport <=  2'b00;
    end else if(HREADY_Outputstage_DTCM) begin
        noport  <=  noport_next;
        selport <=  selport_next;
    end
end

assign  PORT_NOSEL_ARBITER_DTCM  =   noport;
assign  PORT_SEL_ARBITER_DTCM    =   selport;

endmodule