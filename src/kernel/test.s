	.file	"test.c"
	.text
	.globl	magic
	.data
	.align 4
	.type	magic, @object
	.size	magic, 4
magic:
	.long	20240313
	.globl	message
	.align 4
	.type	message, @object
	.size	message, 14
message:
	.string	"hello onix!!!"
	.globl	buf
	.bss
	.align 32
	.type	buf, @object
	.size	buf, 1024
buf:
	.zero	1024
	.text
	.globl	kernel_init
	.type	kernel_init, @function
kernel_init:
.LFB0:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	pushl	%ebx
	subl	$16, %esp
	.cfi_offset 3, -12
	call	__x86.get_pc_thunk.ax
	addl	$_GLOBAL_OFFSET_TABLE_, %eax
	movl	$753664, -8(%ebp)
	movl	$0, -12(%ebp)
	jmp	.L2
.L3:
	movl	-12(%ebp), %edx
	addl	%edx, %edx
	movl	%edx, %ecx
	movl	-8(%ebp), %edx
	addl	%edx, %ecx
	leal	message@GOTOFF(%eax), %ebx
	movl	-12(%ebp), %edx
	addl	%ebx, %edx
	movzbl	(%edx), %edx
	movb	%dl, (%ecx)
	addl	$1, -12(%ebp)
.L2:
	movl	-12(%ebp), %edx
	cmpl	$13, %edx
	jbe	.L3
	nop
	nop
	movl	-4(%ebp), %ebx
	leave
	.cfi_restore 5
	.cfi_restore 3
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE0:
	.size	kernel_init, .-kernel_init
	.section	.text.__x86.get_pc_thunk.ax,"axG",@progbits,__x86.get_pc_thunk.ax,comdat
	.globl	__x86.get_pc_thunk.ax
	.hidden	__x86.get_pc_thunk.ax
	.type	__x86.get_pc_thunk.ax, @function
__x86.get_pc_thunk.ax:
.LFB1:
	.cfi_startproc
	movl	(%esp), %eax
	ret
	.cfi_endproc
.LFE1:
	.ident	"GCC: (Ubuntu 11.4.0-1ubuntu1~22.04) 11.4.0"
	.section	.note.GNU-stack,"",@progbits
