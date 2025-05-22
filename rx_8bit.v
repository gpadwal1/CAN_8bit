module rx_8bit (
    input clk,
    input reset,
    input rx_line,
    output reg [7:0] rx_id,
    output reg [7:0] rx_data,
    output reg [7:0] rx_crc,
    output reg done
);

    reg [4:0] bit_cnt;           // Count up to 24 bits
    reg [23:0] shift_reg;        // To store the incoming bits
    reg receiving;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        bit_cnt <= 0;
        shift_reg <= 0;
        rx_id <= 0;
        rx_data <= 0;
        rx_crc <= 0;
        done <= 0;
        receiving <= 0;
    end else begin
        if (!receiving && rx_line == 0) begin
            receiving <= 1;
            bit_cnt <= 0;
            shift_reg <= 0;
            done <= 0;  // Clear done at frame start
        end else if (receiving) begin
            shift_reg <= {shift_reg[22:0], rx_line};
            bit_cnt <= bit_cnt + 1;

            if (bit_cnt == 23) begin
                rx_id <= shift_reg[23:16];
                rx_data <= shift_reg[15:8];
                rx_crc <= shift_reg[7:0];
                done <= 1;  // pulse done for one clock
                receiving <= 0;
            end else begin
                done <= 0;
            end
        end
    end
end
endmodule
    

