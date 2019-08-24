module CAMERA_Capture(
    input   wire            HCLK,
    input   wire            PCLK,
    input   wire            HRESETn,
    input   wire            DATA_VALID,
    output  wire            DATA_READY,
    input   wire    [12:0]  DualRAM_RADDR,
    output  wire    [31:0]  DualRAM_RDATA,
    input   wire    [7:0]   Camera_idata,
    input   wire            VSYNC,
    input   wire            HREF
);

// RAM

reg [12:0] addra;
wire wea;
wire [31:0] dina;

Block_DualPort_RAM DuRAM(
    .clka(PCLK),
    .clkb(HCLK),
    .addrb(DualRAM_RADDR),
    .addra(addra),
    .dina(dina),
    .wea(wea),
    .doutb(DualRAM_RDATA)
);

// FSM

localparam idle = 2'b00;
localparam sdb  = 2'b01;
localparam cap  = 2'b10;
localparam rele = 2'b11;

reg [1:0] state;//0:idle 1:capture
reg [1:0] state_nxt;

reg syn_vsync;
always@(posedge PCLK or negedge HRESETn) begin
    if(~HRESETn) syn_vsync <= 1'b0;
    else syn_vsync <= VSYNC;
end

reg syn_valid;
always@(posedge PCLK or negedge HRESETn) begin
    if(~HRESETn) syn_valid <= 1'b0;
    else syn_valid <= DATA_VALID;
end

always@(*) begin
    case(state)
    idle: begin    
        if(syn_valid & syn_vsync) 
            state_nxt = sdb;
        else 
            state_nxt = state;
    end sdb: begin
        if(~syn_vsync)
            state_nxt = cap;
        else
            state_nxt = state;
    end cap: begin
        if(syn_vsync) 
            state_nxt = rele;
        else
            state_nxt = state;
    end rele: begin
        if(~syn_valid)
            state_nxt = idle;
        else
            state_nxt = state;
    end
    endcase
end

always@(posedge HCLK or negedge HRESETn) begin
    if(~HRESETn) state <= idle;
    else state <= state_nxt;
end

// COLOR BINARY

wire D_binary;
assign D_binary = Camera_idata[4:0] > 5'd10;

// BYTE STATE

wire capture_en;
assign capture_en = state[1] & (~VSYNC) & HREF & (~state[0]);

reg byte_state;
always@(posedge PCLK or negedge HRESETn) begin
    if(~HRESETn) 
        byte_state <= 1'b0;
    else if(capture_en) 
        byte_state <= ~byte_state;
    else 
        byte_state <= 1'b0;
end

// SHIFT REG

reg [31:0] shift_reg;
wire [31:0] shift_reg_nxt;

assign shift_reg_nxt = byte_state ? {D_binary,shift_reg[31:1]} : shift_reg;
always@(posedge PCLK or negedge HRESETn) begin
    if(~HRESETn)
        shift_reg <= 32'b0;
    else 
        shift_reg <= shift_reg_nxt;
end

assign dina = shift_reg;

// PIXEL COUNTER

reg [4:0] pixel_cnt;
wire [4:0] pixel_cnt_nxt;

assign pixel_cnt_nxt = (~capture_en)  ?   5'b0 :  (
                       (byte_state)     ?   pixel_cnt + 1'b1 : pixel_cnt);
always@(posedge PCLK or negedge HRESETn) begin
    if(~HRESETn)
        pixel_cnt <= 5'b0;
    else 
        pixel_cnt <= pixel_cnt_nxt;
end


// WEA

assign wea = (pixel_cnt == 5'h1f) & (~byte_state);

// ADDRA

reg [12:0] addra_reg;
always@(posedge PCLK or negedge HRESETn) begin
    if(~HRESETn) begin
        addra       <= 13'b0;
    end else if((~state[0]) & state[1] & (~syn_vsync)) begin   
        if(wea)
            addra           <= addra + 1'b1;
    end else begin
        addra               <= 13'b0;
    end
end

// CAP EXIST

assign DATA_READY = state[1] & state[0];

endmodule