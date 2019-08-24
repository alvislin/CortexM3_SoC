module Two2OneMux #(
    parameter               Width = 24
)   (
    input   wire    [Width-1:0] din0,
    input   wire    [Width-1:0] din1,
    input   wire                sel,
    output  wire    [Width-1:0] dout
);

assign  dout    =   sel ?   din1    :   din0;

endmodule