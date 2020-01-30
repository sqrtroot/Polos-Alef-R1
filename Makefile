.phony: all clean force flash backup flash_tool

VENDOR_ID      := 28e9
DEVICE_ID      := 0189
DEVICE_ALT     := 0
START_LOCATION := 0x08000000

CXX_COMPILE_COMMAND = clang++
C_COMPILE_COMMAND   = clang
LINK_COMMAND        = riscv64-linux-gnu-ld
OBJCOPY_COMMAND     = riscv64-linux-gnu-objcopy

OPTIMIZE    = s
C_VERSION   = c11
CXX_VERSION = c++17

DEFINES := ${addprefix -D,\
	HXTAL_VALUE=8000000 \
	F_CPU=108000000L \
}

COMPILE_ARGS := -c --target=riscv32 -march=rv32imac ${DEFINES} -O${OPTIMIZE} -fno-exceptions
LINK_ARGS    := -m elf32lriscv -T linkerxb.ld -O${OPTIMIZE}
OBJCOPY_ARGS := -O binary -S

SRCS := \
	main.cpp \
	asm.S \
	lib/GD32VF103_Firmware/GD32VF103_standard_peripheral/Source/gd32vf103_gpio.c \
	lib/GD32VF103_Firmware/GD32VF103_standard_peripheral/Source/gd32vf103_rcu.c \
	lib/GD32VF103_Firmware/GD32VF103_standard_peripheral/system_gd32vf103.c \

INCLUDES := \
	lib/GD32VF103_Firmware/GD32VF103_standard_peripheral/Include \
	lib/GD32VF103_Firmware/GD32VF103_standard_peripheral \
  lib/GD32VF103_Firmware/RISCV/drivers/ \

OBJ  := $(SRCS:.c=.o)
OBJ  := $(OBJ:.cpp=.o)
OBJ  := $(OBJ:.S=.o)

all: out.elf

clean:
	rm -f out.elf out.bin out.dfu ${OBJ}

force: clean all

flash: out.bin flash_tool/src/dfu-util
	flash_tool/src/dfu-util -a ${DEVICE_ALT} -d ${VENDOR_ID}:${DEVICE_ID} -s ${START_LOCATION} -D $< 

flash_tool/src/dfu-util: flash_tool
flash_tool/config.status:
	cd flash_tool && ./configure
flash_tool: flash_tool/config.status
	cd flash_tool && $(MAKE)
%.bin: %.elf 
	${OBJCOPY_COMMAND} ${OBJCOPY_ARGS} $< $@

out.elf: ${OBJ}
	${LINK_COMMAND} ${LINK_ARGS} $^ -o $@

%.o : %.cpp
	${CXX_COMPILE_COMMAND} ${COMPILE_ARGS} -std=${CXX_VERSION} $< $(addprefix -I, ${INCLUDES}) -o $@
%.o : %.c
	${C_COMPILE_COMMAND}   ${COMPILE_ARGS} -std=${C_VERSION} $< $(addprefix -I, ${INCLUDES}) -o $@
%.o : %.S
	${C_COMPILE_COMMAND}   ${COMPILE_ARGS} $< $(addprefix -I, ${INCLUDES}) -o $@
