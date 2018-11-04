################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../src/WEB/rx_tx/rxperf.c \
../src/WEB/rx_tx/txperf.c \
../src/WEB/rx_tx/urxperf.c \
../src/WEB/rx_tx/utxperf.c 

OBJS += \
./src/WEB/rx_tx/rxperf.o \
./src/WEB/rx_tx/txperf.o \
./src/WEB/rx_tx/urxperf.o \
./src/WEB/rx_tx/utxperf.o 

C_DEPS += \
./src/WEB/rx_tx/rxperf.d \
./src/WEB/rx_tx/txperf.d \
./src/WEB/rx_tx/urxperf.d \
./src/WEB/rx_tx/utxperf.d 


# Each subdirectory must supply rules for building sources it contributes
src/WEB/rx_tx/%.o: ../src/WEB/rx_tx/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: ARM v7 gcc compiler'
	arm-none-eabi-gcc -Wall -O0 -g3 -c -fmessage-length=0 -MT"$@" -mcpu=cortex-a9 -mfpu=vfpv3 -mfloat-abi=hard -I../../d5mWeb_bsp/ps7_cortexa9_0/include -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


