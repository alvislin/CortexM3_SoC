module L2RAM (
    input   wire                            clock,
    input   wire    [47 : 0]                data,
    input   wire    [3 : 0]                 wraddress,
    input   wire                            wren,
    input   wire    [3 : 0]                 rdaddress,
    output  reg     [47 : 0]                q
);


reg [47 : 0] mem [15 : 0];

always@(posedge clock) begin
    if(wren) mem[wraddress] <= data;
end


always@(posedge clock) begin
    q  <=  mem[rdaddress];
end


endmodule