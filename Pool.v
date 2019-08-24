module Pool #(
    parameter ByteWidth = 22) (
    input   wire    [ByteWidth * 8 - 1 : 0] line0,
    input   wire    [ByteWidth * 8 - 1 : 0] line1,
    output  wire    [ByteWidth * 4 - 1 : 0]  outline 
);

generate
genvar i;
    for(i = 0;i < ByteWidth  / 2;i = i + 1) begin : Max
        MaxOf4 Max(
            .data00     (line0[(i * 16 + 7) : (i * 16)]),
            .data01     (line0[(i * 16 + 15) : (i * 16 + 8)]),
            .data10     (line1[(i * 16 + 7) : (i * 16)]),
            .data11     (line1[(i * 16 + 15) : (i * 16 + 8)]),
            .result     (outline[(i * 8 + 7) : (i * 8)])
        );
    end
endgenerate

endmodule