module transmitter (
    input clk,
    input rstn,
    input start,
    input [6:0] data_in,
    output reg serial_out
);

reg [6:0] intern_data;
wire parity;
reg [3:0] state_machine;

// Paridade a ser enviada
assign parity = ^intern_data;

// 10 Estados!
/*
A máquina funcionará para cada dado a ser enviado um estado. 7 dados. 1 estado para pariedade
1 para começar a transmissão. 1 para idle.
*/
parameter [3:0] S0  = 4'b0000, // Idle
                S1  = 4'b0001, // Começa Transmissão
                S2  = 4'b0010, // Enviar bit 0
                S3  = 4'b0011, // Enviar bit 1
                S4  = 4'b0100, // Enviar bit 2
                S5  = 4'b0101, // Enviar bit 3
                S6  = 4'b0110, // Enviar bit 4
                S7  = 4'b0111, // Enviar bit 5
                S8  = 4'b1000, // Enviar bit 6
                S9  = 4'b1001, // Enviar bit Paridade

always @(posedge clk, negedge rstn) begin
    if (~rstn) begin
        intern_data <= 7'bxxxxxxx;
        serial_out <= 1'b1;
        state_machine <= S0;
    end
    else begin
        case (state_machine)
            S0: begin
                serial_out <= 1;
                if (start) begin
                  intern_data <= data_in;
                  state_machine <= S1;
                end  
                else begin
                  state_machine <= S0;
                end
            end
            S1: begin
                serial_out <= 0;
                state_machine <= S2;
            end
            S2: begin
                serial_out <= intern_data[0];
                state_machine <= S3;
            end
            S3: begin
                serial_out <= intern_data[1];
                state_machine <= S4;
            end
            S4: begin
                serial_out <= intern_data[2];
                state_machine <= S5;
            end
            S5: begin
                serial_out <= intern_data[3];
                state_machine <= S6;
            end
            S6: begin
                serial_out <= intern_data[4];
                state_machine <= S7;
            end
            S7: begin
                serial_out <= intern_data[5];
                state_machine <= S8;
            end
            S8: begin
                serial_out <= intern_data[6];
                state_machine <= S9;
            end
            S9: begin
                serial_out <= parity;
                state_machine <= S0;
            end
            default: state_machine <= S0;
        endcase
    end
end

endmodule