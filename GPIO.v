module GPIO #(
    parameter   GPIO_WIDTH = 16,
    parameter   SimPresent = 1
)   (
    input   wire    [GPIO_WIDTH-1:0]  DIR,
    output  wire    [GPIO_WIDTH-1:0]  RDATA,
    input   wire    [GPIO_WIDTH-1:0]  WDATA,
    inout   wire    [GPIO_WIDTH-1:0]  GPIO
);

generate    genvar i;
    for(i=0;i<GPIO_WIDTH;i=i+1) begin :gpio
        if(SimPresent) begin : Sim

            assign  RDATA[i]    =   DIR[i] ?   1'b0        :   GPIO[i];
            assign  GPIO[i]     =   DIR[i] ?   WDATA[i]    :   1'bz;

        end else begin : Syn

            IOBUF GPIOBUF(
            .datain(WDATA[i]),
            .oe(DIR[i]),
            .dataout(RDATA[i]),
            .dataio(GPIO[i])
            );

        end
    end
endgenerate

endmodule


