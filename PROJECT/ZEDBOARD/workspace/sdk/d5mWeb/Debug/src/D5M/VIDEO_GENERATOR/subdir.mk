################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../src/D5M/VIDEO_GENERATOR/video_generator.c 

OBJS += \
./src/D5M/VIDEO_GENERATOR/video_generator.o 

C_DEPS += \
./src/D5M/VIDEO_GENERATOR/video_generator.d 


# Each subdirectory must supply rules for building sources it contributes
src/D5M/VIDEO_GENERATOR/%.o: ../src/D5M/VIDEO_GENERATOR/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: ARM v7 gcc compiler'
	arm-none-eabi-gcc -Wall -O0 -g3 -c -fmessage-length=0 -MT"$@" -mcpu=cortex-a9 -mfpu=vfpv3 -mfloat-abi=hard -I../../d5mWeb_bsp/ps7_cortexa9_0/include -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


