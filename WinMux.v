module WinMux (
    input   wire    [95:0]  LineIn0,   
    input   wire    [95:0]  LineIn1, 
    input   wire    [95:0]  LineIn2,
    input   wire    [3:0]   Sel,
    input   wire            Zero,
    output  wire    [23:0]  LineOut0,
    output  wire    [23:0]  LineOut1,
    output  wire    [23:0]  LineOut2    
);

reg    [23:0]  LineOut0_reg;
reg    [23:0]  LineOut1_reg;
reg    [23:0]  LineOut2_reg;

always@(*) begin
    case(Sel)
        4'h0 :begin
            LineOut0_reg    =   {LineIn0[15:0],8'b0};
            LineOut1_reg    =   {LineIn1[15:0],8'b0};
            LineOut2_reg    =   Zero    ?   24'b0   :   {LineIn2[15:0],8'b0};
        end 4'h1 :begin
            LineOut0_reg    =   LineIn0[23:0];
            LineOut1_reg    =   LineIn1[23:0];  
            LineOut2_reg    =   Zero    ?   24'b0   :   LineIn2[23:0]; 
        end 4'h2 :begin
            LineOut0_reg    =   LineIn0[31:8];
            LineOut1_reg    =   LineIn1[31:8];  
            LineOut2_reg    =   Zero    ?   24'b0   :   LineIn2[31:8];   
        end 4'h3 :begin
            LineOut0_reg    =   LineIn0[39:16];
            LineOut1_reg    =   LineIn1[39:16];  
            LineOut2_reg    =   Zero    ?   24'b0   :   LineIn2[39:16];  
        end 4'h4 :begin
            LineOut0_reg    =   LineIn0[47:24];
            LineOut1_reg    =   LineIn1[47:24];  
            LineOut2_reg    =   Zero    ?   24'b0   :   LineIn2[47:24];  
        end 4'h5 :begin
            LineOut0_reg    =   LineIn0[55:32];
            LineOut1_reg    =   LineIn1[55:32];  
            LineOut2_reg    =   Zero    ?   24'b0   :   LineIn2[55:32];  
        end 4'h6 :begin
            LineOut0_reg    =   LineIn0[63:40];
            LineOut1_reg    =   LineIn1[63:40];  
            LineOut2_reg    =   Zero    ?   24'b0   :   LineIn2[63:40];    
        end 4'h7 :begin
            LineOut0_reg    =   LineIn0[71:48];
            LineOut1_reg    =   LineIn1[71:48];  
            LineOut2_reg    =   Zero    ?   24'b0   :   LineIn2[71:48];   
        end 4'h8 :begin
            LineOut0_reg    =   LineIn0[79:56];
            LineOut1_reg    =   LineIn1[79:56];  
            LineOut2_reg    =   Zero    ?   24'b0   :   LineIn2[79:56];    
        end 4'h9 :begin
            LineOut0_reg    =   LineIn0[87:64];
            LineOut1_reg    =   LineIn1[87:64];  
            LineOut2_reg    =   Zero    ?   24'b0   :   LineIn2[87:64];   
        end 4'ha :begin
            LineOut0_reg    =   LineIn0[95:72];
            LineOut1_reg    =   LineIn1[95:72];  
            LineOut2_reg    =   Zero    ?   24'b0   :   LineIn2[95:72];   
        end 4'hb :begin
            LineOut0_reg    =   {8'b0,LineIn0[95:80]};
            LineOut1_reg    =   {8'b0,LineIn1[95:80]};  
            LineOut2_reg    =   Zero    ?   24'b0   :   {8'b0,LineIn2[95:80]};   
        end default :begin
            LineOut0_reg    =   24'b0;
            LineOut1_reg    =   24'b0; 
            LineOut2_reg    =   24'b0;    
        end
    endcase
end

assign      LineOut0    =   LineOut0_reg;
assign      LineOut1    =   LineOut1_reg;
assign      LineOut2    =   LineOut2_reg;

endmodule