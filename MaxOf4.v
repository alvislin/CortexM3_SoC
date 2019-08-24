module MaxOf4(
    input   wire    [7:0]   data00,
    input   wire    [7:0]   data01,
    input   wire    [7:0]   data10,
    input   wire    [7:0]   data11,  
    output  wire    [7:0]   result
);

wire    BiggerInCol0;
wire    BiggerInCol1;

assign  BiggerInCol0 = data00[6:0] > data01[6:0];
assign  BiggerInCol1 = data10[6:0] > data11[6:0];

wire    [7:0]   MaxInCol0;
wire    [7:0]   MaxInCol1;

assign  MaxInCol0 = BiggerInCol0 ? data00 : data01;
assign  MaxInCol1 = BiggerInCol1 ? data10 : data11;

wire    BiggerInRow;

assign  BiggerInRow = MaxInCol0 > MaxInCol1;

assign  result = BiggerInRow ? MaxInCol0 : MaxInCol1;

endmodule