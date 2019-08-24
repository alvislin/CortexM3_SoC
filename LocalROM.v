module LocalROM #( 
    parameter ByteWidth = 12,
    parameter AddrWidth = 6
)   (
    input   wire                            clk,
    input   wire    [AddrWidth - 1 : 0]     addr,
    output  reg     [ByteWidth * 8 - 1 : 0] dout
);

reg [ByteWidth * 8 - 1 : 0] mem [2 ** AddrWidth - 1 : 0];

initial begin
    $readmemh("C:/Users/tianj/Desktop/CortexM3_SoC/RTL/FPweight.hex",mem);
end


always@(posedge clk) begin
    dout    <=  mem[addr];
end


endmodule