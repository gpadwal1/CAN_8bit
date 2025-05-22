module crc8(
    input [15:0] data_in, // 8-bit ID + 8-bit data
    output reg [7:0] crc
);
    integer i;
    reg [7:0] c;

    always @(*) begin
        c = 8'b0;
        for (i = 15; i >= 0; i = i - 1)
            c = {c[6:0], data_in[i]} ^ (c[7] ? 8'b10000011 : 8'b0); // Polynomial: x^8 + x + 1
        crc = c;
    end
endmodule
