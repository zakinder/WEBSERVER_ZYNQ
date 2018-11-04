################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../src/WEB/tftpserver/tftpserver.c \
../src/WEB/tftpserver/tftputils.c 

OBJS += \
./src/WEB/tftpserver/tftpserver.o \
./src/WEB/tftpserver/tftputils.o 

C_DEPS += \
./src/WEB/tftpserver/tftpserver.d \
./src/WEB/tftpserver/tftputils.d 


# Each subdirectory must supply rules for building sources it contributes
src/WEB/tftpserver/%.o: ../src/WEB/tftpserver/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: ARM v7 gcc compiler'
	arm-none-eabi-gcc -Wall -O0 -g3 -c -fmessage-length=0 -MT"$@" -mcpu=cortex-a9 -mfpu=vfpv3 -mfloat-abi=hard -I../../d5mWeb_bsp/ps7_cortexa9_0/include -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


