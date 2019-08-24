module LocalRAM #(
    parameter ByteWidth = 12,
    parameter AddrWidth = 6
)   (
    input   wire                            clk,
    input   wire    [7 : 0]                 din,
    input   wire    [AddrWidth - 1 : 0]     rdaddr,
    input   wire    [2 : 0]                 we,
    input   wire    [AddrWidth - 1 : 0]     wraddr,
    output  reg     [ByteWidth * 8 - 1 : 0] dout
);


reg [ByteWidth * 8 - 1 : 0] mem [2 ** AddrWidth - 1 : 0];

always@(posedge clk) begin
    if(we[0]) mem[wraddr][7:0] <= din;
end

always@(posedge clk) begin
    if(we[1]) mem[wraddr][15:8] <= din;
end

always@(posedge clk) begin
    if(we[2]) mem[wraddr][23:16] <= din;
end


always@(posedge clk) begin
    dout  <=  mem[rdaddr];
end


endmodule