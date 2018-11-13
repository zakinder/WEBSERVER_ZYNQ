################################################################################
# Automatically-generated file. Do not edit!
################################################################################

-include ../makefile.init

RM := rm -rf

# All of the sources participating in the build are defined here
-include sources.mk
-include src/WEB/webserver/subdir.mk
-include src/WEB/tftpserver/subdir.mk
-include src/WEB/rx_tx/subdir.mk
-include src/WEB/prot_malloc/subdir.mk
-include src/WEB/eplatform/subdir.mk
-include src/WEB/subdir.mk
-include src/D5M/VIDEO_RESOLUTION/subdir.mk
-include src/D5M/VIDEO_GENERATOR/subdir.mk
-include src/D5M/VIDEO_FRAME_BUFFER/subdir.mk
-include src/D5M/VIDEO_CHANNEL/subdir.mk
-include src/D5M/UART/subdir.mk
-include src/D5M/PLATFORM/subdir.mk
-include src/D5M/MENU_CALLS/subdir.mk
-include src/D5M/I2C_D5M/subdir.mk
-include src/D5M/HDMI_IIC/subdir.mk
-include src/D5M/HDMI_DISPLAY/subdir.mk
-include src/D5M/subdir.mk
-include src/subdir.mk
-include subdir.mk
-include objects.mk

ifneq ($(MAKECMDGOALS),clean)
ifneq ($(strip $(S_UPPER_DEPS)),)
-include $(S_UPPER_DEPS)
endif
ifneq ($(strip $(C_DEPS)),)
-include $(C_DEPS)
endif
endif

-include ../makefile.defs

# Add inputs and outputs from these tool invocations to the build variables 
ELFSIZE += \
d5mCamera.elf.size \


# All Target
all: pre-build main-build

# Main-build Target
main-build: d5mCamera.elf secondary-outputs

# Tool invocations
d5mCamera.elf: $(OBJS) ../src/lscript.ld $(USER_OBJS)
	@echo 'Building target: $@'
	@echo 'Invoking: ARM v7 gcc linker'
	arm-none-eabi-gcc -mcpu=cortex-a9 -mfpu=vfpv3 -mfloat-abi=hard -Wl,-build-id=none -specs=Xilinx.spec -Wl,-T -Wl,../src/lscript.ld -L../../d5mCamera_bsp/ps7_cortexa9_0/lib -o "d5mCamera.elf" $(OBJS) $(USER_OBJS) $(LIBS)
	@echo 'Finished building target: $@'
	@echo ' '

d5mCamera.elf.size: d5mCamera.elf
	@echo 'Invoking: ARM v7 Print Size'
	arm-none-eabi-size d5mCamera.elf  |tee "d5mCamera.elf.size"
	@echo 'Finished building: $@'
	@echo ' '

# Other Targets
clean:
	-$(RM) $(EXECUTABLES)$(OBJS)$(S_UPPER_DEPS)$(C_DEPS)$(ELFSIZE) d5mCamera.elf
	-@echo ' '

pre-build:
	-a9-linaro-pre-build-step
	-@echo ' '

secondary-outputs: $(ELFSIZE)

.PHONY: all clean dependents
.SECONDARY: main-build pre-build

-include ../makefile.targets
