module FixPointAdder #(
    parameter   Width = 15
)   (
    input   wire    [Width-1:0]   dina,
    input   wire    [Width-1:0]   dinb,
    output  wire    [Width:0]     dout
);

wire biggera;
assign biggera = dina[Width-2:0] > dinb[Width-2:0];

wire diff;
assign diff = dina[Width-1] ^ dinb[Width-1];

wire [Width-1:0] result;
assign result = (~diff) ? (dina[Width-2:0] + dinb[Width-2:0]) : (
                biggera ? (dina[Width-2:0] - dinb[Width-2:0]) : (dinb[Width-2:0] - dina[Width-2:0])); 

wire zero;
assign zero = diff & (dina[Width-2:0] == dinb[Width-2:0]);

assign dout[Width] = zero ? 1'b0 : (
                 biggera ? dina[Width-1] : dinb[Width-1]);

assign dout[Width-1:0] = zero ? 0 : result;

endmodule