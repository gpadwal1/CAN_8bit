module tb_can_controller_8bit;
    reg clk, reset, start;
    reg [7:0] my_id, bus_id, tx_data;
    wire tx_line;
    wire rx_line;
    wire [7:0] rx_id, rx_data, rx_crc;
    wire tx_done, rx_done, win;

    // DUT instantiation
    can_controller_8bit uut (
        .clk(clk),
        .reset(reset),
        .start(start),
        .my_id(my_id),
        .bus_id(bus_id),
        .tx_data(tx_data),
        .rx_line(tx_line),  // loopback for simulation
        .tx_line(tx_line),
        .rx_id(rx_id),
        .rx_data(rx_data),
        .rx_crc(rx_crc),
        .tx_done(tx_done),
        .rx_done(rx_done),
        .win(win)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        $dumpfile("can_controller.vcd");
        $dumpvars(0, tb_can_controller_8bit);

        clk = 0;
        reset = 1;
        start = 0;
        my_id = 8'h02;   // Lower ID (wins arbitration)
    	bus_id = 8'h05;  // Higher bus ID
    	tx_data = 8'h0A; // Simple test data

        #10 reset = 0;
        #10 start = 1;
        #10 start = 0;

        wait (tx_done);
        wait (rx_done);

        $display("Received ID: %h, Data: %h, CRC: %h", rx_id, rx_data, rx_crc);
        #50;
        $finish;
    end
endmodule

