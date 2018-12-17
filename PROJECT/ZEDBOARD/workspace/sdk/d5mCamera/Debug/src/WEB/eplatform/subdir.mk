################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../src/WEB/eplatform/platform.c 

OBJS += \
./src/WEB/eplatform/platform.o 

C_DEPS += \
./src/WEB/eplatform/platform.d 


# Each subdirectory must supply rules for building sources it contributes
src/WEB/eplatform/%.o: ../src/WEB/eplatform/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: ARM v7 gcc compiler'
	arm-none-eabi-gcc -Wall -O0 -g3 -c -fmessage-length=0 -MT"$@" -mcpu=cortex-a9 -mfpu=vfpv3 -mfloat-abi=hard -I../../d5mCamera_bsp/ps7_cortexa9_0/include -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


