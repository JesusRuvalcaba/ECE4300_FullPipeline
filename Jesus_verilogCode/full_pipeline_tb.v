//mips_pipeline_tb.v

module full_pipeline_tb;
    reg clk;
    reg reset;

    full_pipeline uut (
        .clk(clk),
        .reset(reset)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns clock period
    end

    initial begin
   
        reset = 1;
         
   #10     
        reset = 0;
   
   #700
         $finish;
    end
    
    
endmodule