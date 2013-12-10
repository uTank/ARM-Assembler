void enable_irq(void)
{
    int tmp;
    __asm("mrs tmp, CPSR");
    __asm("bic tmp, tmp, #0x80");
    __asm("msr CPSR_c, tmp");
}

void disable_irq(void)
{
    int tmp;
    __asm("mrs tmp, CPSR");
    __asm("orr tmp, tmp, #0x80");
    __asm("msr CPSR_c, tmp");
}

