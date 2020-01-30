#include <stdint.h>

extern "C" {
    #include <gd32vf103.h>
    #include <gd32vf103_gpio.h>
}

void nop_loop(int nops){
    for(int i = 0; i < nops; i++){
        __asm("nop");
    }
}

constexpr uint32_t GPIO_P = GPIOC;
constexpr uint32_t PIN = 1U << 13;



int main() {

    // SystemInit();


    rcu_periph_clock_enable(RCU_GPIOC);
    gpio_init(GPIO_P, GPIO_MODE_OUT_PP, GPIO_OSPEED_50MHZ, PIN);
    
    while (true) {
        GPIO_BOP(GPIO_P) = PIN;
        nop_loop(18'000'000);
        GPIO_BC(GPIO_P) = PIN;
        nop_loop(18'000'000);
    }
}
