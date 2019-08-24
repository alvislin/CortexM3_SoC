module PixelDecoder #(
    parameter               BP = 0
)   (
    input   wire    [23:0]  LineIn0,
    input   wire    [23:0]  LineIn1,
    input   wire    [23:0]  LineIn2,
    input   wire    [4:0]   Sel,
    input   wire            Zero,
    output  wire    [23:0]  LineOut0,
    output  wire    [23:0]  LineOut1,
    output  wire    [23:0]  LineOut2
);
generate 
    if(BP == 0) begin : BP0

        assign LineOut0 = Sel  ==  5'b0    ?   {7'b0,LineIn0[1],7'b0,LineIn0[0],8'b0}      :    (
                          Sel  ==  5'd23   ?   {8'b0,7'b0,LineIn0[23],7'b0,LineIn0[22]}    :    {7'b0,LineIn0[Sel + 1],7'b0,LineIn0[Sel],7'b0,LineIn0[Sel - 1]});
        assign LineOut1 = Sel  ==  5'b0    ?   {7'b0,LineIn1[1],7'b0,LineIn1[0],8'b0}      :    (
                          Sel  ==  5'd23   ?   {8'b0,7'b0,LineIn1[23],7'b0,LineIn1[22]}    :    {7'b0,LineIn1[Sel + 1],7'b0,LineIn1[Sel],7'b0,LineIn1[Sel - 1]});
        assign LineOut2 = Zero             ?   24'b0                                       :    (
                          Sel  ==  5'b0    ?   {7'b0,LineIn2[1],7'b0,LineIn2[0],8'b0}      :    (
                          Sel  ==  5'd23   ?   {8'b0,7'b0,LineIn2[23],7'b0,LineIn2[22]}    :    {7'b0,LineIn2[Sel + 1],7'b0,LineIn2[Sel],7'b0,LineIn2[Sel - 1]}));
    end else if(BP == 6) begin : BP6

        assign LineOut0 = Sel  ==  5'b0    ?   {1'b0,LineIn0[1],7'b0,LineIn0[0],6'b0,8'b0}      :    (
                          Sel  ==  5'd23   ?   {8'b0,1'b0,LineIn0[23],7'b0,LineIn0[22],6'b0}    :    {1'b0,LineIn0[Sel + 1],7'b0,LineIn0[Sel],7'b0,LineIn0[Sel - 1],6'b0});
        assign LineOut1 = Sel  ==  5'b0    ?   {1'b0,LineIn1[1],7'b0,LineIn1[0],6'b0,8'b0}      :    (
                          Sel  ==  5'd23   ?   {8'b0,1'b0,LineIn1[23],7'b0,LineIn1[22],6'b0}    :    {1'b0,LineIn1[Sel + 1],7'b0,LineIn1[Sel],7'b0,LineIn1[Sel - 1],6'b0});
        assign LineOut2 = Zero             ?   24'b0                                            :    (
                          Sel  ==  5'b0    ?   {1'b0,LineIn2[1],7'b0,LineIn2[0],6'b0,8'b0}      :    (
                          Sel  ==  5'd23   ?   {8'b0,1'b0,LineIn2[23],7'b0,LineIn2[22],6'b0}    :    {1'b0,LineIn2[Sel + 1],7'b0,LineIn2[Sel],7'b0,LineIn2[Sel - 1],6'b0}));

    end else begin : BPN

        wire    [6 - BP : 0]    ZERO_H;
        wire    [BP - 1 : 0]    ZERO_L;

        assign  ZERO_H = 0;
        assign  ZERO_L = 0;

        assign LineOut0 = Sel  ==  5'b0    ?   {ZERO_H,LineIn0[1],7'b0,LineIn0[0],ZERO_L,8'b0}      :    (
                          Sel  ==  5'd23   ?   {8'b0,ZERO_H,LineIn0[23],7'b0,LineIn0[22],ZERO_L}    :    {ZERO_H,LineIn0[Sel + 1],7'b0,LineIn0[Sel],7'b0,LineIn0[Sel - 1],ZERO_L});
        assign LineOut1 = Sel  ==  5'b0    ?   {ZERO_H,LineIn1[1],7'b0,LineIn1[0],ZERO_L,8'b0}      :    (
                          Sel  ==  5'd23   ?   {8'b0,ZERO_H,LineIn1[23],7'b0,LineIn1[22],ZERO_L}    :    {ZERO_H,LineIn1[Sel + 1],7'b0,LineIn1[Sel],7'b0,LineIn1[Sel - 1],ZERO_L});
        assign LineOut2 = Zero             ?   24'b0                                                :    (
                          Sel  ==  5'b0    ?   {ZERO_H,LineIn2[1],7'b0,LineIn2[0],ZERO_L,8'b0}      :    (
                          Sel  ==  5'd23   ?   {8'b0,ZERO_H,LineIn2[23],7'b0,LineIn2[22],ZERO_L}    :    {ZERO_H,LineIn2[Sel + 1],7'b0,LineIn2[Sel],7'b0,LineIn2[Sel - 1],ZERO_L}));
    end
endgenerate

endmodule