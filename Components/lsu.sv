`default_nettype none
`timescale 1ns/1ns

// LOAD-STORE UNIT
// > Handles asynchronous memory load and store operations and waits for response
// > Each thread in each core has it's own LSU
// > LDR, STR instructions are executed here
module lsu (
    input wire clk,
    input wire reset,
    input wire enable, // If current block has less threads then block size, some LSUs will be inactive

    // Memory Control Signals
    input wire decoded_mem_read_enable,
    input wire decoded_mem_write_enable,

    // Registers
    input wire [7:0] rs,
    input wire [7:0] rt,

    // Data Memory
    output reg mem_read_valid,
    output reg [7:0] mem_read_address,
    input wire mem_read_ready,
    input wire [7:0] mem_read_data,
    output reg mem_write_valid,
    output reg [7:0] mem_write_address,
    output reg [7:0] mem_write_data,
    input wire mem_write_ready,

    // LSU Outputs
	 output reg lsu_waiting,
    output reg [7:0] lsu_out
);
    localparam IDLE = 2'b00, REQUESTING = 2'b01, WAITING = 2'b10, DONE = 2'b11;
	 reg [1:0] lsu_state;

    always @(posedge clk) begin
        if (reset) begin
				lsu_waiting <= 0;
            lsu_state <= IDLE;
            lsu_out <= 0;
            mem_read_valid <= 0;
            mem_read_address <= 0;
            mem_write_valid <= 0;
            mem_write_address <= 0;
            mem_write_data <= 0;
        end else if (enable) begin
            // If memory read enable is triggered (LDR instruction)
            if (decoded_mem_read_enable) begin 
                case (lsu_state)
                    IDLE: begin
                        lsu_state <= REQUESTING;
								lsu_waiting <= 0;
                    end
                    REQUESTING: begin 
                        mem_read_valid <= 1;
                        mem_read_address <= rs;
                        lsu_state <= WAITING;
								lsu_waiting <= 1;
                    end
                    WAITING: begin
                        if (mem_read_ready == 1) begin
                            mem_read_valid <= 0;
                            lsu_out <= mem_read_data;
                            lsu_state <= DONE;
									 lsu_waiting <= 1;
                        end
                    end
                    DONE: begin 
                        lsu_state <= IDLE;
								lsu_waiting <= 0;
                    end
                endcase
            end

            // If memory write enable is triggered (STR instruction)
            if (decoded_mem_write_enable) begin 
                case (lsu_state)
                    IDLE: begin
                        lsu_state <= REQUESTING;
								lsu_waiting <= 0;
                    end
                    REQUESTING: begin 
                        mem_write_valid <= 1;
                        mem_write_address <= rs;
                        mem_write_data <= rt;
                        lsu_state <= WAITING;
								lsu_waiting <= 1;
                    end
                    WAITING: begin
                        if (mem_write_ready) begin
                            mem_write_valid <= 0;
                            lsu_state <= DONE;
									 lsu_waiting <= 1;
                        end
                    end
                    DONE: begin 
								lsu_state <= IDLE;
								lsu_waiting <= 0;
                    end
                endcase
            end
			end else begin
				lsu_waiting <= 0;
			end
    end
endmodule
