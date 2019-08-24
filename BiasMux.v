module BiasMux #(
    parameter               L2Conv0Bias   =   22'b1,
    parameter               L2Conv1Bias   =   22'b1,
    parameter               L2Conv2Bias   =   22'b1,
    parameter               L2Conv3Bias   =   22'b1,
    parameter               L2Conv4Bias   =   22'b1,
    parameter               L2Conv5Bias   =   22'b1,
    parameter               L2Conv6Bias   =   22'b1,
    parameter               L2Conv7Bias   =   22'b1
)   (
    input   wire    [2:0]   Sel_i,
    output  wire    [21:0]  Bias_o
);

assign  Bias_o  =   Sel_i ==  4'h0    ?   L2Conv0Bias   :   (
                    Sel_i ==  4'h1    ?   L2Conv1Bias   :   (
                    Sel_i ==  4'h2    ?   L2Conv2Bias   :   (
                    Sel_i ==  4'h3    ?   L2Conv3Bias   :   (
                    Sel_i ==  4'h4    ?   L2Conv4Bias   :   (
                    Sel_i ==  4'h5    ?   L2Conv5Bias   :   (
                    Sel_i ==  4'h6    ?   L2Conv6Bias   :   L2Conv7Bias))))));

endmodule