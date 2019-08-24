module AHBlite_BusMatrix_Arbiter_CAMERA(
    input   HCLK,
    input   HRESETn,
    input   REQ_SYS,
    input   REQ_DMA,
    input   REQ_ACC,
    input   HREADY_Outputstage_CAMERA,
    input   HSEL_Outputstage_CAMERA,
    input   [1:0]   HTRANS_Outputstage_CAMERA,
    input   [2:0]   HBURST_Outputstage_CAMERA,
    output  wire [1:0]  PORT_SEL_ARBITER_CAMERA,
    output  wire        PORT_NOSEL_ARBITER_CAMERA
);

reg noport;
wire    noport_next;

assign noport_next  =   (~REQ_SYS)   &   (~REQ_DMA) &   (~REQ_ACC)    &   (~HSEL_Outputstage_CAMERA);        

reg [1:0] selport;
wire    [1:0] selport_next;

assign  selport_next    =   REQ_SYS   ?   2'b01   :
                           (REQ_DMA   ?   2'b10   :
                          ((REQ_ACC   ?   2'b11   : 2'b00)));
                        
always@(posedge HCLK or negedge HRESETn) begin
    if(~HRESETn) begin
        noport  <=  1'b1;
        selport <=  2'b00;
    end else if(HREADY_Outputstage_CAMERA) begin
        noport  <=  noport_next;
        selport <=  selport_next;
    end
end

assign  PORT_NOSEL_ARBITER_CAMERA  =   noport;
assign  PORT_SEL_ARBITER_CAMERA    =   selport;

endmodule