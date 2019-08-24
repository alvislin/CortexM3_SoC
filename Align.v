module Align #(
    parameter               Width = 20,
    parameter               BP_S0 = 1,
    parameter               BP_S1 = 1,
    parameter               BP_D = 2
)   (
    input   wire    [Width-1:0]  din,
    output  wire    [7:0]        dout
);

generate
    if(BP_S1 + BP_S0 < BP_D) begin : left_shift_boom

        wire [BP_D - BP_S0 - BP_S1 - 1: 0] zero;
        assign zero = 0;
        assign dout[6:0] = {din[6 - (BP_D - BP_S0 - BP_S1) : 0],zero};

    end else if(BP_S0 + BP_S1 > BP_D + Width - 8) begin : right_shift_boom

        wire [BP_S0 + BP_S1 - BP_D - Width + 7: 0] zero;
        assign zero = 0;
        assign dout[6:0] = din[BP_S0 + BP_S1 - BP_D - 1] ? {zero,din[Width - 2 : BP_S0 + BP_S1 - BP_D]} + 1'b1 : {zero,din[Width - 2 : BP_S0 + BP_S1 - BP_D]};

    end else begin : no_shift

        assign dout[6:0] = din[BP_S0 + BP_S1 - BP_D - 1] ? din[6 - BP_D + BP_S0 + BP_S1 : BP_S0 + BP_S1 - BP_D] + 1'b1 : din[6 - BP_D + BP_S0 + BP_S1 : BP_S0 + BP_S1 - BP_D];

    end
endgenerate

assign dout[7] = din[Width - 1];

endmodule