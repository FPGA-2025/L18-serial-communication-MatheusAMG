module receiver (
    input clk,
    input rstn,
    output ready,
    output [6:0] data_out,
    output parity_ok_n,
    input serial_in
);

reg [7:0] dados_internos;
reg [3:0] state_machine;
reg ready_interno;

// Maquina de Estados
parameter [3:0] S0  = 4'b0000, // Idle
                S1  = 4'b0001, // Recebe bit 6
                S2  = 4'b0010, // Recebe bit 5
                S3  = 4'b0011, // Recebe bit 4
                S4  = 4'b0100, // Recebe bit 3
                S5  = 4'b0101, // Recebe bit 2
                S6  = 4'b0110, // Recebe bit 1
                S7  = 4'b0111, // Recebe bit 0
                S8  = 4'b1000; // Recebe bit paridade
                // S9  = 4'b1001; // Coloca mensagem da saida

assign parity_ok_n = ^dados_internos;
assign data_out = dados_internos[6:0];
assign ready = ready_interno;

always @(posedge clk, negedge rstn)begin
    if(~rstn) begin
        ready_interno <= 0;
        state_machine <= S0;
    end
    else begin
        case (state_machine)
            S0: begin
                ready_interno <= 0;
                if (~serial_in) state_machine <= S1;
                else state_machine <= S0;
            end 
            S1: begin   // Receber bit 0
                ready_interno <= 0;
                dados_internos[0] <= serial_in;
                state_machine <= S2;
            end 
            S2: begin   // Receber bit 1
                ready_interno <= 0;
                dados_internos[1] <= serial_in;
                state_machine <= S3;
            end 
            S3: begin   // Receber bit 2
                ready_interno <= 0;
                dados_internos[2] <= serial_in;
                state_machine <= S4;
            end 
            S4: begin   // Receber bit 3
                ready_interno <= 0;
                dados_internos[3] <= serial_in;
                state_machine <= S5;
            end 
            S5: begin   // Receber bit 4
                ready_interno <= 0;
                dados_internos[4] <= serial_in;
                state_machine <= S6;
            end  
            S6: begin   // Receber bit 5
                ready_interno <= 0;
                dados_internos[5] <= serial_in;
                state_machine <= S7;
            end 
            S7: begin   // Receber bit 6
                ready_interno <= 0;
                dados_internos[6] <= serial_in;
                state_machine <= S8;
            end 
            S8: begin   // Receber bit de paridade
                ready_interno <= 1;
                dados_internos[7] <= serial_in;
                state_machine <= S0;
            end 
            // S8: begin   // Receber bit de paridade
            //     ready_interno <= 0;
            //     dados_internos[7] <= serial_in;
            //     state_machine <= S9;
            // end 
            // S9: begin
            //     ready_interno <= 1;
            //     state_machine <= S0;
            // end 
            default: state_machine <= 0; 
        endcase
    end
end

endmodule