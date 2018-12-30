`default_nettype none

module CPUPipelin ();

    wire clock, EX_zero_alu, MEM_zero_alu;

    wire reg_to_loc, ID_alu_src, ID_mem_to_reg, ID_reg_write, ID_mem_read, ID_mem_write, ID_branch, ID_alu_op_1, ID_alu_op_0;

    wire EX_alu_src, EX_mem_to_reg, EX_reg_write, EX_mem_read, EX_mem_write, EX_branch, EX_alu_op_1, EX_alu_op_0;

    wire MEM_mem_to_reg, MEM_reg_write, MEM_mem_read, MEM_mem_write, MEM_branch;

    wire WB_mem_to_reg, WB_reg_write;

    wire [63 : 0] ID_reg_data_1, EX_reg_data_1;
    wire [63 : 0] ID_reg_data_2, EX_reg_data_2, MEM_reg_data_2;

    wire [63 : 0] ID_output_sign_extend, EX_output_sign_extend;

    wire [63 : 0] EX_output_alu, MEM_output_alu, WB_output_alu;


    wire [63 : 0] EX_output_shift_unit_adder, MEM_output_shift_unit_adder;

    wire [3 : 0] alu_opcode;
    wire [4 : 0] output_register_bank_multiplexer;
    wire [31 : 0] ID_instruction, IF_instruction, EX_instruction, MEM_instruction, WB_instruction;

    wire [63 : 0] IF_old_pc, ID_old_pc, EX_old_pc, new_pc, output_pc_adder, MEM_output_data_memory, WB_output_data_memory, output_alu,  output_alu_multiplexer, WB_input_data_register, output_shift_unit, output_shift_unit_adder;

    reg pc_reset;

    initial begin
        pc_reset = 1; 
        #100 pc_reset = 0;
    end

    clock clock_1(clock);


    // IF STAGE

    multiplexer pc_multiplexer (
        .input1(output_pc_adder),
        .input2(output_shift_unit_adder),
        .select(MEM_branch & MEM_zero_alu),
        .result(new_pc)
    );

    Register pc_1 (   
        .clock(clock),
        .reset(pc_reset),
        .new_output(new_pc),
        .old_output(IF_old_pc)
    );

    Adder pc_adder (
        .input1(IF_old_pc),
        .input2(64'b100),
        .outputdata(output_pc_adder)
    );



    Register #(.n(96)) IF_ID (
        .clock(clock),
        .reset(pc_reset),
        .new_output({IF_old_pc, IF_instruction}),
        .old_output({ID_old_pc, ID_instruction})
    );

    // ID STAGE

    Control control_unit (
        .opcode(ID_instruction[31 : 21]),
        .Reg2Loc(reg_to_loc), 
        .ALUSrc(ID_alu_src), 
        .MemtoReg(ID_mem_to_reg), 
        .RegWrite(ID_reg_write),
        .MemRead(ID_mem_read), 
        .MemWrite(ID_mem_write), 
        .Branch(ID_branch), 
        .ALUOp1(ID_alu_op_1),
        .ALUOp0(ID_alu_op_0)
    );

    multiplexer # (.n(5)) register_bank_multiplexer (
        .input1(ID_instruction[20 : 16]),
        .input2(ID_instruction[4 : 0]),
        .select(reg_to_loc),
        .result(output_register_bank_multiplexer)
    );

    RegisterBank register_bank (
        .clock(clock),
        .write(WB_reg_write),
        .input1(ID_instruction[9 : 5]),
        .input2(output_register_bank_multiplexer),
        .input3(WB_instruction[4 : 0]),
        .input_data(WB_input_data_register),
        .output1(ID_reg_data_1),
        .output2(ID_reg_data_2)
    );

    SignExtend sign_extend (
        .instruction(ID_instruction), 
        .output_data(ID_output_sign_extend)
    );

    Register #(.n(280)) ID_EX (
        .clock(clock),
        .reset(pc_reset),
        .new_output({
            ID_reg_write, ID_mem_to_reg,              // WB
            ID_branch, ID_mem_read, ID_mem_write,     // M
            ID_alu_op_0, ID_alu_op_1, ID_alu_src      // EX
            , ID_old_pc, ID_reg_data_1, ID_reg_data_2, ID_output_sign_extend, ID_instruction[31 : 21], ID_instruction[4 : 0]}),
        .old_output({
            EX_reg_write, EX_mem_to_reg,              // WB
            EX_branch, EX_mem_read, EX_mem_write,     // M
            EX_alu_op_0, EX_alu_op_1, EX_alu_src      // EX
            , EX_old_pc, EX_reg_data_1, EX_reg_data_2, EX_output_sign_extend, EX_instruction[31 : 21], EX_instruction[4 : 0]})
   );

    // EX STAGE

    ALUControl alu_control_unit (
        .ALUOp0(EX_alu_op_0),
        .ALUOp1(EX_alu_op_1),
        .instruction_part(EX_instruction[31 : 21]),
        .operation_code(alu_opcode)
    );

    multiplexer alu_multiplexer(
        .input1(EX_reg_data_2),
        .input2(EX_output_sign_extend),
        .select(EX_alu_src),
        .result(output_alu_multiplexer)
    );

    ALU alu (
        .input1(EX_reg_data_1),
        .input2(output_alu_multiplexer),
        .operation(alu_opcode),
        .output1(EX_output_alu),
        .z(EX_zero_alu)
    );

    shift shift_unit (
        .input_address(EX_output_sign_extend), 
        .output_data(output_shift_unit)
    );

    Adder shift_unit_adder(
        .input1(EX_old_pc),
        .input2(output_shift_unit),
        .outputdata(EX_output_shift_unit_adder)
    );

    Register #(.n(203)) EX_MEM (
        .clock(clock),
        .reset(pc_reset),
        .new_output({
            EX_reg_write, EX_mem_to_reg,              // WB
            EX_branch, EX_mem_read, EX_mem_write     // M
            , EX_output_shift_unit_adder, EX_zero_alu, EX_output_alu, EX_reg_data_2, EX_instruction[4 : 0]}),
        .old_output({
            MEM_reg_write, MEM_mem_to_reg,              // WB
            MEM_branch, MEM_mem_read, MEM_mem_write     // M
            , MEM_output_shift_unit_adder, MEM_zero_alu, MEM_output_alu, MEM_reg_data_2, MEM_instruction[4 : 0]})
    );

    // MEM STAGE

    memory data_memory (
        .clk(clock), 
        .write(MEM_mem_write), 
        .read(MEM_mem_read), 
        .address(MEM_output_alu), 
        .data_in(MEM_reg_data_2),
        .data_out(MEM_output_data_memory)
    );

    Register #(.n(135)) MEM_WB (
        .clock(clock),
        .reset(pc_reset),
        .new_output({
            MEM_reg_write, MEM_mem_to_reg              // WB
            , MEM_output_data_memory, MEM_output_alu, MEM_instruction[4 : 0]}),
        .old_output({
            WB_reg_write, WB_mem_to_reg              // WB
            , WB_output_data_memory, WB_output_alu, WB_instruction[4 : 0]})
    );


    // WB STAGE

    multiplexer data_memory_multiplexer (
        .input1(WB_output_alu),
        .input2(WB_output_data_memory),
        .select(WB_mem_to_reg),
        .result(WB_input_data_register)
    );

endmodule
