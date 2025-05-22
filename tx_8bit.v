module tx_8bit (
    input clk,
    input reset,
    input start,
    input [23:0] frame,
    output reg tx_line,
    output reg done
);
    reg [4:0] bit_cnt;
    reg [23:0] shift_reg;
    reg transmitting;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            bit_cnt <= 0;
            tx_line <= 1;
            shift_reg <= 0;
            transmitting <= 0;
            done <= 0;
        end else if (start && !transmitting) begin
            shift_reg <= frame;
            bit_cnt <= 0;
            transmitting <= 1;
            done <= 0;  // Clear done when new frame starts
        end else if (transmitting) begin
            tx_line <= shift_reg[23];
            shift_reg <= {shift_reg[22:0], 1'b0};
            bit_cnt <= bit_cnt + 1;

            if (bit_cnt == 23) begin
                transmitting <= 0;
                done <= 1;  // Keep done high
            end
        end
    end
endmodule

