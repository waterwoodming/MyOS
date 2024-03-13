#include<onix/onix.h>

int magic = ONIX_MAGIC;
char message[] = "hello onix!!!";
char buf[1024];

void kernel_init()
{
    char *video = (char *) 0xb8000;
    for (int i = 0;i < sizeof(message); i++)
    {
        video [i*2] = message[i];
        
    }


}
