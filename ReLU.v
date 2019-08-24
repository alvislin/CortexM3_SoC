module ReLU #(
    parameter               Width = 20
)   (
    input   wire    [Width-1:0]  din,
    output  wire    [Width-1:0]  dout
);

assign  dout    =   din[Width-1]    ?   0   :   din;

endmodule