module Control (
    opcode,
    Reg2Loc, ALUSrc, MemtoReg, RegWrite,
    MemRead, MemWrite, Branch, ALUOp1, ALUOp0
);

    input [10:0] opcode;
    output Reg2Loc, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp1, ALUOp0;
    reg [8:0] ext;

    assign {Reg2Loc, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp1, ALUOp0} = ext;
     

    always @ (opcode) begin
    
        casex(opcode)
            11'b1xx0101x000: ext = 9'b000100010;
            11'b11111000010: ext = 9'b011110000;
            11'b11111000000: ext = 9'b110001000;
            11'b10110100xxx: ext = 9'b100000101;
            11'b0          : ext = 9'b0;
        endcase

    end

endmodule
