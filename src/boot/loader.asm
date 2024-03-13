[org 0x1000]

dw 0x55aa; 魔数，用于判断错误

;打印字符
mov si, loading
call print

; xchg bx, bx;

detect_memory:
    xor ebx, ebx

    mov ax, 0
    mov es, ax
    mov edi, ards_buffer

    mov edx, 0x534d4150

.next:
    mov eax, 0xe820

    mov ecx, 20
    int 0x15

    jc error

    add di, cx

    inc word [ards_count]

    cmp ebx, 0
    jnz .next

    mov si, detecting
    call print
    ; xchg bx, bx
     
    ; mov byte [0xb8000], 'P'

  jmp prepare_protected_mode

prepare_protected_mode:
    

    cli;关闭中断；

    ;打开 A20 线
    in al, 0x92
    or al, 0b10
    out 0x92, al

    lgdt [gdt_ptr];加载gdt

    ;启动保护模式
    mov eax, cr0
    or eax, 1
    mov cr0, eax

    ;用跳转来刷新缓存，启用保护模式
    jmp dword code_selector:protect_mode


print:
    mov ah, 0x0e
.next:
    mov al, [si]
    cmp al, 0
    jz .done
    int 0x10
    inc si
    jmp .next
.done:
    ret

loading:
    db "Loading Onix...", 10, 13, 0; \n\r
detecting:
    db "Detecting Memory Success...", 10, 13, 0; \n\r

error:
    mov si, .msg
    call print
    hlt; 让 CPU 停止
    jmp $
    .msg db "Loading Error!!!", 10, 13, 0

[bits 32]

protect_mode:
    ; xchg bx, bx
    mov ax, data_selector
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax;初始化段寄存器
    mov esp, 0x10000;修改栈顶

    mov edi, 0x10000
    mov ecx, 10;起始扇区
    mov bl, 200;扇区数量

    call read_disk

    jmp dword code_selector:0x10000

    ud2;表示出错

    xchg bx, bx

jmp $

read_disk

    ;设置读写扇区数量
    mov dx, 0x1f2
    mov al, bl
    out dx, al

    inc dx ;0x1f3
    mov al, cl;前8位
    out dx, al

    inc dx ;0x1f4
    shr ecx, 8
    mov al, cl; 起始扇区的中8位
    out dx, al

    inc dx ;0x1f5
    shr ecx, 8
    mov al, cl ;起始扇区的高8位
    out dx, al

    inc dx ;0x1f6
    shr ecx, 8
    and cl, 0b1111 ;高四位0
    
    mov al, 0b1110_0000
    or al, cl
    out dx, al;主盘 - LBA

    inc dx ;0x1f7
    mov al, 0x20;读硬盘
    out dx, al

    xor ecx, ecx;ecx清空
    mov cl, bl

    .read:
        push cx
        call .waits
        call .reads
        pop cx
        loop .read

    ret

    .waits:
        mov dx, 0x1f7
        .check:
            in al, dx
            jmp $+2
            jmp $+2
            jmp $+2
            and al, 0b1000_1000
            cmp al, 0b0000_1000
            jnz .check
        ret

    .reads:
        mov dx, 0x1f0
        mov cx, 256
        .readw:
            in ax, dx
            jmp $+2
            jmp $+2
            jmp $+2
            mov [edi], ax
            add edi, 2
            loop .readw
        ret


code_selector equ (1 << 3)
data_selector equ (2 << 3)


memory_base equ 0;内存开始的位置：基地址
;内存界限 4G/4K - 1
memory_limit  equ ((1024 * 1024 * 1024 * 4) / (1024 * 4)) - 1


gdt_ptr:
    dw (gdt_end - gdt_base) - 1
    dd gdt_base

gdt_base:
    dd 0, 0; NILL 描述符
gdt_code:    
    dw memory_limit & 0xffff;段界限  0~15
    dw memory_base & 0xffff;基地址  0~15
    db (memory_base >> 16) & 0xff;基地址  16  23
    ;存在 - dlp 0 - S _ 代码 - 非依从 - 可读 - 没有被访问
    db 0b_1_00_1_1_0_1_0
    ;4k -32 位 - 不是 64 位 - 段界限 16 ~ 19
    db 0b1_1_0_0_0000 | (memory_limit >> 16) & 0xf
    db (memory_base >> 24) & 0xff;基地址24-31
gdt_data:    
    dw memory_limit & 0xffff;段界限  0~15
    dw memory_base & 0xffff;基地址  0~15
    db (memory_base >> 16) & 0xff;基地址  16   23
    ;存在 - dlp 0 - S _ 数据 - 向上 - 可写 - 没有被访问
    db 0b_1_00_1_0_0_1_0
    ;4k -32 位 - 不是 64 位 - 段界限 16 ~ 19
    db 0b1_1_0_0_0000 | (memory_limit >> 16) & 0xf
    db (memory_base >> 24) & 0xff;基地址24-31

gdt_end:
ards_count:
    dw 0
ards_buffer:
    