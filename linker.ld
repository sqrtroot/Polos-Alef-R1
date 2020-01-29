OUTPUT_FORMAT("elf32-littleriscv")
OUTPUT_ARCH(riscv)
ENTRY(_start)
MEMORY
{
	flash (rxai!w) : ORIGIN = 0x08000000, LENGTH = 128k
	ram   (wxa!ri) : ORIGIN = 0x20000000, LENGTH = 32K
}
