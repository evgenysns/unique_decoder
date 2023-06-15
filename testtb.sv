`timescale 1ns/1ps

module testtb;

parameter real clk_freq_hz = 50_000_000.0;
parameter real half_clk = (500_000_000 / clk_freq_hz);

reg CLK, RST;
reg [7:0]data_in;
integer cnt;

logic [7:0]tst01[6:0];
logic [7:0]tst02[9:0];


//===================================================================
// init
//===================================================================
initial begin
    cnt     = 0;

    CLK     = 1'b0;
    RST  = 1'b1;
    data_in = 'hx;
    
    tst01[0]<=8'h01; 
    tst01[1]<=8'h02; 
    tst01[2]<=8'h01; 
    tst01[3]<=8'h02; 
    tst01[4]<=8'h01; 
    tst01[5]<=8'h02; 
    tst01[6]<=8'h01;

    tst02[0]<=8'h01; 
    tst02[1]<=8'h02; 
    tst02[2]<=8'h03; 
    tst02[3]<=8'h04; 
    tst02[4]<=8'h03; 
    tst02[5]<=8'h02; 
    tst02[6]<=8'h03; 
    tst02[7]<=8'h04; 
    tst02[8]<=8'h03; 
    tst02[9]<=8'h04;

end

//===================================================================
// generate clock
//===================================================================
always #(half_clk)  CLK <= ~CLK;

//===================================================================
// test code
//===================================================================
initial begin
    
    $display("//===================================");
    $display($time, " Simulation start");
    
    init_module;
    repeat(10) @(posedge CLK);
    data_in = tst01[0];
    reset_module;
    @(posedge CLK);
    
    test01;
    repeat(10) @(posedge CLK);
    
    
    RST = 1'b1;
    @(posedge CLK);
    RST = 1'b0;
    data_in = tst02[0];
    test02;
    repeat(10) @(posedge CLK);
    reset_module;
    repeat(10) @(posedge CLK);
   
    $display($time, " Simulation done");
    $display("//===================================");
    $stop;
    
end
//===================================================================
// test module
//===================================================================

test_module #( 
    .DATA_W     (8)
)
test_module_inst0(
    .clk_in             ( CLK               ), 
    .reset_in           ( RST            ), 
    .data_in            ( data_in           ), 
    
    .out_0              (), 
    .out_valid_0        (), 
    .out_1              (), 
    .out_valid_1        (), 
    .out_2              (), 
    .out_valid_2        (), 
    .out_3              (), 
    .out_valid_3        ()
); 



//===================================================================
// task description
//===================================================================
task init_module;
begin
    RST = 1'b1;    
end
endtask

task reset_module;
begin
    cnt = 'h0;
    RST = 1'b1;
    ///#777
    //@(posedge CLK);
    RST = 1'b0;
end
endtask

task test01;
begin
    data_in <= tst01[1];
    cnt<=2;
    repeat(6) begin
        @(posedge CLK);
        data_in <= tst01[cnt];
        cnt<=cnt+1;
    end
    data_in = 'h0;
end
endtask

task test02;
begin
    cnt<='h0;
    data_in <= tst02[0];
    cnt<=1;
    repeat(9) begin
        @(posedge CLK);
        data_in <= tst02[cnt];        
        cnt<=cnt+1;
    end
    data_in = 'h0;
end
endtask


endmodule
