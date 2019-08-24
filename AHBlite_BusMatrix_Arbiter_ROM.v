module AHBlite_BusMatrix_Arbiter_ROM(
    input   HCLK,
    input   HRESETn,
    input   REQ_ICODE,
    input   REQ_DCODE,
    input   HREADY_Outputstage_ROM,
    input   HSEL_Outputstage_ROM,
    input   [1:0]   HTRANS_Outputstage_ROM,
    input   [2:0]   HBURST_Outputstage_ROM,
    output  wire [1:0]  PORT_SEL_ARBITER_ROM,
    output  wire        PORT_NOSEL_ARBITER_ROM
);

reg noport;
wire    noport_next;

assign noport_next  =   (~REQ_ICODE)  &   (~REQ_DCODE)    &   (~HSEL_Outputstage_ROM);        

reg [1:0] selport;
wire    [1:0] selport_next;

assign  selport_next    =   REQ_DCODE   ?   2'b01   :
                            (REQ_ICODE  ?   2'b10   :   2'b00);
                        
always@(posedge HCLK or negedge HRESETn) begin
    if(~HRESETn) begin
        noport  <=  1'b1;
        selport <=  2'b00;
    end else if(HREADY_Outputstage_ROM) begin
        noport  <=  noport_next;
        selport <=  selport_next;
    end
end

assign  PORT_NOSEL_ARBITER_ROM  =   noport;
assign  PORT_SEL_ARBITER_ROM    =   selport;

endmodule