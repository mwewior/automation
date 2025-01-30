/**
  ******************************************************************************
  * @file    stm32746g_discovery_ts.c
  * @author  MCD Application Team
  * @version V1.1.0
  * @date    22-April-2016
  * @brief   This file provides a set of functions needed to manage the Touch
  *          Screen on STM32746G-Discovery board.
  @verbatim
   1. How To use this driver:
   --------------------------
      - This driver is used to drive the touch screen module of the STM32746G-Discovery
        board on the RK043FN48H-CT672B 480x272 LCD screen with capacitive touch screen.
      - The FT5336 component driver must be included in project files according to
        the touch screen driver present on this board.

   2. Driver description:
   ---------------------
     + Initialization steps:
        o Initialize the TS module using the BSP_TS_Init() function. This
          function includes the MSP layer hardware resources initialization and the
          communication layer configuration to start the TS use. The LCD size properties
          (x and y) are passed as parameters.
        o If TS interrupt mode is desired, you must configure the TS interrupt mode
          by calling the function BSP_TS_ITConfig(). The TS interrupt mode is generated
          as an external interrupt whenever a touch is detected.
          The interrupt mode internally uses the IO functionalities driver driven by
          the IO expander, to configure the IT line.

     + Touch screen use
        o The touch screen state is captured whenever the function BSP_TS_GetState() is
          used. This function returns information about the last LCD touch occurred
          in the TS_StateTypeDef structure.
        o If TS interrupt mode is used, the function BSP_TS_ITGetStatus() is needed to get
          the interrupt status. To clear the IT pending bits, you should call the
          function BSP_TS_ITClear().
        o The IT is handled using the corresponding external interrupt IRQ handler,
          the user IT callback treatment is implemented on the same external interrupt
          callback.
  @endverbatim
  ******************************************************************************
  * @attention
  *
  * <h2><center>&copy; COPYRIGHT(c) 2016 STMicroelectronics</center></h2>
  *
  * Redistribution and use in source and binary forms, with or without modification,
  * are permitted provided that the following conditions are met:
  *   1. Redistributions of source code must retain the above copyright notice,
  *      this list of conditions and the following disclaimer.
  *   2. Redistributions in binary form must reproduce the above copyright notice,
  *      this list of conditions and the following disclaimer in the documentation
  *      and/or other materials provided with the distribution.
  *   3. Neither the name of STMicroelectronics nor the names of its contributors
  *      may be used to endorse or promote products derived from this software
  *      without specific prior written permission.
  *
  * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
  * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
  * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
  * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
  * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
  * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
  * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
  * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
  * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
  *
  ******************************************************************************
  */

/* Includes ------------------------------------------------------------------*/
#include "stm32f746g_discovery_ts_remote.h"

/** @addtogroup BSP
  * @{
  */

/** @addtogroup STM32746G_DISCOVERY
  * @{
  */

/** @defgroup STM32746G_DISCOVERY_TS STM32746G_DISCOVERY_TS
  * @{
  */

/** @defgroup STM32746G_DISCOVERY_TS_Private_Types_Definitions STM32746G_DISCOVERY_TS Types Definitions
  * @{
  */
/**
  * @}
  */

/** @defgroup STM32746G_DISCOVERY_TS_Private_Defines STM32746G_DISCOVERY_TS Types Defines
  * @{
  */
/**
  * @}
  */

/** @defgroup STM32746G_DISCOVERY_TS_Private_Macros STM32746G_DISCOVERY_TS Private Macros
  * @{
  */
/**
  * @}
  */

/** @defgroup STM32746G_DISCOVERY_TS_Imported_Variables STM32746G_DISCOVERY_TS Imported Variables
  * @{
  */
  /**
    * @}
    */

/** @defgroup STM32746G_DISCOVERY_TS_Private_Variables STM32746G_DISCOVERY_TS Private Variables
  * @{
  */
extern uint32_t ADC3_buffer[2];

/**
  * @}
  */

/** @defgroup STM32746G_DISCOVERY_TS_Private_Function_Prototypes STM32746G_DISCOVERY_TS Private Function Prototypes
  * @{
  */
/**
  * @}
  */

/** @defgroup STM32746G_DISCOVERY_TS_Exported_Functions STM32746G_DISCOVERY_TS Exported Functions
  * @{
  */

/**
  * @brief  Initializes and configures the touch screen functionalities and
  *         configures all necessary hardware resources (GPIOs, I2C, clocks..).
  * @param  ts_SizeX: Maximum X size of the TS area on LCD
  * @param  ts_SizeY: Maximum Y size of the TS area on LCD
  * @retval TS_OK if all initializations are OK. Other value if error.
  */
uint8_t BSP_TS_Init(uint16_t ts_SizeX, uint16_t ts_SizeY)
{
  return TS_OK;
}

/**
  * @brief  DeInitializes the TouchScreen.
  * @retval TS state
  */
uint8_t BSP_TS_DeInit(void)
{
  /* Actually ts_driver does not provide a DeInit function */
  return TS_OK;
}

/**
  * @brief  Configures and enables the touch screen interrupts.
  * @retval TS_OK if all initializations are OK. Other value if error.
  */
uint8_t BSP_TS_ITConfig(void)
{
  return TS_OK;
}

/**
  * @brief  Gets the touch screen interrupt status.
  * @retval TS_OK if all initializations are OK. Other value if error.
  */
uint8_t BSP_TS_ITGetStatus(void)
{
  /* Return the TS IT status */
  return TS_NO_IRQ_PENDING;
}

/**
  * @brief  Returns status and positions of the touch screen.
  * @param  TS_State: Pointer to touch screen current state structure
  * @retval TS_OK if all initializations are OK. Other value if error.
  */
uint8_t BSP_TS_GetState(TS_StateTypeDef *TS_State)
{
  TS_State->touchDetected = HAL_GPIO_ReadPin(TS_TOUCHED_GPIO_Port, TS_TOUCHED_Pin) == GPIO_PIN_SET?1:0;

  if(TS_State->touchDetected){
        TS_State->touchX[0] = ADC3_buffer[0]*(479+TS_CAL_SCALE_X)/4095;
        TS_State->touchY[0] = ADC3_buffer[1]*(271+TS_CAL_SCALE_Y)/4095;
  } else {
	  return TS_OK;
  }

  return TS_OK;
}

/**
  * @brief  Clears all touch screen interrupts.
  */
void BSP_TS_ITClear(void)
{
  /* Clear TS IT pending bits */
}


/** @defgroup STM32756G_DISCOVERY_TS_Private_Functions TS Private Functions
  * @{
  */


/**
  * @brief  Function used to reset all touch data before a new acquisition
  *         of touch information.
  * @param  TS_State: Pointer to touch screen current state structure
  * @retval TS_OK if OK, TE_ERROR if problem found.
  */
uint8_t BSP_TS_ResetTouchData(TS_StateTypeDef *TS_State)
{
  uint8_t ts_status = TS_ERROR;

  if (TS_State != (TS_StateTypeDef *)NULL)
  {
	TS_State->touchDetected = 0;
	TS_State->touchX[0] = 0;
	TS_State->touchY[0] = 0;

    ts_status = TS_OK;

  } /* of if (TS_State != (TS_StateTypeDef *)NULL) */

  return (ts_status);
}

/**
  * @}
  */

/**
  * @}
  */

/**
  * @}
  */

/**
  * @}
  */

/**
  * @}
  */

/************************ (C) COPYRIGHT STMicroelectronics *****END OF FILE****/
