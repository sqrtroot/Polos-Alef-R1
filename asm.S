.section .init

.globl _start
.type _start,@function

_start:
	/* Jump to logical address first to ensure correct operation of RAM region  */
    la		a0,	_start
    li		a1,	1
	slli	a1,	a1, 29
    bleu	a1, a0, _start0800
    srli	a1,	a1, 2
    bleu	a1, a0, _start0800
    la		a0,	_start0800
    add		a0, a0, a1
	jr      a0

_start0800:

	la sp, _sp
	j main

1:
	j 1b
