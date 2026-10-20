module FSM (fsm_Out, clk, rst_n, in);
output reg fsm_Out;
input clk, rst_n, in;

parameter [1:0] S0 = 2'b00,
               S1 = 2'b01,
               S2 = 2'b10;

reg [1:0] state, next;

always @(posedge clk or negedge rst_n)
    if(!rst_n) 
        state <= S0;
    else
        state <= next;

always @(state or in)
    begin
      next = 2'bx;
      fsm_Out  = 1'b0;
      case(state)
        S0: begin
                fsm_Out = 1'b1;
                if (in == 1)    next = S1;
                else            next = S0;          
            end
        S1: begin
                if(in == 1) next = S2;
                else        next = S1;
            end
        S2: begin
                if(in == 1) next = S0;
                else        next = S2;
            end
      endcase
    end
endmodule