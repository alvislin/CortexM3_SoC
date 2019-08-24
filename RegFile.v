module RegFile #(
    parameter                   Width = 20
)   (
    input   wire                clk,
    input   wire                rstn,
    input   wire                vbit_i,
    input   wire    [Width-1:0] data_i,
    output  wire    [Width-1:0] data_o,
    output  wire                vbit_o
);

//------------------------------------------------
//  VALID BIT REGISTER
//------------------------------------------------

reg             vbit_reg;

always@(posedge clk or negedge rstn) begin
    if(~rstn)
        vbit_reg    <=  1'b0;
    else
        vbit_reg    <=  vbit_i; 
end

//------------------------------------------------
//  DATA REGISTER
//------------------------------------------------

reg [Width-1:0] data_reg;

always@(posedge clk or negedge rstn) begin
    if(~rstn)
        data_reg    <=  0;
    else
        data_reg    <=  data_i;
end

//------------------------------------------------
//  OUTPUT NET
//------------------------------------------------

assign  data_o  =   data_reg;
assign  vbit_o  =   vbit_reg;

endmodule