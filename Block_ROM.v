module Block_ROM #(
    parameter ADDR_WIDTH = 13)(
    input clka,
    input [ADDR_WIDTH-1:0] addra,
    output reg [31:0] douta
);

(* ramstyle = "AUTO" *) reg [31:0] mem [(2**ADDR_WIDTH-1):0];

initial begin
    $readmemh("C:/Users/tianj/Desktop/CortexM3_SoC/KEIL/code.hex",mem);
end


always@(posedge clka) begin
    douta <= mem[addra];
end


endmodule