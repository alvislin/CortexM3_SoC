//-------------------------------------------------------------------
//	2019 8 1
//	HAVE DONE:
//		Pipline & FSM
//		Standardized Coding
//	NEED DO:
//		Simulation
//------------------------------------------------------------------

module ConvLayer(

    // Sys Signals
    input   wire            clk,
    input   wire            rstn,

	// CONV LAYER 1 HANDSHAKE
    input   wire            L1ConvValid_i,
    output  wire            L1ConvReady_o,

	// CONV LAYER 2 HANDSHAKE
    input   wire            L2ConvValid_i,
    output  wire            L2ConvReady_o,

    // Input Data Signals
    output  wire    [5:0]   DataRamAddr_o,
    input   wire    [23:0]  DataRamData_i,

    // Input Weight Signals

    output  wire    [8:0]   WtRamAddr_o,
    input   wire    [191:0] WtRamData_i,

    // Output Mem Signals

    output  wire            OutChan0We_o,  
    output  wire            OutChan1We_o,
    output  wire            OutChan2We_o,
    output  wire            OutChan3We_o,
    output  wire            OutChan4We_o,
    output  wire            OutChan5We_o,
    output  wire            OutChan6We_o,
    output  wire            OutChan7We_o,
    output  wire    [3:0]   OutChanAddr_o,
    output  wire    [47:0]  OutChanData_o
);

localparam 		L1InBP	= 6;
localparam 		L1WtBP	= 7;
localparam		L1OutBP	= 4;
localparam 		L2InBP	= 4;
localparam 		L2WtBP	= 7;
localparam		L2OutBP	= 2;


localparam		L1Conv0Bias = 19'b00000_00010011_000000;
localparam		L1Conv1Bias = 19'b00000_00110001_000000;
localparam		L1Conv2Bias = 19'b00000_00001001_000000;
localparam		L1Conv3Bias = 19'b00000_00100010_000000;
localparam		L1Conv4Bias = 19'b00000_00010011_000000;
localparam		L1Conv5Bias = 19'b00000_00100100_000000;
localparam		L1Conv6Bias = 19'b00000_00010110_000000;
localparam		L1Conv7Bias = 19'b00000_00001100_000000;

localparam		L2Conv0Bias = 22'b0000000000_00001101_0000;
localparam		L2Conv1Bias = 22'b0000000000_00001101_0000;
localparam		L2Conv2Bias = 22'b0000000000_00001101_0000;
localparam		L2Conv3Bias = 22'b0000000000_00011001_0000;
localparam		L2Conv4Bias = 22'b0000000000_00001111_0000;
localparam		L2Conv5Bias = 22'b0000000000_00010000_0000;
localparam		L2Conv6Bias = 22'b0000000000_00001100_0000;
localparam		L2Conv7Bias = 22'b0000000000_00001101_0000;

wire            ConvLayerSel;

//-----------------------------------------------------
//  LOCAL RAM
//-----------------------------------------------------

wire    [95:0]  Ram0WrData;    
wire    [95:0]  Ram1WrData;  
wire    [95:0]  Ram2WrData;  
wire    [95:0]  Ram3WrData;  
wire    [95:0]  Ram4WrData;  
wire    [95:0]  Ram5WrData;  
wire    [95:0]  Ram6WrData;  
wire    [95:0]  Ram7WrData;  

wire    [95:0]  Ram0RdData;    
wire    [95:0]  Ram1RdData;  
wire    [95:0]  Ram2RdData;  
wire    [95:0]  Ram3RdData;  
wire    [95:0]  Ram4RdData;  
wire    [95:0]  Ram5RdData;  
wire    [95:0]  Ram6RdData;  
wire    [95:0]  Ram7RdData;  

wire    [4:0]   RamRdAddr;
wire    [4:0]   RamWrAddr;
wire            RamWrEn;

L1RAM Chan0(
	.clock      			(clk),
	.data       			(Ram0WrData),
	.rdaddress  			(RamRdAddr),
	.wraddress  			(RamWrAddr),
	.wren       			(RamWrEn),
	.q       				(Ram0RdData)
);

L1RAM Chan1(
	.clock      			(clk),
	.data       			(Ram1WrData),
	.rdaddress  			(RamRdAddr),
	.wraddress  			(RamWrAddr),
	.wren       			(RamWrEn),
	.q       				(Ram1RdData)
);

L1RAM Chan2(
	.clock      			(clk),
	.data       			(Ram2WrData),
	.rdaddress  			(RamRdAddr),
	.wraddress  			(RamWrAddr),
	.wren       			(RamWrEn),
	.q       				(Ram2RdData)
);

L1RAM Chan3(
	.clock      			(clk),
	.data       			(Ram3WrData),
	.rdaddress  			(RamRdAddr),
	.wraddress  			(RamWrAddr),
	.wren       			(RamWrEn),
	.q       				(Ram3RdData)
);

L1RAM Chan4(
	.clock      			(clk),
	.data       			(Ram4WrData),
	.rdaddress  			(RamRdAddr),
	.wraddress  			(RamWrAddr),
	.wren       			(RamWrEn),
	.q       				(Ram4RdData)
);

L1RAM Chan5(
	.clock      			(clk),
	.data       			(Ram5WrData),
	.rdaddress  			(RamRdAddr),
	.wraddress  			(RamWrAddr),
	.wren       			(RamWrEn),
	.q       				(Ram5RdData)
);

L1RAM Chan6(
	.clock      			(clk),
	.data       			(Ram6WrData),
	.rdaddress  			(RamRdAddr),
	.wraddress  			(RamWrAddr),
	.wren       			(RamWrEn),
	.q       				(Ram6RdData)
);

L1RAM Chan7(
	.clock      			(clk),
	.data       			(Ram7WrData),
	.rdaddress  			(RamRdAddr),
	.wraddress  			(RamWrAddr),
	.wren       			(RamWrEn),
	.q       				(Ram7RdData)
);


//-----------------------------------------------------
//  WEIGHT BUFFER
//-----------------------------------------------------

wire    [191:0]     WtWinConvLine0;
wire    [191:0]     WtWinConvLine1;
wire                WtBufEn;

InputBuffer #(
    .Width                  (192)
)   WtBuf(
    .clk                    (clk),
    .rstn                   (rstn),
    .din                    (WtRamData_i),
    .en                     (WtBufEn),
	.zero					(1'b0),
    .dout0                  (WtWinConvLine0),
    .dout1                  (WtWinConvLine1)
);

//-----------------------------------------------------
//  CONV L1 INPUT BUFFER & PIXEL DECODER
//-----------------------------------------------------

wire    [23:0]   L1Buf0;
wire    [23:0]   L1Buf1;

wire             L1InBufEn;
wire		     L1InBufZero;
wire			 L1WinMuxZero;

InputBuffer #(
    .Width      			(24)
)   L1InBuf (
    .clk        			(clk),
    .rstn       			(rstn),
    .din        			(DataRamData_i),
    .en         			(L1InBufEn),
	.zero					(L1InBufZero),
    .dout0      			(L1Buf0),
    .dout1      			(L1Buf1)
);

wire    [23:0]  L1DataWinConvLine0;
wire    [23:0]  L1DataWinConvLine1;
wire    [23:0]  L1DataWinConvLine2;
wire    [4:0]   L1ConvWinCnt;

PixelDecoder #(
	.BP						(L1InBP)
)	PxDec(
    .LineIn0    			(L1Buf0),
    .LineIn1    			(L1Buf1),
    .LineIn2    			(DataRamData_i),
    .Sel        			(L1ConvWinCnt),
	.Zero					(L1WinMuxZero),
    .LineOut0   			(L1DataWinConvLine0),
    .LineOut1   			(L1DataWinConvLine1),
    .LineOut2   			(L1DataWinConvLine2)
);

//-----------------------------------------------------
//  CONV L2 INPUT BUFFER & MUX
//-----------------------------------------------------

wire    [95:0]   L2Conv0Buf0;
wire    [95:0]   L2Conv0Buf1;
wire    [95:0]   L2Conv1Buf0;
wire    [95:0]   L2Conv1Buf1;
wire    [95:0]   L2Conv2Buf0;
wire    [95:0]   L2Conv2Buf1;
wire    [95:0]   L2Conv3Buf0;
wire    [95:0]   L2Conv3Buf1;
wire    [95:0]   L2Conv4Buf0;
wire    [95:0]   L2Conv4Buf1;
wire    [95:0]   L2Conv5Buf0;
wire    [95:0]   L2Conv5Buf1;
wire    [95:0]   L2Conv6Buf0;
wire    [95:0]   L2Conv6Buf1;
wire    [95:0]   L2Conv7Buf0;
wire    [95:0]   L2Conv7Buf1;

wire             L2InBufEn;
wire			 L2InBufZero;

InputBuffer #(
	.Width      			(96)
)   L2InBuf0 (
	.clk        			(clk),
	.rstn       			(rstn),
	.din        			(Ram0RdData),
	.en         			(L2InBufEn),
	.zero					(L2InBufZero),
	.dout0      			(L2Conv0Buf0),
	.dout1      			(L2Conv0Buf1)
);

InputBuffer #(
	.Width      			(96)
)   L2InBuf1 (
	.clk        			(clk),
	.rstn       			(rstn),
	.din        			(Ram1RdData),
	.en         			(L2InBufEn),
	.zero					(L2InBufZero),
	.dout0      			(L2Conv1Buf0),
	.dout1      			(L2Conv1Buf1)
);

InputBuffer #(
	.Width      			(96)
)   L2InBuf2 (
	.clk        			(clk),
	.rstn       			(rstn),
	.din        			(Ram2RdData),
	.en         			(L2InBufEn),
	.zero					(L2InBufZero),
	.dout0      			(L2Conv2Buf0),
	.dout1      			(L2Conv2Buf1)
);

InputBuffer #(
	.Width      			(96)
)   L2InBuf3 (
	.clk        			(clk),
	.rstn       			(rstn),
	.din        			(Ram3RdData),
	.en         			(L2InBufEn),
	.zero					(L2InBufZero),
	.dout0      			(L2Conv3Buf0),
	.dout1      			(L2Conv3Buf1)
);

InputBuffer #(
	.Width      			(96)
)   L2InBuf4 (
	.clk        			(clk),
	.rstn       			(rstn),
	.din        			(Ram4RdData),
	.en         			(L2InBufEn),
	.zero					(L2InBufZero),
	.dout0      			(L2Conv4Buf0),
	.dout1      			(L2Conv4Buf1)
);

InputBuffer #(
	.Width      			(96)
)   L2InBuf5 (
	.clk        			(clk),
	.rstn       			(rstn),
	.din        			(Ram5RdData),
	.en         			(L2InBufEn),
	.zero					(L2InBufZero),
	.dout0      			(L2Conv5Buf0),
	.dout1      			(L2Conv5Buf1)
);

InputBuffer #(
	.Width      			(96)
)   L2InBuf6 (
	.clk        			(clk),
	.rstn       			(rstn),
	.din        			(Ram6RdData),
	.en         			(L2InBufEn),
	.zero					(L2InBufZero),
	.dout0      			(L2Conv6Buf0),
	.dout1      			(L2Conv6Buf1)
);

InputBuffer #(
	.Width      			(96)
)   L2InBuf7 (
	.clk        			(clk),
	.rstn       			(rstn),
	.din        			(Ram7RdData),
	.en         			(L2InBufEn),
	.zero					(L2InBufZero),
	.dout0      			(L2Conv7Buf0),
	.dout1      			(L2Conv7Buf1)
);

wire    [23:0]  L2DataWinConv0Line0;
wire    [23:0]  L2DataWinConv0Line1;
wire    [23:0]  L2DataWinConv0Line2;
wire    [23:0]  L2DataWinConv1Line0;
wire    [23:0]  L2DataWinConv1Line1;
wire    [23:0]  L2DataWinConv1Line2;
wire    [23:0]  L2DataWinConv2Line0;
wire    [23:0]  L2DataWinConv2Line1;
wire    [23:0]  L2DataWinConv2Line2;
wire    [23:0]  L2DataWinConv3Line0;
wire    [23:0]  L2DataWinConv3Line1;
wire    [23:0]  L2DataWinConv3Line2;
wire    [23:0]  L2DataWinConv4Line0;
wire    [23:0]  L2DataWinConv4Line1;
wire    [23:0]  L2DataWinConv4Line2;
wire    [23:0]  L2DataWinConv5Line0;
wire    [23:0]  L2DataWinConv5Line1;
wire    [23:0]  L2DataWinConv5Line2;
wire    [23:0]  L2DataWinConv6Line0;
wire    [23:0]  L2DataWinConv6Line1;
wire    [23:0]  L2DataWinConv6Line2;
wire    [23:0]  L2DataWinConv7Line0;
wire    [23:0]  L2DataWinConv7Line1;
wire    [23:0]  L2DataWinConv7Line2;

wire    [3:0]   L2ConvWinCnt;
wire			L2WinMuxZero;

WinMux   WM0(
	.LineIn0    			(L2Conv0Buf0),
	.LineIn1    			(L2Conv0Buf1),
	.LineIn2    			(Ram0RdData),
	.Sel        			(L2ConvWinCnt),
	.Zero					(L2WinMuxZero),
	.LineOut0   			(L2DataWinConv0Line0),
	.LineOut1   			(L2DataWinConv0Line1),
	.LineOut2   			(L2DataWinConv0Line2)
);

WinMux   WM1(
	.LineIn0    			(L2Conv1Buf0),
	.LineIn1    			(L2Conv1Buf1),
	.LineIn2    			(Ram1RdData),
	.Sel        			(L2ConvWinCnt),
	.Zero					(L2WinMuxZero),
	.LineOut0   			(L2DataWinConv1Line0),
	.LineOut1   			(L2DataWinConv1Line1),
	.LineOut2   			(L2DataWinConv1Line2)
);

WinMux   WM2(
	.LineIn0    			(L2Conv2Buf0),
	.LineIn1    			(L2Conv2Buf1),
	.LineIn2    			(Ram2RdData),
	.Sel        			(L2ConvWinCnt),
	.Zero					(L2WinMuxZero),
	.LineOut0   			(L2DataWinConv2Line0),
	.LineOut1   			(L2DataWinConv2Line1),
	.LineOut2   			(L2DataWinConv2Line2)
);

WinMux   WM3(
	.LineIn0    			(L2Conv3Buf0),
	.LineIn1    			(L2Conv3Buf1),
	.LineIn2    			(Ram3RdData),
	.Sel        			(L2ConvWinCnt),
	.Zero					(L2WinMuxZero),
	.LineOut0   			(L2DataWinConv3Line0),
	.LineOut1   			(L2DataWinConv3Line1),
	.LineOut2   			(L2DataWinConv3Line2)
);

WinMux   WM4(
	.LineIn0    			(L2Conv4Buf0),
	.LineIn1    			(L2Conv4Buf1),
	.LineIn2    			(Ram4RdData),
	.Sel        			(L2ConvWinCnt),
	.Zero					(L2WinMuxZero),
	.LineOut0   			(L2DataWinConv4Line0),
	.LineOut1   			(L2DataWinConv4Line1),
	.LineOut2   			(L2DataWinConv4Line2)
);

WinMux   WM5(
	.LineIn0    			(L2Conv5Buf0),
	.LineIn1    			(L2Conv5Buf1),
	.LineIn2    			(Ram5RdData),
	.Sel        			(L2ConvWinCnt),
	.Zero					(L2WinMuxZero),
	.LineOut0   			(L2DataWinConv5Line0),
	.LineOut1   			(L2DataWinConv5Line1),
	.LineOut2   			(L2DataWinConv5Line2)
);

WinMux   WM6(
	.LineIn0    			(L2Conv6Buf0),
	.LineIn1    			(L2Conv6Buf1),
	.LineIn2    			(Ram6RdData),
	.Sel        			(L2ConvWinCnt),
	.Zero					(L2WinMuxZero),
	.LineOut0   			(L2DataWinConv6Line0),
	.LineOut1   			(L2DataWinConv6Line1),
	.LineOut2   			(L2DataWinConv6Line2)
);

WinMux   WM7(
	.LineIn0    			(L2Conv7Buf0),
	.LineIn1    			(L2Conv7Buf1),
	.LineIn2    			(Ram7RdData),
	.Sel        			(L2ConvWinCnt),
	.Zero					(L2WinMuxZero),
	.LineOut0   			(L2DataWinConv7Line0),
	.LineOut1   			(L2DataWinConv7Line1),
	.LineOut2   			(L2DataWinConv7Line2)
);

//-----------------------------------------------------
//  CONV INPUT CONTROLER
//-----------------------------------------------------

wire    [8:0]   L1WtRamAddr;
wire    [8:0]   L2WtRamAddr;
wire			L1ConvInVbit;
wire			L2ConvInVbit;
wire			L1WtBufEn;
wire			L2WtBufEn;

L1ConvInCtrl L1CIC(
	.clk                    (clk),
    .rstn                   (rstn),
    .ConvValid_i            (L1ConvValid_i),
    .DataRamAddr_o        	(DataRamAddr_o),
    .WtRamAddr_o	        (L1WtRamAddr),
    .InBufEn_o              (L1InBufEn),
	.InBufZero_o			(L1InBufZero),
	.WinMuxZero_o			(L1WinMuxZero),
    .WtBufEn_o           	(L1WtBufEn),
    .ConvWinCnt_o           (L1ConvWinCnt),
	.vbit_o					(L1ConvInVbit)
);

L2ConvInCtrl L2CIC(
    .clk                    (clk),
    .rstn                   (rstn),
    .ConvValid_i            (L2ConvValid_i),
    .DataRamAddr_o	        (RamRdAddr),
    .WtRamAddr_o	        (L2WtRamAddr),
    .WtBufEn_o           	(L2WtBufEn),
    .InBufEn_o              (L2InBufEn),
	.InBufZero_o			(L2InBufZero),
	.WinMuxZero_o			(L2WinMuxZero),
    .ConvWinCnt		        (L2ConvWinCnt),
    .ConvSel                (ConvLayerSel),
	.vbit_o					(L2ConvInVbit)
);

assign  WtRamAddr_o	= ConvLayerSel	? L2WtRamAddr : L1WtRamAddr;
assign  WtBufEn	= L1WtBufEn 	| L2WtBufEn;


//-----------------------------------------------------
//  CONV INPUT MUX
//-----------------------------------------------------

wire    [23:0]   DataWinConv0Line0;
wire    [23:0]   DataWinConv0Line1;
wire    [23:0]   DataWinConv0Line2;
wire    [23:0]   DataWinConv1Line0;
wire    [23:0]   DataWinConv1Line1;
wire    [23:0]   DataWinConv1Line2;
wire    [23:0]   DataWinConv2Line0;
wire    [23:0]   DataWinConv2Line1;
wire    [23:0]   DataWinConv2Line2;
wire    [23:0]   DataWinConv3Line0;
wire    [23:0]   DataWinConv3Line1;
wire    [23:0]   DataWinConv3Line2;
wire    [23:0]   DataWinConv4Line0;
wire    [23:0]   DataWinConv4Line1;
wire    [23:0]   DataWinConv4Line2;
wire    [23:0]   DataWinConv5Line0;
wire    [23:0]   DataWinConv5Line1;
wire    [23:0]   DataWinConv5Line2;
wire    [23:0]   DataWinConv6Line0;
wire    [23:0]   DataWinConv6Line1;
wire    [23:0]   DataWinConv6Line2;
wire    [23:0]   DataWinConv7Line0;
wire    [23:0]   DataWinConv7Line1;
wire    [23:0]   DataWinConv7Line2;

Two2OneMux #(
	.Width      			(24)
)   C0L0MUX(
	.din0       			(L1DataWinConvLine0),
	.din1       			(L2DataWinConv0Line0),
	.sel        			(ConvLayerSel),
	.dout       			(DataWinConv0Line0)
);

Two2OneMux #(
	.Width      			(24)
)   C0L1MUX(
	.din0       			(L1DataWinConvLine1),
	.din1       			(L2DataWinConv0Line1),
	.sel        			(ConvLayerSel),
	.dout       			(DataWinConv0Line1)
);

Two2OneMux #(
	.Width      			(24)
)   C0L2MUX(
	.din0       			(L1DataWinConvLine2),
	.din1       			(L2DataWinConv0Line2),
	.sel        			(ConvLayerSel),
	.dout       			(DataWinConv0Line2)
);

Two2OneMux #(
	.Width      			(24)
)   C1L0MUX(
	.din0       			(L1DataWinConvLine0),
	.din1       			(L2DataWinConv1Line0),
	.sel        			(ConvLayerSel),
	.dout       			(DataWinConv1Line0)
);

Two2OneMux #(
	.Width      			(24)
)   C1L1MUX(
	.din0       			(L1DataWinConvLine1),
	.din1       			(L2DataWinConv1Line1),
	.sel        			(ConvLayerSel),
	.dout       			(DataWinConv1Line1)
);

Two2OneMux #(
	.Width      			(24)
)   C1L2MUX(
	.din0       			(L1DataWinConvLine2),
	.din1       			(L2DataWinConv1Line2),
	.sel        			(ConvLayerSel),
	.dout       			(DataWinConv1Line2)
);

Two2OneMux #(
	.Width      			(24)
)   C2L0MUX(
	.din0       			(L1DataWinConvLine0),
	.din1       			(L2DataWinConv2Line0),
	.sel        			(ConvLayerSel),
	.dout       			(DataWinConv2Line0)
);

Two2OneMux #(
	.Width      			(24)
)   C2L1MUX(
	.din0       			(L1DataWinConvLine1),
	.din1       			(L2DataWinConv2Line1),
	.sel        			(ConvLayerSel),
	.dout       			(DataWinConv2Line1)
);

Two2OneMux #(
	.Width      			(24)
)   C2L2MUX(
	.din0       			(L1DataWinConvLine2),
	.din1       			(L2DataWinConv2Line2),
	.sel        			(ConvLayerSel),
	.dout       			(DataWinConv2Line2)
);

Two2OneMux #(
	.Width      			(24)
)   C3L0MUX(
	.din0       			(L1DataWinConvLine0),
	.din1       			(L2DataWinConv3Line0),
	.sel        			(ConvLayerSel),
	.dout       			(DataWinConv3Line0)
);

Two2OneMux #(
	.Width      			(24)
)   C3L1MUX(
	.din0       			(L1DataWinConvLine1),
	.din1       			(L2DataWinConv3Line1),
	.sel        			(ConvLayerSel),
	.dout       			(DataWinConv3Line1)
);

Two2OneMux #(
	.Width      			(24)
)   C3L2MUX(
	.din0       			(L1DataWinConvLine2),
	.din1       			(L2DataWinConv3Line2),
	.sel        			(ConvLayerSel),
	.dout       			(DataWinConv3Line2)
);

Two2OneMux #(
	.Width      			(24)
)   C4L0MUX(
	.din0       			(L1DataWinConvLine0),
	.din1       			(L2DataWinConv4Line0),
	.sel        			(ConvLayerSel),
	.dout       			(DataWinConv4Line0)
);

Two2OneMux #(
	.Width      			(24)
)   C4L1MUX(
	.din0       			(L1DataWinConvLine1),
	.din1       			(L2DataWinConv4Line1),
	.sel        			(ConvLayerSel),
	.dout       			(DataWinConv4Line1)
);

Two2OneMux #(
	.Width      			(24)
)   C4L2MUX(
	.din0       			(L1DataWinConvLine2),
	.din1       			(L2DataWinConv4Line2),
	.sel        			(ConvLayerSel),
	.dout       			(DataWinConv4Line2)
);

Two2OneMux #(
	.Width      			(24)
)   C5L0MUX(
	.din0       			(L1DataWinConvLine0),
	.din1       			(L2DataWinConv5Line0),
	.sel        			(ConvLayerSel),
	.dout       			(DataWinConv5Line0)
);

Two2OneMux #(
	.Width      			(24)
)   C5L1MUX(
	.din0       			(L1DataWinConvLine1),
	.din1       			(L2DataWinConv5Line1),
	.sel        			(ConvLayerSel),
	.dout       			(DataWinConv5Line1)
);

Two2OneMux #(
	.Width      			(24)
)   C5L2MUX(
	.din0       			(L1DataWinConvLine2),
	.din1       			(L2DataWinConv5Line2),
	.sel        			(ConvLayerSel),
	.dout       			(DataWinConv5Line2)
);

Two2OneMux #(
	.Width      			(24)
)   C6L0MUX(
	.din0       			(L1DataWinConvLine0),
	.din1       			(L2DataWinConv6Line0),
	.sel        			(ConvLayerSel),
	.dout       			(DataWinConv6Line0)
);

Two2OneMux #(
	.Width      			(24)
)   C6L1MUX(
	.din0       			(L1DataWinConvLine1),
	.din1       			(L2DataWinConv6Line1),
	.sel        			(ConvLayerSel),
	.dout       			(DataWinConv6Line1)
);

Two2OneMux #(
	.Width      			(24)
)   C6L2MUX(
	.din0       			(L1DataWinConvLine2),
	.din1       			(L2DataWinConv6Line2),
	.sel        			(ConvLayerSel),
	.dout       			(DataWinConv6Line2)
);

Two2OneMux #(
	.Width      			(24)
)   C7L0MUX(
	.din0       			(L1DataWinConvLine0),
	.din1       			(L2DataWinConv7Line0),
	.sel        			(ConvLayerSel),
	.dout       			(DataWinConv7Line0)
);

Two2OneMux #(
	.Width      			(24)
)   C7L1MUX(
	.din0       			(L1DataWinConvLine1),
	.din1       			(L2DataWinConv7Line1),
	.sel        			(ConvLayerSel),
	.dout       			(DataWinConv7Line1)
);

Two2OneMux #(
	.Width      			(24)
)   C7L2MUX(
	.din0       			(L1DataWinConvLine2),
	.din1       			(L2DataWinConv7Line2),
	.sel        			(ConvLayerSel),
	.dout       			(DataWinConv7Line2)
);

//-----------------------------------------------------
//  CONV CORE
//-----------------------------------------------------

wire    [18:0]   ConvOut0;
wire    [18:0]   ConvOut1;
wire    [18:0]   ConvOut2;
wire    [18:0]   ConvOut3;
wire    [18:0]   ConvOut4;
wire    [18:0]   ConvOut5;
wire    [18:0]   ConvOut6;
wire    [18:0]   ConvOut7;

wire			 ConvInVbit;
wire			 Conv0OutVbit;
wire			 Conv1OutVbit;
wire			 Conv2OutVbit;
wire			 Conv3OutVbit;
wire			 Conv4OutVbit;
wire			 Conv5OutVbit;
wire			 Conv6OutVbit;
wire			 Conv7OutVbit;

assign			 ConvInVbit	=	L1ConvInVbit	|
								L2ConvInVbit	;

Convolution Conv0(
	.clk				 	(clk),
	.rstn				 	(rstn),
	.vbit_i				 	(ConvInVbit),
	.vbit_o				 	(Conv0OutVbit),
	.weight_line0        	(WtWinConvLine0[23:0]),
	.weight_line1        	(WtWinConvLine1[23:0]),
	.weight_line2        	(WtRamData_i[23:0]),
	.data_line0          	(DataWinConv0Line0),
	.data_line1          	(DataWinConv0Line1),
	.data_line2          	(DataWinConv0Line2),
	.result              	(ConvOut0)
);

Convolution Conv1(
	.clk				 	(clk),
	.rstn				 	(rstn),
	.vbit_i				 	(ConvInVbit),
	.vbit_o				 	(Conv1OutVbit),
	.weight_line0        	(WtWinConvLine0[47:24]),
	.weight_line1        	(WtWinConvLine1[47:24]),
	.weight_line2        	(WtRamData_i[47:24]),
	.data_line0          	(DataWinConv1Line0),
	.data_line1          	(DataWinConv1Line1),
	.data_line2          	(DataWinConv1Line2),
	.result              	(ConvOut1)
);

Convolution Conv2(
	.clk				 	(clk),
	.rstn				 	(rstn),
	.vbit_i				 	(ConvInVbit),
	.vbit_o				 	(Conv2OutVbit),
	.weight_line0        	(WtWinConvLine0[71:48]),
	.weight_line1        	(WtWinConvLine1[71:48]),
	.weight_line2        	(WtRamData_i[71:48]),
	.data_line0          	(DataWinConv2Line0),
	.data_line1          	(DataWinConv2Line1),
	.data_line2          	(DataWinConv2Line2),
	.result              	(ConvOut2)
);

Convolution Conv3(
	.clk				 	(clk),
	.rstn				 	(rstn),
	.vbit_i				 	(ConvInVbit),
	.vbit_o				 	(Conv3OutVbit),
	.weight_line0        	(WtWinConvLine0[95:72]),
	.weight_line1        	(WtWinConvLine1[95:72]),
	.weight_line2        	(WtRamData_i[95:72]),
	.data_line0          	(DataWinConv3Line0),
	.data_line1          	(DataWinConv3Line1),
	.data_line2          	(DataWinConv3Line2),
	.result              	(ConvOut3)
);

Convolution Conv4(
	.clk				 	(clk),
	.rstn				 	(rstn),
	.vbit_i				 	(ConvInVbit),
	.vbit_o				 	(Conv4OutVbit),
	.weight_line0        	(WtWinConvLine0[119:96]),
	.weight_line1        	(WtWinConvLine1[119:96]),
	.weight_line2        	(WtRamData_i[119:96]),
	.data_line0          	(DataWinConv4Line0),
	.data_line1          	(DataWinConv4Line1),
	.data_line2          	(DataWinConv4Line2),
	.result              	(ConvOut4)
);

Convolution Conv5(
	.clk				 	(clk),
	.rstn				 	(rstn),
	.vbit_i				 	(ConvInVbit),
	.vbit_o				 	(Conv5OutVbit),
	.weight_line0        	(WtWinConvLine0[143:120]),
	.weight_line1        	(WtWinConvLine1[143:120]),
	.weight_line2        	(WtRamData_i[143:120]),
	.data_line0          	(DataWinConv5Line0),
	.data_line1          	(DataWinConv5Line1),
	.data_line2          	(DataWinConv5Line2),
	.result              	(ConvOut5)
);

Convolution Conv6(
	.clk				 	(clk),
	.rstn				 	(rstn),
	.vbit_i				 	(ConvInVbit),
	.vbit_o				 	(Conv6OutVbit),
	.weight_line0        	(WtWinConvLine0[167:144]),
	.weight_line1        	(WtWinConvLine1[167:144]),
	.weight_line2        	(WtRamData_i[167:144]),
	.data_line0          	(DataWinConv6Line0),
	.data_line1          	(DataWinConv6Line1),
	.data_line2          	(DataWinConv6Line2),
	.result              	(ConvOut6)
);

Convolution Conv7(
	.clk				 	(clk),
	.rstn				 	(rstn),
	.vbit_i				 	(ConvInVbit),
	.vbit_o				 	(Conv7OutVbit),
	.weight_line0        	(WtWinConvLine0[191:168]),
	.weight_line1        	(WtWinConvLine1[191:168]),
	.weight_line2        	(WtRamData_i[191:168]),
	.data_line0          	(DataWinConv7Line0),
	.data_line1          	(DataWinConv7Line1),
	.data_line2          	(DataWinConv7Line2),
	.result              	(ConvOut7)
);

//-----------------------------------------------------
//  CONV L1 OFFSET RELU ALGIN
//-----------------------------------------------------

wire    [19:0]  L1Conv0BeforeReLU;
wire    [19:0]  L1Conv1BeforeReLU;
wire    [19:0]  L1Conv2BeforeReLU;
wire    [19:0]  L1Conv3BeforeReLU;
wire    [19:0]  L1Conv4BeforeReLU;
wire    [19:0]  L1Conv5BeforeReLU;
wire    [19:0]  L1Conv6BeforeReLU;
wire    [19:0]  L1Conv7BeforeReLU;

FixPointAdder #(
	.Width					(19)
)   L1Final0(
	.dina   				(ConvOut0),
	.dinb   				(L1Conv0Bias),
	.dout   				(L1Conv0BeforeReLU)
);

FixPointAdder #(
	.Width					(19)
)   L1Final1(
	.dina   				(ConvOut1),
	.dinb   				(L1Conv1Bias),
	.dout   				(L1Conv1BeforeReLU)
);

FixPointAdder #(
	.Width					(19)
)   L1Final2(
	.dina   				(ConvOut2),
	.dinb   				(L1Conv2Bias),
	.dout   				(L1Conv2BeforeReLU)
);

FixPointAdder #(
	.Width					(19)
)   L1Final3(
	.dina   				(ConvOut3),
	.dinb   				(L1Conv3Bias),
	.dout   				(L1Conv3BeforeReLU)
);

FixPointAdder #(
	.Width					(19)
)   L1Final4(
	.dina   				(ConvOut4),
	.dinb   				(L1Conv4Bias),
	.dout   				(L1Conv4BeforeReLU)
);

FixPointAdder #(
	.Width					(19)
)   L1Final5(
	.dina   				(ConvOut5),
	.dinb   				(L1Conv5Bias),
	.dout   				(L1Conv5BeforeReLU)
);

FixPointAdder #(
	.Width					(19)
)   L1Final6(
	.dina   				(ConvOut6),
	.dinb   				(L1Conv6Bias),
	.dout   				(L1Conv6BeforeReLU)
);

FixPointAdder #(
	.Width					(19)
)   L1Final7(
	.dina   				(ConvOut7),
	.dinb   				(L1Conv7Bias),
	.dout   				(L1Conv7BeforeReLU)
);

wire    [19:0]  L1Conv0AfterReLU;
wire    [19:0]  L1Conv1AfterReLU;
wire    [19:0]  L1Conv2AfterReLU;
wire    [19:0]  L1Conv3AfterReLU;
wire    [19:0]  L1Conv4AfterReLU;
wire    [19:0]  L1Conv5AfterReLU;
wire    [19:0]  L1Conv6AfterReLU;
wire    [19:0]  L1Conv7AfterReLU;


ReLU #(
	.Width  				(20)
)    L1relu0(
	.din    				(L1Conv0BeforeReLU),
	.dout   				(L1Conv0AfterReLU)
);

ReLU #(
	.Width  				(20)
)    L1relu1(
	.din    				(L1Conv1BeforeReLU),
	.dout   				(L1Conv1AfterReLU)
);

ReLU #(
	.Width  				(20)
)    L1relu2(
	.din    				(L1Conv2BeforeReLU),
	.dout   				(L1Conv2AfterReLU)
);

ReLU #(
	.Width  				(20)
)    L1relu3(
	.din    				(L1Conv3BeforeReLU),
	.dout   				(L1Conv3AfterReLU)
);

ReLU #(
	.Width  				(20)
)    L1relu4(
	.din    				(L1Conv4BeforeReLU),
	.dout   				(L1Conv4AfterReLU)
);

ReLU #(
	.Width  				(20)
)    L1relu5(
	.din    				(L1Conv5BeforeReLU),
	.dout   				(L1Conv5AfterReLU)
);

ReLU #(
	.Width  				(20)
)    L1relu6(
	.din    				(L1Conv6BeforeReLU),
	.dout   				(L1Conv6AfterReLU)
);

ReLU #(
	.Width  				(20)
)    L1relu7(
	.din    				(L1Conv7BeforeReLU),
	.dout   				(L1Conv7AfterReLU)
);


wire    [7:0]  L1Conv0AfterAlign;
wire    [7:0]  L1Conv1AfterAlign;
wire    [7:0]  L1Conv2AfterAlign;
wire    [7:0]  L1Conv3AfterAlign;
wire    [7:0]  L1Conv4AfterAlign;
wire    [7:0]  L1Conv5AfterAlign;
wire    [7:0]  L1Conv6AfterAlign;
wire    [7:0]  L1Conv7AfterAlign;


Align #(
	.Width      			(20),
	.BP_S0      			(L1InBP),
	.BP_S1      			(L1WtBP),
	.BP_D       			(L1OutBP)
)   L1A0(
	.din        			(L1Conv0AfterReLU),
	.dout   				(L1Conv0AfterAlign)
);

Align #(
	.Width      			(20),
	.BP_S0      			(L1InBP),
	.BP_S1      			(L1WtBP),
	.BP_D       			(L1OutBP)
)   L1A1(
	.din        			(L1Conv1AfterReLU),
	.dout   				(L1Conv1AfterAlign)
);

Align #(
	.Width      			(20),
	.BP_S0      			(L1InBP),
	.BP_S1      			(L1WtBP),
	.BP_D       			(L1OutBP)
)   L1A2(
	.din        			(L1Conv2AfterReLU),
	.dout   				(L1Conv2AfterAlign)
);

Align #(
	.Width      			(20),
	.BP_S0      			(L1InBP),
	.BP_S1      			(L1WtBP),
	.BP_D       			(L1OutBP)
)   L1A3(
	.din        			(L1Conv3AfterReLU),
	.dout   				(L1Conv3AfterAlign)
);

Align #(
	.Width      			(20),
	.BP_S0      			(L1InBP),
	.BP_S1      			(L1WtBP),
	.BP_D       			(L1OutBP)
)   L1A4(
	.din        			(L1Conv4AfterReLU),
	.dout   				(L1Conv4AfterAlign)
);

Align #(
	.Width      			(20),
	.BP_S0      			(L1InBP),
	.BP_S1      			(L1WtBP),
	.BP_D       			(L1OutBP)
)   L1A5(
	.din        			(L1Conv5AfterReLU),
	.dout   				(L1Conv5AfterAlign)
);

Align #(
	.Width      			(20),
	.BP_S0      			(L1InBP),
	.BP_S1      			(L1WtBP),
	.BP_D       			(L1OutBP)
)   L1A6(
	.din        			(L1Conv6AfterReLU),
	.dout   				(L1Conv6AfterAlign)
);

Align #(
	.Width      			(20),
	.BP_S0      			(L1InBP),
	.BP_S1      			(L1WtBP),
	.BP_D       			(L1OutBP)
)   L1A7(
	.din        			(L1Conv7AfterReLU),
	.dout   				(L1Conv7AfterAlign)
);

//-----------------------------------------------------
//  CONV L2 ADDER MARTIX
//-----------------------------------------------------

wire			 ConvOutVbit;
wire			 ATOutVbit;
wire    [21:0]   L2ConvATOut;

assign			 ConvOutVbit	=	Conv0OutVbit	|
									Conv1OutVbit	|
									Conv2OutVbit	|
									Conv3OutVbit	|
									Conv4OutVbit	|
									Conv5OutVbit	|
									Conv6OutVbit	|
									Conv7OutVbit	;

L2ConvAdderTree AM(
	.clk					(clk),
	.rstn					(rstn),
	.vbit_i					(ConvOutVbit),
	.vbit_o					(ATOutVbit),
    .Conv0_Out          	(ConvOut0),
    .Conv1_Out          	(ConvOut1),
    .Conv2_Out          	(ConvOut2),
    .Conv3_Out          	(ConvOut3),
    .Conv4_Out          	(ConvOut4),
    .Conv5_Out          	(ConvOut5),
    .Conv6_Out          	(ConvOut6),
    .Conv7_Out          	(ConvOut7),
    .Conv_Out            	(L2ConvATOut)
);

wire    [22:0]  L2BeforeReLU;
wire	[21:0]	L2ConvBias;
wire	[2:0]	L2BiasSel;

L2BiasMuxCtrl	BMC(
	.clk					(clk),
	.rstn					(rstn),
	.ConvValid_i			(L2ConvValid_i),
	.vbit_i					(ATOutVbit),
	.BiasSel_o				(L2BiasSel)
);

BiasMux #(
	.L2Conv0Bias			(L2Conv0Bias),
	.L2Conv1Bias			(L2Conv1Bias),
	.L2Conv2Bias			(L2Conv2Bias),
	.L2Conv3Bias			(L2Conv3Bias),
	.L2Conv4Bias			(L2Conv4Bias),
	.L2Conv5Bias			(L2Conv5Bias),
	.L2Conv6Bias			(L2Conv6Bias),
	.L2Conv7Bias			(L2Conv7Bias)
)	BM(
	.Sel_i					(L2BiasSel),
	.Bias_o					(L2ConvBias)
);

FixPointAdder #(
    .Width(22)
)   L2Final(
    .dina   				(L2ConvATOut),
    .dinb   				(L2Conv0Bias),
    .dout   				(L2BeforeReLU)
);

wire    [22:0]  L2AfterReLU;

ReLU #(
    .Width  (23)
)    L2relu(
    .din    				(L2BeforeReLU),
    .dout   				(L2AfterReLU)
);

wire    [7:0]   L2AfterAlign;

Align #(
    .Width      			(23),
    .BP_S0      			(L2InBP),
    .BP_S1      			(L2WtBP),
    .BP_D       			(L2OutBP)
)   L2A(
    .din        			(L2AfterReLU),
    .dout       			(L2AfterAlign)
);

//-----------------------------------------------------
//  CONV RS CONTROLER
//-----------------------------------------------------

wire    L1ConvPoolLine0We;
wire    L1ConvPoolLine1We;
wire    [4:0] L1ConvPoolLineSel;

wire    L2ConvPoolLine0We;
wire    L2ConvPoolLine1We;
wire    [3:0] L2ConvPoolLineSel;

wire	L2RsZero;

wire	L1RsOutVbit;
wire	L2RsOutVbit;

L1RsCtrl L1RC(
	.clk					(clk),
	.rstn					(rstn),
	.ConvValid_i			(L1ConvValid_i),
	.vbit_i					(ConvOutVbit),
	.PoolLineSel_o			(L1ConvPoolLineSel),
	.PoolLine0We_o			(L1ConvPoolLine0We),
	.PoolLine1We_o			(L1ConvPoolLine1We),
	.vbit_o					(L1RsOutVbit)
);

L2RsCtrl L2RC(
	.clk					(clk),
	.rstn					(rstn),
	.ConvValid_i			(L2ConvValid_i),
	.vbit_i					(ATOutVbit),
	.RsZero_o				(L2RsZero),
	.PoolLineSel_o			(L2ConvPoolLineSel),
	.PoolLine0We_o			(L2ConvPoolLine0We),
	.PoolLine1We_o			(L2ConvPoolLine1We),
	.vbit_o					(L2RsOutVbit)
);

//-----------------------------------------------------
//  CONV POOL LINE REG
//-----------------------------------------------------

wire    [191:0] L1Conv0PoolLine0;
wire    [191:0] L1Conv0PoolLine1;
wire    [191:0] L1Conv1PoolLine0;
wire    [191:0] L1Conv1PoolLine1;
wire    [191:0] L1Conv2PoolLine0;
wire    [191:0] L1Conv2PoolLine1;
wire    [191:0] L1Conv3PoolLine0;
wire    [191:0] L1Conv3PoolLine1;
wire    [191:0] L1Conv4PoolLine0;
wire    [191:0] L1Conv4PoolLine1;
wire    [191:0] L1Conv5PoolLine0;
wire    [191:0] L1Conv5PoolLine1;
wire    [191:0] L1Conv6PoolLine0;
wire    [191:0] L1Conv6PoolLine1;
wire    [191:0] L1Conv7PoolLine0;
wire    [191:0] L1Conv7PoolLine1;

wire    [95:0] L2ConvPoolLine0;
wire    [95:0] L2ConvPoolLine1;

L1RegSplice   L1Conv0PoolLine0RS(
	.clk        			(clk),
	.rstn       			(rstn),
	.din        			(L1Conv0AfterAlign),
	.Sel        			(L1ConvPoolLineSel),
	.We         			(L1ConvPoolLine0We),
	.dout       			(L1Conv0PoolLine0)
);	

L1RegSplice   L1Conv0PoolLine1RS(
	.clk        			(clk),
	.rstn       			(rstn),
	.din        			(L1Conv0AfterAlign),
	.Sel        			(L1ConvPoolLineSel),
	.We         			(L1ConvPoolLine1We),
	.dout       			(L1Conv0PoolLine1)
);

L1RegSplice   L1Conv1PoolLine0RS(
	.clk        			(clk),
	.rstn       			(rstn),
	.din        			(L1Conv1AfterAlign),
	.Sel        			(L1ConvPoolLineSel),
	.We         			(L1ConvPoolLine0We),
	.dout       			(L1Conv1PoolLine0)
);

L1RegSplice   L1Conv1PoolLine1RS(
	.clk        			(clk),
	.rstn       			(rstn),
	.din        			(L1Conv1AfterAlign),
	.Sel        			(L1ConvPoolLineSel),
	.We         			(L1ConvPoolLine1We),
	.dout       			(L1Conv1PoolLine1)
);

L1RegSplice   L1Conv2PoolLine0RS(
	.clk        			(clk),
	.rstn       			(rstn),
	.din        			(L1Conv2AfterAlign),
	.Sel        			(L1ConvPoolLineSel),
	.We         			(L1ConvPoolLine0We),
	.dout       			(L1Conv2PoolLine0)
);

L1RegSplice   L1Conv2PoolLine1RS(
	.clk        			(clk),
	.rstn       			(rstn),
	.din        			(L1Conv2AfterAlign),
	.Sel        			(L1ConvPoolLineSel),
	.We         			(L1ConvPoolLine1We),
	.dout       			(L1Conv2PoolLine1)
);

L1RegSplice   L1Conv3PoolLine0RS(
	.clk        			(clk),
	.rstn       			(rstn),
	.din        			(L1Conv3AfterAlign),
	.Sel        			(L1ConvPoolLineSel),
	.We         			(L1ConvPoolLine0We),
	.dout       			(L1Conv3PoolLine0)
);

L1RegSplice   L1Conv3PoolLine1RS(
	.clk        			(clk),
	.rstn       			(rstn),
	.din        			(L1Conv3AfterAlign),
	.Sel        			(L1ConvPoolLineSel),
	.We         			(L1ConvPoolLine1We),
	.dout       			(L1Conv3PoolLine1)
);

L1RegSplice   L1Conv4PoolLine0RS(
	.clk        			(clk),
	.rstn       			(rstn),
	.din        			(L1Conv4AfterAlign),
	.Sel        			(L1ConvPoolLineSel),
	.We         			(L1ConvPoolLine0We),
	.dout       			(L1Conv4PoolLine0)
);

L1RegSplice   L1Conv4PoolLine1RS(
	.clk        			(clk),
	.rstn       			(rstn),
	.din        			(L1Conv4AfterAlign),
	.Sel        			(L1ConvPoolLineSel),
	.We         			(L1ConvPoolLine1We),
	.dout       			(L1Conv4PoolLine1)
);

L1RegSplice   L1Conv5PoolLine0RS(
	.clk        			(clk),
	.rstn       			(rstn),
	.din        			(L1Conv5AfterAlign),
	.Sel        			(L1ConvPoolLineSel),
	.We         			(L1ConvPoolLine0We),
	.dout       			(L1Conv5PoolLine0)
);

L1RegSplice   L1Conv5PoolLine1RS(
	.clk        			(clk),
	.rstn       			(rstn),
	.din        			(L1Conv5AfterAlign),
	.Sel        			(L1ConvPoolLineSel),
	.We         			(L1ConvPoolLine1We),
	.dout       			(L1Conv5PoolLine1)
);

L1RegSplice   L1Conv6PoolLine0RS(
	.clk        			(clk),
	.rstn       			(rstn),
	.din        			(L1Conv6AfterAlign),
	.Sel        			(L1ConvPoolLineSel),
	.We         			(L1ConvPoolLine0We),
	.dout       			(L1Conv6PoolLine0)
);

L1RegSplice   L1Conv6PoolLine1RS(
	.clk        			(clk),
	.rstn       			(rstn),
	.din        			(L1Conv6AfterAlign),
	.Sel        			(L1ConvPoolLineSel),
	.We         			(L1ConvPoolLine1We),
	.dout       			(L1Conv6PoolLine1)
);

L1RegSplice   L1Conv7PoolLine0RS(
	.clk        			(clk),
	.rstn       			(rstn),
	.din        			(L1Conv7AfterAlign),
	.Sel        			(L1ConvPoolLineSel),
	.We         			(L1ConvPoolLine0We),
	.dout       			(L1Conv7PoolLine0)
);

L1RegSplice   L1Conv7PoolLine1RS(
	.clk        			(clk),
	.rstn       			(rstn),
	.din        			(L1Conv7AfterAlign),
	.Sel        			(L1ConvPoolLineSel),
	.We         			(L1ConvPoolLine1We),
	.dout       			(L1Conv7PoolLine1)
);

L2RegSplice   L2ConvPoolLine0RS(
	.clk        			(clk),
	.rstn       			(rstn),
	.din        			(L2AfterAlign),
	.Sel        			(L2ConvPoolLineSel),
	.We         			(L2ConvPoolLine0We),
	.Zero					(1'b0),
	.dout       			(L2ConvPoolLine0)
);

L2RegSplice   L2ConvPoolLine1RS(
	.clk        			(clk),
	.rstn       			(rstn),
	.din        			(L2AfterAlign),
	.Sel        			(L2ConvPoolLineSel),
	.We         			(L2ConvPoolLine1We),
	.Zero					(L2RsZero),
	.dout       			(L2ConvPoolLine1)
);

//-----------------------------------------------------
//  CONV POOL 
//-----------------------------------------------------

Pool #(
	.ByteWidth				(24)
)   L1Pool0 (
	.line0					(L1Conv0PoolLine0),
	.line1					(L1Conv0PoolLine1),
	.outline				(Ram0WrData)
);

Pool #(
	.ByteWidth				(24)
)   L1Pool1 (
	.line0					(L1Conv1PoolLine0),
	.line1					(L1Conv1PoolLine1),
	.outline				(Ram1WrData)
);

Pool #(
	.ByteWidth				(24)
)   L1Pool2 (
	.line0					(L1Conv2PoolLine0),
	.line1					(L1Conv2PoolLine1),
	.outline				(Ram2WrData)
);

Pool #(
	.ByteWidth				(24)
)   L1Pool3 (
	.line0					(L1Conv3PoolLine0),
	.line1					(L1Conv3PoolLine1),
	.outline				(Ram3WrData)
);

Pool #(
	.ByteWidth				(24)
)   L1Pool4 (
	.line0					(L1Conv4PoolLine0),
	.line1					(L1Conv4PoolLine1),
	.outline				(Ram4WrData)
);

Pool #(
	.ByteWidth				(24)
)   L1Pool5 (
	.line0					(L1Conv5PoolLine0),
	.line1					(L1Conv5PoolLine1),
	.outline				(Ram5WrData)
);

Pool #(
	.ByteWidth				(24)
)   L1Pool6 (
	.line0					(L1Conv6PoolLine0),
	.line1					(L1Conv6PoolLine1),
	.outline				(Ram6WrData)
);

Pool #(
	.ByteWidth				(24)
)   L1Pool7 (
	.line0					(L1Conv7PoolLine0),
	.line1					(L1Conv7PoolLine1),
	.outline				(Ram7WrData)
);

Pool #(
	.ByteWidth				(12)
)   L2Pool (
	.line0					(L2ConvPoolLine0),
	.line1					(L2ConvPoolLine1),
	.outline				(OutChanData_o)
);

//-----------------------------------------------------
//  CONV OUTPUT CONTROL
//-----------------------------------------------------

L1ConvOutCtrl L1COC(
	.clk					(clk),
	.rstn					(rstn),
	.ConvValid_i			(L1ConvValid_i),
	.vbit_i					(L1RsOutVbit),
	.OutRamAddr_o			(RamWrAddr),
	.OutRamWe_o				(RamWrEn),
	.ConvReady_o			(L1ConvReady_o)
);

L2ConvOutCtrl L2COC(
	.clk					(clk),
	.rstn					(rstn),
	.ConvValid_i			(L2ConvValid_i),
	.vbit_i					(L2RsOutVbit),
	.OutputLocalRAMAddr_o	(OutChanAddr_o),
	.OutputLocalRAM0We_o	(OutChan0We_o),
	.OutputLocalRAM1We_o	(OutChan1We_o),
	.OutputLocalRAM2We_o	(OutChan2We_o),
	.OutputLocalRAM3We_o	(OutChan3We_o),
	.OutputLocalRAM4We_o	(OutChan4We_o),
	.OutputLocalRAM5We_o	(OutChan5We_o),
	.OutputLocalRAM6We_o	(OutChan6We_o),
	.OutputLocalRAM7We_o	(OutChan7We_o),
	.ConvReady_o			(L2ConvReady_o)
);

endmodule