//--------------------------------------------//
// Data   RAM         0   0x40030000          //
// ........                                   //
// Data   RAM         149 0x40030095          //
// STATE              REG 0x40030096          //
// NUM0                   0x40030097          //
// ........                                   //
// NUM0                   0x400300a0          //
//--------------------------------------------//
module AHBlite_ACCC (
    input   wire                        HCLK,    
    input   wire                        HRESETn, 
    input   wire                        HSEL,    
    input   wire    [31:0]              HADDR,   
    input   wire    [1:0]               HTRANS,  
    input   wire    [2:0]               HSIZE,   
    input   wire    [3:0]               HPROT,   
    input   wire                        HWRITE,  
    input   wire    [31:0]              HWDATA,   
    input   wire                        HREADY, 
    output  wire                        HREADYOUT, 
    output  wire    [31:0]              HRDATA,  
    output  wire    [1:0]               HRESP,

    input   wire    [5:0]               Data_RAM_RD_Addr,
    output  wire    [23:0]              Data_RAM_RD_Data,

    input   wire    [8:0]               Weight_RAM_RD_Addr,
    output  wire    [191:0]             Weight_RAM_RD_Data,

    input   wire    [7:0]               Num0,
    input   wire    [7:0]               Num1,
    input   wire    [7:0]               Num2,
    input   wire    [7:0]               Num3,
    input   wire    [7:0]               Num4,
    input   wire    [7:0]               Num5,
    input   wire    [7:0]               Num6,
    input   wire    [7:0]               Num7,
    input   wire    [7:0]               Num8,
    input   wire    [7:0]               Num9,

    output  wire                        ACC_VALID,
    input   wire                        ACC_READY
);

//--------------------------------------------------
// RAM
//--------------------------------------------------

reg     [5:0]   Data_RAM_WR_Addr;
wire    [7:0]   Data_RAM_WR_Data;
wire    [2:0]   Data_RAM_WE_T;

LocalRAM #(
    .ByteWidth      (3),
    .AddrWidth      (6)
)   Data_RAM(
    .clk        (HCLK),
    .din        (Data_RAM_WR_Data),
    .rdaddr     (Data_RAM_RD_Addr),
    .we         (Data_RAM_WE_T),
    .wraddr     (Data_RAM_WR_Addr),
    .dout       (Data_RAM_RD_Data)
);

LocalROM #(
    .ByteWidth      (24),
    .AddrWidth      (9)
)   Weight_RAM(
    .clk        (HCLK),
    .addr       (Weight_RAM_RD_Addr),
    .dout       (Weight_RAM_RD_Data)
);

//--------------------------------------------------
// AHB SIGNALS
//--------------------------------------------------

assign HRESP        = 2'b0;
assign HREADYOUT    = 1'b1;

wire trans_en;
assign trans_en     = HSEL & HTRANS[1] & HREADY;

wire write_en;
assign write_en     = trans_en & HWRITE;


reg wr_en_reg;
always@(posedge HCLK or negedge HRESETn) begin
  if(~HRESETn) 
    wr_en_reg <= 1'b0;
  else 
    wr_en_reg <= write_en;
end

reg [7:0] addr_reg;
always@(posedge HCLK or negedge HRESETn) begin
  if(~HRESETn) 
    addr_reg <= 4'b0;
  else if(trans_en) 
    addr_reg <= HADDR[7:0];
end

//--------------------------------------------------
// STATE CONTROL
//--------------------------------------------------

reg state;
wire state_nxt;

assign state_en     = wr_en_reg &   (addr_reg == 8'h96) & HWDATA[0];
assign state_nxt    = state     ?   (~ACC_READY)    :   state_en;

always@(posedge HCLK or negedge HRESETn) begin
  if(~HRESETn) 
    state <= 1'b0;
  else 
    state <= state_nxt;
end

assign  ACC_VALID   =   state;

//--------------------------------------------------
// DATA RAM CONTROL
//--------------------------------------------------

// assign  Data_RAM_WE         =   wr_en_reg   &   (addr_reg == 4'h0);
// assign  Data_RAM_WR_Addr    =   HWDATA[29:24];
assign  Data_RAM_WR_Data    =   HWDATA[7:0];

reg     [2:0]   Data_RAM_WE;

assign  Data_RAM_WE_T = wr_en_reg ? Data_RAM_WE : 3'h0;

always@(*) begin
  case(addr_reg)
    8'h00 : begin
      Data_RAM_WE = 3'h1;
      Data_RAM_WR_Addr = 6'h00;
    end 8'h1 : begin
      Data_RAM_WR_Addr = 6'h0;
      Data_RAM_WE = 3'h2;
    end 8'h2 : begin
      Data_RAM_WR_Addr = 6'h0;
      Data_RAM_WE = 3'h4;
    end 8'h3 : begin
      Data_RAM_WR_Addr = 6'h1;
      Data_RAM_WE = 3'h1;
    end 8'h4 : begin
      Data_RAM_WR_Addr = 6'h1;
      Data_RAM_WE = 3'h2;
    end 8'h5 : begin
      Data_RAM_WR_Addr = 6'h1;
      Data_RAM_WE = 3'h4;
    end 8'h6 : begin
      Data_RAM_WR_Addr = 6'h2;
      Data_RAM_WE = 3'h1;
    end 8'h7 : begin
      Data_RAM_WR_Addr = 6'h2;
      Data_RAM_WE = 3'h2;
    end 8'h8 : begin
      Data_RAM_WR_Addr = 6'h2;
      Data_RAM_WE = 3'h4;
    end 8'h9 : begin
      Data_RAM_WR_Addr = 6'h3;
      Data_RAM_WE = 3'h1;
    end 8'ha : begin
      Data_RAM_WR_Addr = 6'h3;
      Data_RAM_WE = 3'h2;
    end 8'hb : begin
      Data_RAM_WR_Addr = 6'h3;
      Data_RAM_WE = 3'h4;
    end 8'hc : begin
      Data_RAM_WR_Addr = 6'h4;
      Data_RAM_WE = 3'h1;
    end 8'hd : begin
      Data_RAM_WR_Addr = 6'h4;
      Data_RAM_WE = 3'h2;
    end 8'he : begin
      Data_RAM_WR_Addr = 6'h4;
      Data_RAM_WE = 3'h4;
    end 8'hf : begin
      Data_RAM_WR_Addr = 6'h5;
      Data_RAM_WE = 3'h1;
    end 8'h10 : begin
      Data_RAM_WR_Addr = 6'h5;
      Data_RAM_WE = 3'h2;
    end 8'h11 : begin
      Data_RAM_WR_Addr = 6'h5;
      Data_RAM_WE = 3'h4;
    end 8'h12 : begin
      Data_RAM_WR_Addr = 6'h6;
      Data_RAM_WE = 3'h1;
    end 8'h13 : begin
      Data_RAM_WR_Addr = 6'h6;
      Data_RAM_WE = 3'h2;
    end 8'h14 : begin
      Data_RAM_WR_Addr = 6'h6;
      Data_RAM_WE = 3'h4;
    end 8'h15 : begin
      Data_RAM_WR_Addr = 6'h7;
      Data_RAM_WE = 3'h1;
    end 8'h16 : begin
      Data_RAM_WR_Addr = 6'h7;
      Data_RAM_WE = 3'h2;
    end 8'h17 : begin
      Data_RAM_WR_Addr = 6'h7;
      Data_RAM_WE = 3'h4;
    end 8'h18 : begin
      Data_RAM_WR_Addr = 6'h8;
      Data_RAM_WE = 3'h1;
    end 8'h19 : begin
      Data_RAM_WR_Addr = 6'h8;
      Data_RAM_WE = 3'h2;
    end 8'h1a : begin
      Data_RAM_WR_Addr = 6'h8;
      Data_RAM_WE = 3'h4;
    end 8'h1b : begin
      Data_RAM_WR_Addr = 6'h9;
      Data_RAM_WE = 3'h1;
    end 8'h1c : begin
      Data_RAM_WR_Addr = 6'h9;
      Data_RAM_WE = 3'h2;
    end 8'h1d : begin
      Data_RAM_WR_Addr = 6'h9;
      Data_RAM_WE = 3'h4;
    end 8'h1e : begin
      Data_RAM_WR_Addr = 6'ha;
      Data_RAM_WE = 3'h1;
    end 8'h1f : begin
      Data_RAM_WR_Addr = 6'ha;
      Data_RAM_WE = 3'h2;
    end 8'h20 : begin
      Data_RAM_WR_Addr = 6'ha;
      Data_RAM_WE = 3'h4;
    end 8'h21 : begin
      Data_RAM_WR_Addr = 6'hb;
      Data_RAM_WE = 3'h1;
    end 8'h22 : begin
      Data_RAM_WR_Addr = 6'hb;
      Data_RAM_WE = 3'h2;
    end 8'h23 : begin
      Data_RAM_WR_Addr = 6'hb;
      Data_RAM_WE = 3'h4;
    end 8'h24 : begin
      Data_RAM_WR_Addr = 6'hc;
      Data_RAM_WE = 3'h1;
    end 8'h25 : begin
      Data_RAM_WR_Addr = 6'hc;
      Data_RAM_WE = 3'h2;
    end 8'h26 : begin
      Data_RAM_WR_Addr = 6'hc;
      Data_RAM_WE = 3'h4;
    end 8'h27 : begin
      Data_RAM_WR_Addr = 6'hd;
      Data_RAM_WE = 3'h1;
    end 8'h28 : begin
      Data_RAM_WR_Addr = 6'hd;
      Data_RAM_WE = 3'h2;
    end 8'h29 : begin
      Data_RAM_WR_Addr = 6'hd;
      Data_RAM_WE = 3'h4;
    end 8'h2a : begin
      Data_RAM_WR_Addr = 6'he;
      Data_RAM_WE = 3'h1;
    end 8'h2b : begin
      Data_RAM_WR_Addr = 6'he;
      Data_RAM_WE = 3'h2;
    end 8'h2c : begin
      Data_RAM_WR_Addr = 6'he;
      Data_RAM_WE = 3'h4;
    end 8'h2d : begin
      Data_RAM_WR_Addr = 6'hf;
      Data_RAM_WE = 3'h1;
    end 8'h2e : begin
      Data_RAM_WR_Addr = 6'hf;
      Data_RAM_WE = 3'h2;
    end 8'h2f : begin
      Data_RAM_WR_Addr = 6'hf;
      Data_RAM_WE = 3'h4;
    end 8'h30 : begin
      Data_RAM_WR_Addr = 6'h10;
      Data_RAM_WE = 3'h1;
    end 8'h31 : begin
      Data_RAM_WR_Addr = 6'h10;
      Data_RAM_WE = 3'h2;
    end 8'h32 : begin
      Data_RAM_WR_Addr = 6'h10;
      Data_RAM_WE = 3'h4;
    end 8'h33 : begin
      Data_RAM_WR_Addr = 6'h11;
      Data_RAM_WE = 3'h1;
    end 8'h34 : begin
      Data_RAM_WR_Addr = 6'h11;
      Data_RAM_WE = 3'h2;
    end 8'h35 : begin
      Data_RAM_WR_Addr = 6'h11;
      Data_RAM_WE = 3'h4;
    end 8'h36 : begin
      Data_RAM_WR_Addr = 6'h12;
      Data_RAM_WE = 3'h1;
    end 8'h37 : begin
      Data_RAM_WR_Addr = 6'h12;
      Data_RAM_WE = 3'h2;
    end 8'h38 : begin
      Data_RAM_WR_Addr = 6'h12;
      Data_RAM_WE = 3'h4;
    end 8'h39 : begin
      Data_RAM_WR_Addr = 6'h13;
      Data_RAM_WE = 3'h1;
    end 8'h3a : begin
      Data_RAM_WR_Addr = 6'h13;
      Data_RAM_WE = 3'h2;
    end 8'h3b : begin
      Data_RAM_WR_Addr = 6'h13;
      Data_RAM_WE = 3'h4;
    end 8'h3c : begin
      Data_RAM_WR_Addr = 6'h14;
      Data_RAM_WE = 3'h1;
    end 8'h3d : begin
      Data_RAM_WR_Addr = 6'h14;
      Data_RAM_WE = 3'h2;
    end 8'h3e : begin
      Data_RAM_WR_Addr = 6'h14;
      Data_RAM_WE = 3'h4;
    end 8'h3f : begin
      Data_RAM_WR_Addr = 6'h15;
      Data_RAM_WE = 3'h1;
    end 8'h40 : begin
      Data_RAM_WR_Addr = 6'h15;
      Data_RAM_WE = 3'h2;
    end 8'h41 : begin
      Data_RAM_WR_Addr = 6'h15;
      Data_RAM_WE = 3'h4;
    end 8'h42 : begin
      Data_RAM_WR_Addr = 6'h16;
      Data_RAM_WE = 3'h1;
    end 8'h43 : begin
      Data_RAM_WR_Addr = 6'h16;
      Data_RAM_WE = 3'h2;
    end 8'h44 : begin
      Data_RAM_WR_Addr = 6'h16;
      Data_RAM_WE = 3'h4;
    end 8'h45 : begin
      Data_RAM_WR_Addr = 6'h17;
      Data_RAM_WE = 3'h1;
    end 8'h46 : begin
      Data_RAM_WR_Addr = 6'h17;
      Data_RAM_WE = 3'h2;
    end 8'h47 : begin
      Data_RAM_WR_Addr = 6'h17;
      Data_RAM_WE = 3'h4;
    end 8'h48 : begin
      Data_RAM_WR_Addr = 6'h18;
      Data_RAM_WE = 3'h1;
    end 8'h49 : begin
      Data_RAM_WR_Addr = 6'h18;
      Data_RAM_WE = 3'h2;
    end 8'h4a : begin
      Data_RAM_WR_Addr = 6'h18;
      Data_RAM_WE = 3'h4;
    end 8'h4b : begin
      Data_RAM_WR_Addr = 6'h19;
      Data_RAM_WE = 3'h1;
    end 8'h4c : begin
      Data_RAM_WR_Addr = 6'h19;
      Data_RAM_WE = 3'h2;
    end 8'h4d : begin
      Data_RAM_WR_Addr = 6'h19;
      Data_RAM_WE = 3'h4;
    end 8'h4e : begin
      Data_RAM_WR_Addr = 6'h1a;
      Data_RAM_WE = 3'h1;
    end 8'h4f : begin
      Data_RAM_WR_Addr = 6'h1a;
      Data_RAM_WE = 3'h2;
    end 8'h50 : begin
      Data_RAM_WR_Addr = 6'h1a;
      Data_RAM_WE = 3'h4;
    end 8'h51 : begin
      Data_RAM_WR_Addr = 6'h1b;
      Data_RAM_WE = 3'h1;
    end 8'h52 : begin
      Data_RAM_WR_Addr = 6'h1b;
      Data_RAM_WE = 3'h2;
    end 8'h53 : begin
      Data_RAM_WR_Addr = 6'h1b;
      Data_RAM_WE = 3'h4;
    end 8'h54 : begin
      Data_RAM_WR_Addr = 6'h1c;
      Data_RAM_WE = 3'h1;
    end 8'h55 : begin
      Data_RAM_WR_Addr = 6'h1c;
      Data_RAM_WE = 3'h2;
    end 8'h56 : begin
      Data_RAM_WR_Addr = 6'h1c;
      Data_RAM_WE = 3'h4;
    end 8'h57 : begin
      Data_RAM_WR_Addr = 6'h1d;
      Data_RAM_WE = 3'h1;
    end 8'h58 : begin
      Data_RAM_WR_Addr = 6'h1d;
      Data_RAM_WE = 3'h2;
    end 8'h59 : begin
      Data_RAM_WR_Addr = 6'h1d;
      Data_RAM_WE = 3'h4;
    end 8'h5a : begin
      Data_RAM_WR_Addr = 6'h1e;
      Data_RAM_WE = 3'h1;
    end 8'h5b : begin
      Data_RAM_WR_Addr = 6'h1e;
      Data_RAM_WE = 3'h2;
    end 8'h5c : begin
      Data_RAM_WR_Addr = 6'h1e;
      Data_RAM_WE = 3'h4;
    end 8'h5d : begin
      Data_RAM_WR_Addr = 6'h1f;
      Data_RAM_WE = 3'h1;
    end 8'h5e : begin
      Data_RAM_WR_Addr = 6'h1f;
      Data_RAM_WE = 3'h2;
    end 8'h5f : begin
      Data_RAM_WR_Addr = 6'h1f;
      Data_RAM_WE = 3'h4;
    end 8'h60 : begin
      Data_RAM_WR_Addr = 6'h20;
      Data_RAM_WE = 3'h1;
    end 8'h61 : begin
      Data_RAM_WR_Addr = 6'h20;
      Data_RAM_WE = 3'h2;
    end 8'h62 : begin
      Data_RAM_WR_Addr = 6'h20;
      Data_RAM_WE = 3'h4;
    end 8'h63 : begin
      Data_RAM_WR_Addr = 6'h21;
      Data_RAM_WE = 3'h1;
    end 8'h64 : begin
      Data_RAM_WR_Addr = 6'h21;
      Data_RAM_WE = 3'h2;
    end 8'h65 : begin
      Data_RAM_WR_Addr = 6'h21;
      Data_RAM_WE = 3'h4;
    end 8'h66 : begin
      Data_RAM_WR_Addr = 6'h22;
      Data_RAM_WE = 3'h1;
    end 8'h67 : begin
      Data_RAM_WR_Addr = 6'h22;
      Data_RAM_WE = 3'h2;
    end 8'h68 : begin
      Data_RAM_WR_Addr = 6'h22;
      Data_RAM_WE = 3'h4;
    end 8'h69 : begin
      Data_RAM_WR_Addr = 6'h23;
      Data_RAM_WE = 3'h1;
    end 8'h6a : begin
      Data_RAM_WR_Addr = 6'h23;
      Data_RAM_WE = 3'h2;
    end 8'h6b : begin
      Data_RAM_WR_Addr = 6'h23;
      Data_RAM_WE = 3'h4;
    end 8'h6c : begin
      Data_RAM_WR_Addr = 6'h24;
      Data_RAM_WE = 3'h1;
    end 8'h6d : begin
      Data_RAM_WR_Addr = 6'h24;
      Data_RAM_WE = 3'h2;
    end 8'h6e : begin
      Data_RAM_WR_Addr = 6'h24;
      Data_RAM_WE = 3'h4;
    end 8'h6f : begin
      Data_RAM_WR_Addr = 6'h25;
      Data_RAM_WE = 3'h1;
    end 8'h70 : begin
      Data_RAM_WR_Addr = 6'h25;
      Data_RAM_WE = 3'h2;
    end 8'h71 : begin
      Data_RAM_WR_Addr = 6'h25;
      Data_RAM_WE = 3'h4;
    end 8'h72 : begin
      Data_RAM_WR_Addr = 6'h26;
      Data_RAM_WE = 3'h1;
    end 8'h73 : begin
      Data_RAM_WR_Addr = 6'h26;
      Data_RAM_WE = 3'h2;
    end 8'h74 : begin
      Data_RAM_WR_Addr = 6'h26;
      Data_RAM_WE = 3'h4;
    end 8'h75 : begin
      Data_RAM_WR_Addr = 6'h27;
      Data_RAM_WE = 3'h1;
    end 8'h76 : begin
      Data_RAM_WR_Addr = 6'h27;
      Data_RAM_WE = 3'h2;
    end 8'h77 : begin
      Data_RAM_WR_Addr = 6'h27;
      Data_RAM_WE = 3'h4;
    end 8'h78 : begin
      Data_RAM_WR_Addr = 6'h28;
      Data_RAM_WE = 3'h1;
    end 8'h79 : begin
      Data_RAM_WR_Addr = 6'h28;
      Data_RAM_WE = 3'h2;
    end 8'h7a : begin
      Data_RAM_WR_Addr = 6'h28;
      Data_RAM_WE = 3'h4;
    end 8'h7b : begin
      Data_RAM_WR_Addr = 6'h29;
      Data_RAM_WE = 3'h1;
    end 8'h7c : begin
      Data_RAM_WR_Addr = 6'h29;
      Data_RAM_WE = 3'h2;
    end 8'h7d : begin
      Data_RAM_WR_Addr = 6'h29;
      Data_RAM_WE = 3'h4;
    end 8'h7e : begin
      Data_RAM_WR_Addr = 6'h2a;
      Data_RAM_WE = 3'h1;
    end 8'h7f : begin
      Data_RAM_WR_Addr = 6'h2a;
      Data_RAM_WE = 3'h2;
    end 8'h80 : begin
      Data_RAM_WR_Addr = 6'h2a;
      Data_RAM_WE = 3'h4;
    end 8'h81 : begin
      Data_RAM_WR_Addr = 6'h2b;
      Data_RAM_WE = 3'h1;
    end 8'h82 : begin
      Data_RAM_WR_Addr = 6'h2b;
      Data_RAM_WE = 3'h2;
    end 8'h83 : begin
      Data_RAM_WR_Addr = 6'h2b;
      Data_RAM_WE = 3'h4;
    end 8'h84 : begin
      Data_RAM_WR_Addr = 6'h2c;
      Data_RAM_WE = 3'h1;
    end 8'h85 : begin
      Data_RAM_WR_Addr = 6'h2c;
      Data_RAM_WE = 3'h2;
    end 8'h86 : begin
      Data_RAM_WR_Addr = 6'h2c;
      Data_RAM_WE = 3'h4;
    end 8'h87 : begin
      Data_RAM_WR_Addr = 6'h2d;
      Data_RAM_WE = 3'h1;
    end 8'h88 : begin
      Data_RAM_WR_Addr = 6'h2d;
      Data_RAM_WE = 3'h2;
    end 8'h89 : begin
      Data_RAM_WR_Addr = 6'h2d;
      Data_RAM_WE = 3'h4;
    end 8'h8a : begin
      Data_RAM_WR_Addr = 6'h2e;
      Data_RAM_WE = 3'h1;
    end 8'h8b : begin
      Data_RAM_WR_Addr = 6'h2e;
      Data_RAM_WE = 3'h2;
    end 8'h8c : begin
      Data_RAM_WR_Addr = 6'h2e;
      Data_RAM_WE = 3'h4;
    end 8'h8d : begin
      Data_RAM_WR_Addr = 6'h2f;
      Data_RAM_WE = 3'h1;
    end 8'h8e : begin
      Data_RAM_WR_Addr = 6'h2f;
      Data_RAM_WE = 3'h2;
    end 8'h8f : begin
      Data_RAM_WR_Addr = 6'h2f;
      Data_RAM_WE = 3'h4;
    end 8'h90 : begin
      Data_RAM_WR_Addr = 6'h30;
      Data_RAM_WE = 3'h1;
    end 8'h91 : begin
      Data_RAM_WR_Addr = 6'h30;
      Data_RAM_WE = 3'h2;
    end 8'h92 : begin
      Data_RAM_WR_Addr = 6'h30;
      Data_RAM_WE = 3'h4;
    end 8'h93 : begin
      Data_RAM_WR_Addr = 6'h31;
      Data_RAM_WE = 3'h1;
    end 8'h94 : begin
      Data_RAM_WR_Addr = 6'h31;
      Data_RAM_WE = 3'h2;
    end 8'h95 : begin
      Data_RAM_WR_Addr = 6'h31;
      Data_RAM_WE = 3'h4;
    end default : begin
      Data_RAM_WE = 3'h0;
      Data_RAM_WR_Addr = 6'h00;
    end
  endcase
end

//--------------------------------------------------
// READ OUT
//--------------------------------------------------

assign  HRDATA  =   (addr_reg   ==  8'h96)   ?   {4{7'b0,state}}:   (
                    (addr_reg   ==  8'h97)   ?   {4{Num0}}      :   (
                    (addr_reg   ==  8'h98)   ?   {4{Num1}}      :   (
                    (addr_reg   ==  8'h99)   ?   {4{Num2}}      :   (
                    (addr_reg   ==  8'h9a)   ?   {4{Num3}}      :   (
                    (addr_reg   ==  8'h9b)   ?   {4{Num4}}      :   (
                    (addr_reg   ==  8'h9c)   ?   {4{Num5}}      :   (
                    (addr_reg   ==  8'h9d)   ?   {4{Num6}}      :   (
                    (addr_reg   ==  8'h9e)   ?   {4{Num7}}      :   (
                    (addr_reg   ==  8'h9f)   ?   {4{Num8}}      :   (
                    (addr_reg   ==  8'ha0)   ?   {4{Num9}}      :   32'b0))))))))));



endmodule