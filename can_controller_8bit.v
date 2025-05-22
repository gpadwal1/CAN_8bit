module can_controller_8bit (
    input clk,                 // System clock
    input reset,               // System reset
    input start,               // Start transmission
    input [7:0] my_id,         // This node's arbitration ID
    input [7:0] bus_id,        // Current ID on the bus for arbitration
    input [7:0] tx_data,       // Data to transmit
    input rx_line,             // Serial input from bus (receive line)
    output tx_line,            // Serial output to bus (transmit line)
    output [7:0] rx_id,        // Received ID
    output [7:0] rx_data,      // Received data
    output [7:0] rx_crc,       // Received CRC
    output [7:0] tx_crc,       // Transmitted CRC (added!)
    output tx_done,            // Transmission done flag
    output rx_done,            // Reception done flag
    output win                 // Arbitration result: 1 = won, 0 = lost
);
    // Arbitration
    arbitration arb(
        .my_id(my_id),
        .bus_id(bus_id),
        .win(win)
    );

    // Frame builder
    wire [23:0] frame_out;
    wire [7:0] crc_out; // internal wire to hold crc

    frame_builder_8bit fb(
        .clk(clk),
        .reset(reset),
        .id(my_id),
        .data(tx_data),
        .frame_out(frame_out),
        .crc_out(crc_out) // connect crc_out
    );

    // Pass to top-level output
    assign tx_crc = crc_out;

    // Transmitter
    tx_8bit tx(
        .clk(clk),
        .reset(reset),
        .start(start),
        .frame(frame_out),
        .tx_line(tx_line),
        .done(tx_done)
    );

    // Receiver
    rx_8bit rx(
        .clk(clk),
        .reset(reset),
        .rx_line(rx_line),
        .rx_id(rx_id),       
        .rx_data(rx_data),
        .rx_crc(rx_crc),
        .done(rx_done)
    );
endmodule


