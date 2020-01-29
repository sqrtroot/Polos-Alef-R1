#include <stdint.h>
#include <gd32vf103.h>
#include <gd32vf103_gpio.h>
#include <gd32vf103_rcu.h>

void nop_loop(int nops){
  for(int i = 0; i < nops; i++){
    __asm("nop");
  }
}

constexpr uint32_t GPIO_P = GPIOC;
constexpr uint32_t PIN = 13;

int main(){
  rcu_periph_clock_enable(RCU_GPIOA);
  gpio_init(GPIO_P,GPIO_MODE_OUT_PP,GPIO_OSPEED_50MHZ,PIN);
  bool state = false;
  while(true){
    gpio_bit_write(GPIO_P, PIN, (bit_status) state);
    state = !state;
    nop_loop(100);
  }
}
