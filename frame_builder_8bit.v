module frame_builder_8bit (
    input clk,
    input reset,
    input [7:0] id,
    input [7:0] data,
    output reg [23:0] frame_out,
    output [7:0] crc_out
);
    wire [7:0] crc;

    // Instantiate CRC generator
    crc8 crc_gen (.data_in({id, data}),.crc(crc));
    // Assign crc to crc_out for top-level visibility
    assign crc_out = crc;
    // Build the frame: [ID][DATA][CRC]
    always @(posedge clk or posedge reset) begin
        if (reset)
            frame_out <= 24'b0;
        else
            frame_out <= {id, data, crc};
    end
endmodule

