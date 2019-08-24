module L1RAM (
    input   wire                            clock,
    input   wire    [95 : 0]                data,
    input   wire    [4 : 0]                 wraddress,
    input   wire                            wren,
    input   wire    [4 : 0]                 rdaddress,
    output  reg     [95 : 0]                q
);


reg [95 : 0] mem [31 : 0];

always@(posedge clock) begin
    if(wren) mem[wraddress] <= data;
end


always@(posedge clock) begin
    q  <=  mem[rdaddress];
end


endmodule