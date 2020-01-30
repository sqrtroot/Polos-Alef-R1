.section .init

.globl _start
.type _start,@function

_start:
        lui     t0,     %hi(1f)         # by default the gd32fv starts execution at 0x0 which is aliased to the start of flash
        addi    t0, t0, %lo(1f)         # the assembler assumes it is being executed at the start of flash
        jr      t0                      # this causes instructions that calculate relative to the program counter to be messed up (la)
1:                                      # that's why we load the absolute adress of the next label en jump to there
        la      gp, __global_pointer$
      	la      sp, _sp
        tail    main
        j       .
