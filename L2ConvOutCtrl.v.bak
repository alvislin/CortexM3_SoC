module L2ConvOutCtrl (
    input   wire            clk,
    input   wire            rstn,

    input   wire            ConvValid_i,
    input   wire            vbit_i,

    output  wire    [3:0]   OutputLocalRAMAddr_o,
    output  wire            OutputLocalRAM0We_o,  
    output  wire            OutputLocalRAM1We_o,  
    output  wire            OutputLocalRAM2We_o,  
    output  wire            OutputLocalRAM3We_o,  
    output  wire            OutputLocalRAM4We_o,  
    output  wire            OutputLocalRAM5We_o,  
    output  wire            OutputLocalRAM6We_o,  
    output  wire            OutputLocalRAM7We_o,  
    output  wire            ConvReady_o
);

//--------------------------------------------------
//  LOCAL RAM WRITE ADDR CONTRUL
//--------------------------------------------------

reg     [3:0]   OutAddr;
wire    [3:0]   OutAddrNxt;
wire            AddrDone;

assign  AddrDone    =   OutAddr ==  4'hc;

assign  OutAddrNxt  =   ~ConvValid_i    ?   4'h0    :   (
                        ~vbit_i         ?   OutAddr :   (
                        AddrDone        ?   4'h0    :   OutAddr + 1'b1));  

always@(posedge clk or negedge rstn) begin
    if(~rstn)
        OutAddr <=  4'b0;
    else
        OutAddr <=  OutAddrNxt;
end


//--------------------------------------------------
//  CHANNEL CNT
//--------------------------------------------------

reg     [2:0]   ChannelCnt;
wire    [2:0]   ChannelCntNxt;
wire            ChannelDone;

assign  ChannelDone    =   ChannelCnt ==  3'b111;

assign  ChannelCntNxt  =    ~ConvValid_i    ?   3'b0        :   (
                            ~vbit_i         ?   ChannelCnt  :   (
                            ~AddrDone       ?   ChannelCnt  :   ChannelCnt +   1'b1));

always@(posedge clk or negedge rstn) begin
    if(~rstn)
        ChannelCnt <=  5'b0;
    else
        ChannelCnt <=  ChannelCntNxt; 
end

//--------------------------------------------------------
//  OUTPUT 
//--------------------------------------------------------

assign ConvReady_o          =   AddrDone    &   ChannelDone &   vbit_i;
assign OutputLocalRAM0We_o  =   vbit_i      &   (ChannelCnt ==  3'h0);
assign OutputLocalRAM1We_o  =   vbit_i      &   (ChannelCnt ==  3'h1);
assign OutputLocalRAM2We_o  =   vbit_i      &   (ChannelCnt ==  3'h2);
assign OutputLocalRAM3We_o  =   vbit_i      &   (ChannelCnt ==  3'h3);
assign OutputLocalRAM4We_o  =   vbit_i      &   (ChannelCnt ==  3'h4);
assign OutputLocalRAM5We_o  =   vbit_i      &   (ChannelCnt ==  3'h5);
assign OutputLocalRAM6We_o  =   vbit_i      &   (ChannelCnt ==  3'h6);
assign OutputLocalRAM7We_o  =   vbit_i      &   (ChannelCnt ==  3'h7);
assign OutputLocalRAMAddr_o =   OutAddr;


endmodule