module AHBlite_BusMatrix_Arbiter_TIMER(
    input   HCLK,
    input   HRESETn,
    input   REQ_SUB,
    input   HREADY_Outputstage_TIMER,
    input   HSEL_Outputstage_TIMER,
    input   [1:0]   HTRANS_Outputstage_TIMER,
    input   [2:0]   HBURST_Outputstage_TIMER,
    output  wire [1:0]  PORT_SEL_ARBITER_TIMER,
    output  wire        PORT_NOSEL_ARBITER_TIMER
);

reg noport;
wire    noport_next;

assign noport_next  =   (~REQ_SUB)    &   (~HSEL_Outputstage_TIMER);        

reg [1:0] selport;
wire    [1:0] selport_next;

assign  selport_next    =   REQ_SUB   ?   2'b11   : 2'b00;
                        
always@(posedge HCLK or negedge HRESETn) begin
    if(~HRESETn) begin
        noport  <=  1'b1;
        selport <=  2'b00;
    end else if(HREADY_Outputstage_TIMER) begin
        noport  <=  noport_next;
        selport <=  selport_next;
    end
end

assign  PORT_NOSEL_ARBITER_TIMER  =   noport;
assign  PORT_SEL_ARBITER_TIMER    =   selport;

endmodule