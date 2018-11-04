################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../src/WEB/webserver/dispatch.c \
../src/WEB/webserver/echo.c \
../src/WEB/webserver/http_response.c \
../src/WEB/webserver/platform_gpio.c \
../src/WEB/webserver/web_utils.c \
../src/WEB/webserver/webserver.c 

OBJS += \
./src/WEB/webserver/dispatch.o \
./src/WEB/webserver/echo.o \
./src/WEB/webserver/http_response.o \
./src/WEB/webserver/platform_gpio.o \
./src/WEB/webserver/web_utils.o \
./src/WEB/webserver/webserver.o 

C_DEPS += \
./src/WEB/webserver/dispatch.d \
./src/WEB/webserver/echo.d \
./src/WEB/webserver/http_response.d \
./src/WEB/webserver/platform_gpio.d \
./src/WEB/webserver/web_utils.d \
./src/WEB/webserver/webserver.d 


# Each subdirectory must supply rules for building sources it contributes
src/WEB/webserver/%.o: ../src/WEB/webserver/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: ARM v7 gcc compiler'
	arm-none-eabi-gcc -Wall -O0 -g3 -c -fmessage-length=0 -MT"$@" -mcpu=cortex-a9 -mfpu=vfpv3 -mfloat-abi=hard -I../../d5mWeb_bsp/ps7_cortexa9_0/include -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


