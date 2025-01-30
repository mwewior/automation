################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (11.3.rel1)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../MODBUS/crc16.c \
../MODBUS/modbus.c 

OBJS += \
./MODBUS/crc16.o \
./MODBUS/modbus.o 

C_DEPS += \
./MODBUS/crc16.d \
./MODBUS/modbus.d 


# Each subdirectory must supply rules for building sources it contributes
MODBUS/%.o MODBUS/%.su MODBUS/%.cyclo: ../MODBUS/%.c MODBUS/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m7 -std=gnu11 -g3 -DUSE_HAL_DRIVER -DSTM32F746xx -DDEBUG -c -I../Core/Inc -I../Drivers/STM32F7xx_HAL_Driver/Inc -I../Drivers/STM32F7xx_HAL_Driver/Inc/Legacy -I../Drivers/CMSIS/Device/ST/STM32F7xx/Include -I../Drivers/CMSIS/Include -I../Drivers/BSP/STM32746G-Discovery -I../Drivers/BSP/ -I../MODBUS -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -fcyclomatic-complexity -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfpu=fpv5-sp-d16 -mfloat-abi=hard -mthumb -o "$@"

clean: clean-MODBUS

clean-MODBUS:
	-$(RM) ./MODBUS/crc16.cyclo ./MODBUS/crc16.d ./MODBUS/crc16.o ./MODBUS/crc16.su ./MODBUS/modbus.cyclo ./MODBUS/modbus.d ./MODBUS/modbus.o ./MODBUS/modbus.su

.PHONY: clean-MODBUS

