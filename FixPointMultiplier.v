module FixPointMultiplier (
    input   wire    [7:0]   data,
    input   wire    [7:0]   weight,
    output  wire    [14:0]   out
);

assign  out[13:0] = data[6:0] * weight[6:0];

assign  out[14] = data[7] ^ weight[7];

endmodule