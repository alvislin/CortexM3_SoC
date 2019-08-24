module InputBuffer #(
    parameter               Width = 24
)   (
    input   wire                clk,
    input   wire                rstn,
    input   wire    [Width-1:0] din,
    input   wire                en,
    input   wire                zero,
    output  wire    [Width-1:0] dout0,   
    output  wire    [Width-1:0] dout1 
);

reg [Width-1:0] d0_reg;
reg [Width-1:0] d1_reg;

always@(posedge clk or negedge rstn) begin
    if(~rstn)
        d0_reg <= 0;
    else if(en)
        d0_reg <= zero  ?   0   :   din;
end

always@(posedge clk or negedge rstn) begin
    if(~rstn)
        d1_reg <= 0;
    else if(en)
        d1_reg <= d0_reg;
end


assign  dout0    =   d1_reg;
assign  dout1    =   d0_reg;

endmodule