`timescale 1ns/1ps

/*
test case # 1
0    1    2    1    2    1    2  |* 1 *|
0    0    1    2    1    2    1  |* 2 *|
0    0    0    1    2    1    2  |* 1 *|


test case # 2
0    1    2    3    4    3    2    3    4    3  |* 4 *|
0    0    1    2    3    4    3    2    3    4  |* 3 *|
0    0    0    1    2    3    4    3    2    3  |* 4 *|
0    0    0    0    1    2    2    4    4    2  |* 2 *|
0    0    0    0    0    1    1    1    1    1  |* 1 *|

2023.05.10 brute force solution
2023.05.29 add input register move logic to negedge clk_in

*/ 

module test_module #( 
    parameter DATA_W = 8 
)(
    input  logic                        clk_in, 
    input  logic                        reset_in,       // sync reset active "1"
    input  logic     [(DATA_W - 1) : 0] data_in, 
    
    output logic     [(DATA_W - 1) : 0] out_0, 
    output logic                        out_valid_0, 
    output logic     [(DATA_W - 1) : 0] out_1, 
    output logic                        out_valid_1, 
    output logic     [(DATA_W - 1) : 0] out_2, 
    output logic                        out_valid_2, 
    output logic     [(DATA_W - 1) : 0] out_3, 
    output logic                        out_valid_3 
); 

logic pl0;
logic [(DATA_W - 1) : 0] din_rg;

always_ff @(negedge clk_in)
    if(reset_in)    din_rg <= 'h0;
    else            din_rg <= data_in;

// out_0
always_ff @(negedge clk_in) begin
    if(reset_in) begin
        out_valid_0     <= 1'b0;
        out_0           <= 'h0;
        pl0             <= 1'b0;
    end 
    else begin
        out_valid_0     <= pl0;
        pl0             <= 1'b1;
        out_0           <= din_rg;
    end    
end

// out_1
always_ff @(negedge clk_in) begin
    if(reset_in) begin
        out_valid_1     <= 1'b0;
        out_1           <= 'h0;
    end 
    else if(out_valid_0
            & (out_0 != din_rg))begin
        out_valid_1     <= 1'b1;
        out_1           <= out_0;
    end    
end

// out_2
always_ff @(negedge clk_in) begin
    if(reset_in) begin
        out_valid_2     <= 1'b0;
        out_2           <= 'h0;
    end 
    else if(out_valid_1 
            & (out_0 != din_rg)
            & (out_1 != din_rg))begin
        out_valid_2     <= 1'b1;
        out_2           <= out_1;
    end    
end

// out_3
always_ff @(negedge clk_in) begin
    if(reset_in) begin
        out_valid_3     <= 1'b0;
        out_3           <= 'h0;
    end 
    else if(out_valid_2 
            & (out_0 != din_rg) 
            & (out_1 != din_rg) 
            & (out_2 != din_rg))begin
        out_valid_3     <= 1'b1;
        out_3           <= out_2;
    end    
end

endmodule
