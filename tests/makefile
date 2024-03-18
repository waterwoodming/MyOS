CFLAGS:= -m32
CFLAGS+= -Qn #去掉 GCC的版本信息
# CFLAGS+= -fno-builtin #不需要 gcc 内置函数
# CFLAGS+= -nostdinc #不需要标准头文件
 CFLAGS+= -fno-pic  #不需要位置无关的带代码
# CFLAGS+= -fno-pie  #不需要位置无关的可执行程序
# CFLAGS+= -nostdinc #不需要标准库
# CFLAGS+= -fno-stack-protector #不需要栈保护
CFLAGS+= -mpreferred-stack-boundary=2#不需要栈对其
CFLAGS+= -fno-asynchronous-unwind-tables#不需要CFI信息	
CFLAGS:=$(strip ${CFLAGS})


.PHONY:hello.s
hello.s: hello.c
	gcc $(CFLAGS) -S $< -o $@