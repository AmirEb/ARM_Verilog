`default_nettype none

module CPU ();

    wire clock, zero_alu, reg_to_loc, alu_src, mem_to_reg, reg_write, mem_read, mem_write, branch, alu_op_1, alu_op_0;
    wire [3 : 0] alu_opcode;
    wire [4 : 0] output_register_bank_multiplexer;
    wire [31 : 0] instruction;
    wire [63 : 0] old_pc, new_pc, output_pc_adder, output_data_memory, output_alu, reg_data_1, reg_data_2, output_alu_multiplexer, input_data_register, output_sign_extend, output_shift_unit, output_shift_unit_adder;

    reg pc_reset;

    initial begin
        pc_reset = 1; 
        #100 pc_reset = 0;
    end

    clock clock1(clock);



   

    Register pc_1 (   
        .clock(clock),
        .reset(pc_reset),
        .new_output(new_pc),
        .old_output(old_pc)
    );

    Adder pc_adder (
        .input1(old_pc),
        .input2(64'b100),
        .outputdata(output_pc_adder)
    );

    InstructionMemory instruction_memory (
        .input_address(old_pc), 
        .output_data(instruction)
    );

    multiplexer pc_multiplexer (
        .input1(output_pc_adder),
        .input2(output_shift_unit_adder),
        .select(branch & zero_alu),
        .result(new_pc)
    );


    multiplexer # (.n(5)) register_bank_multiplexer (
        .input1(instruction[20 : 16]),
        .input2(instruction[4 : 0]),
        .select(reg_to_loc),
        .result(output_register_bank_multiplexer)
    );

    RegisterBank register_bank (
        .clock(clock),
        .write(reg_write),
        .input1(instruction[9 : 5]),
        .input2(output_register_bank_multiplexer),
        .input3(instruction[4 : 0]),
        .input_data(input_data_register),
        .output1(reg_data_1),
        .output2(reg_data_2)
    );

    SignExtend sign_extend (
        .instruction(instruction), 
        .output_data(output_sign_extend)
    );

    Control control (
        .opcode(instruction[31 : 21]),
        .Reg2Loc(reg_to_loc), 
        .ALUSrc(alu_src), 
        .MemtoReg(mem_to_reg), 
        .RegWrite(reg_write),
        .MemRead(mem_read), 
        .MemWrite(mem_write), 
        .Branch(branch), 
        .ALUOp1(alu_op_1),
        .ALUOp0(alu_op_0)
    );


    ALUControl alu_control(
        .ALUOp0(alu_op_0),
        .ALUOp1(alu_op_1),
        .instruction_part(instruction[31 : 21]),
        .operation_code(alu_opcode)
    );

    multiplexer alu_multiplexer(
        .input1(reg_data_2),
        .input2(output_sign_extend),
        .select(alu_src),
        .result(output_alu_multiplexer)
    );

    ALU alu (
        .input1(reg_data_1),
        .input2(output_alu_multiplexer),
        .operation(alu_opcode),
        .output1(output_alu),
        .z(zero_alu)
    );

    shift shift_unit (
        .input_address(output_sign_extend), 
        .output_data(output_shift_unit)
    );

    Adder shift_unit_adder(
        .input1(old_pc),
        .input2(output_shift_unit),
        .outputdata(output_shift_unit_adder)
    );



    memory data_memory (
        .clk(clock), 
        .write(mem_write), 
        .read(mem_read), 
        .address(output_alu), 
        .data_in(reg_data_2),
        .data_out(output_data_memory)
    );

    

   multiplexer data_memory_multiplexer (
        .input1(output_alu),
        .input2(output_data_memory),
        .select(mem_to_reg),
        .result(input_data_register)
    );

endmodule
