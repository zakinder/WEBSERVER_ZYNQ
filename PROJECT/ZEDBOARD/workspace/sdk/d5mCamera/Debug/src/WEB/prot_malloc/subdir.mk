################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../src/WEB/prot_malloc/prot_malloc.c 

OBJS += \
./src/WEB/prot_malloc/prot_malloc.o 

C_DEPS += \
./src/WEB/prot_malloc/prot_malloc.d 


# Each subdirectory must supply rules for building sources it contributes
src/WEB/prot_malloc/%.o: ../src/WEB/prot_malloc/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: ARM v7 gcc compiler'
	arm-none-eabi-gcc -Wall -O0 -g3 -c -fmessage-length=0 -MT"$@" -mcpu=cortex-a9 -mfpu=vfpv3 -mfloat-abi=hard -I../../d5mCamera_bsp/ps7_cortexa9_0/include -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


