module Timer(
    input   wire                clk,
    input   wire                rstn,

    input   wire                clk_timer,

    input   wire                TimerRst_i,
    input   wire                TimerEn_i,

    output  wire    [3:0]       Sec_o,
    output  wire    [6:0]       Tenth_o,
    output  wire    [6:0]       Perc_o
);

reg     [3:0]   Prec;
wire            PrecDone;

assign  PrecDone    =   Prec    ==  4'h9;

always@(posedge clk or negedge rstn) begin
    if(~rstn)
        Prec    <=  4'b0;
    else if(TimerRst_i)
        Prec    <=  4'b0;
    else if(clk_timer & TimerEn_i)
        if(PrecDone)
            Prec    <=  4'b0;
        else
            Prec    <=  Prec + 1'b1; 
end

reg     [3:0]   Tenth;
wire            TenthDone;

assign  TenthDone   =   Tenth   ==  4'h9;

always@(posedge clk or negedge rstn) begin
    if(~rstn)
        Tenth   <=  4'b0;
    else if(TimerRst_i)
        Tenth   <=  4'b0;
    else if(clk_timer & TimerEn_i)
        if(PrecDone)
            if(TenthDone)
                Tenth   <=  4'b0;
            else
                Tenth   <=  Tenth + 1'b1;
end

reg     [3:0]   Sec;

always@(posedge clk or negedge rstn) begin
    if(~rstn)
        Sec <=  4'b0;
    else if(TimerRst_i)
        Sec <=  4'b0;
    else if(clk_timer & TimerEn_i)
        if(PrecDone & TenthDone)
            Sec <=  Sec + 1'b1;
end

assign  Sec_o   =   Sec;

wire    [6:0]   Tenth_r;
wire    [6:0]   Perc_r;

assign  Tenth_r =   Tenth   ==  4'h0    ?   7'b0111111  :   (
                    Tenth   ==  4'h1    ?   7'b0000110  :   (
                    Tenth   ==  4'h2    ?   7'b1011011  :   (
                    Tenth   ==  4'h3    ?   7'b1001111  :   (
                    Tenth   ==  4'h4    ?   7'b1100110  :   (
                    Tenth   ==  4'h5    ?   7'b1101101  :   (
                    Tenth   ==  4'h6    ?   7'b1111101  :   (
                    Tenth   ==  4'h7    ?   7'b0000111  :   (
                    Tenth   ==  4'h8    ?   7'b1111111  :   (
                    Tenth   ==  4'h9    ?   7'b1101111  :   7'b0000000)))))))));

assign  Perc_r  =   Prec    ==  4'h0    ?   7'b0111111  :   (
                    Prec    ==  4'h1    ?   7'b0000110  :   (
                    Prec    ==  4'h2    ?   7'b1011011  :   (
                    Prec    ==  4'h3    ?   7'b1001111  :   (
                    Prec    ==  4'h4    ?   7'b1100110  :   (
                    Prec    ==  4'h5    ?   7'b1101101  :   (
                    Prec    ==  4'h6    ?   7'b1111101  :   (
                    Prec    ==  4'h7    ?   7'b0000111  :   (
                    Prec    ==  4'h8    ?   7'b1111111  :   (
                    Prec    ==  4'h9    ?   7'b1101111  :   7'b0000000)))))))));

assign  Tenth_o =   ~Tenth_r;
assign  Perc_o  =   ~Perc_r;

endmodule