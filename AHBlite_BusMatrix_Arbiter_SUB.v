module AHBlite_BusMatrix_Arbiter_SUB(
    input   HCLK,
    input   HRESETn,
    input   REQ_SYS,
    input   HREADY_Outputstage_SUB,
    input   HSEL_Outputstage_SUB,
    input   [1:0]   HTRANS_Outputstage_SUB,
    input   [2:0]   HBURST_Outputstage_SUB,
    output  wire [1:0]  PORT_SEL_ARBITER_SUB,
    output  wire        PORT_NOSEL_ARBITER_SUB
);

reg noport;
wire    noport_next;

assign noport_next  =   (~REQ_SYS)  &   (~HSEL_Outputstage_SUB);        

reg [1:0] selport;
wire    [1:0] selport_next;

assign  selport_next    =   REQ_SYS   ?   2'b11   : 2'b00;
                        
always@(posedge HCLK or negedge HRESETn) begin
    if(~HRESETn) begin
        noport  <=  1'b1;
        selport <=  2'b00;
    end else if(HREADY_Outputstage_SUB) begin
        noport  <=  noport_next;
        selport <=  selport_next;
    end
end

assign  PORT_NOSEL_ARBITER_SUB  =   noport;
assign  PORT_SEL_ARBITER_SUB   =   selport;

endmodule