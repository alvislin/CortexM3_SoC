module L1ConvOutCtrl (
    input   wire            clk,
    input   wire            rstn,

    input   wire            ConvValid_i,
    input   wire            vbit_i,

    output  wire    [4:0]   OutRamAddr_o,
    output  wire            OutRamWe_o,  
    output  wire            ConvReady_o
);

//--------------------------------------------------
//  LOCAL RAM WRITE ADDR CONTRUL
//--------------------------------------------------

reg     [4:0]   OutAddr;
wire    [4:0]   OutAddrNxt;
wire            OutAddrEn;
wire            AddrDone;

assign  AddrDone    =   OutAddr ==  5'd25;

assign  OutAddrNxt  =   ~ConvValid_i    ?   5'b0            :   (
                        vbit_i          ?   OutAddr + 1'b1  :   OutAddr);

always@(posedge clk or negedge rstn) begin
    if(~rstn)
        OutAddr <=  5'b0;
    else
        OutAddr <=  OutAddrNxt;
end

//--------------------------------------------------------
//  OUTPUT 
//--------------------------------------------------------

assign ConvReady_o          =   AddrDone;
assign OutRamWe_o           =   vbit_i;
assign OutRamAddr_o         =   OutAddr;


endmodule