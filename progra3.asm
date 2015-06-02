;---------------------------------------------------------------------------------------------------------
;						INSTITUTO TECNOLÓGICO DE COSTA RICA
;									TAREA PROGRAMADA 3
;										PROYECTO FINAL
;										SEMESTRE 2015
;
;										MAQUINA ENIGMA
;
;									ANDRES PENIA CASTILLO
;											GERMAN VIVES
;							ISAAC CAMPOS MESEN 2014004626
;
;										ANIO 2015
;---------------------------------------------------------------------------------------------------------;

	section .bss							;Section containing uninitialized data

BUFLEN equ 1					;We read the file 1024 bytes at a time
Buffer resb BUFLEN					;Text buffer itself

	section .data						;Section containing initialized data

;varIntToStringLEN	equ $ - varIntToString

entrada: db ' ENTRADA = ';'------------------------------------------------------------', 10,10,\
'        INSTITUTO TECNOLOGICO DE COSTA RICA', 10,\
'                TAREA PROGRAMADA 3', 10,\
'                 I SEMESTRE 2015', 10,10,\
'            MAQUINA ENIGMA', 10, 10,\
'          ISAAC CAMPOS MESEN 2014004626', 10,\
'        ANDRES PENIA CASTILLO', 10,\
'                GERMAN VIVES', 10, 10,\
'                    ANIO 2015', 10,10,\
'------------------------------------------------------------',10, 10, ' ENTRADA = '

entradaLEN	equ $ - entrada

salida: db " RESULTADO = "
salidaLEN equ $ - salida

varRotor1: db 'AJDKSIRUXBLHWTMCQGZNPYFVOE',10
varRotor2: db 'BDFHJLCPRTXVZNYEIWGAKMUSQO',10
varRotor3: db 'VZBRGITYUPSDNHLXAWMJQOFECK',10
varMsjEncriptado: db '..........................',10


	section .text						;Section containing code

global _start							;Linker needs this to find the entry point!

_start:

	call read
	xor r15, r15

	mov al, byte[rsi]					;se guarda el caracter leido
	mov rsi, varRotor1
	call getLetraRotor
	mov [varMsjEncriptado+r15], byte al
	inc r15
	call printMsjEncriptado

	jmp done

;Read a buffer full of text from stdin:
read:
	mov rax, 0						;sys_read (code 0)
	mov rdi, 0						;file_descriptor (code 0 stdin)
	mov rsi, Buffer				;address to the buffer to read into
	mov rdx, BUFLEN			;maximun number of bytes to read
	syscall								;system call

	mov rbp, rax					;save the number of bytes read
	cmp rax, 0						;test if the number of bytes read is 0
		jz done							;jump to the tag done if it is 0

	;Setup the register for later use
	mov rsi, Buffer				;place the buffer address in the rsi
ret

getLetraRotor:
	sub al, "A"						;se resta A para obtener el indice del entrada
	mov al, byte[varRotor1+rax]
ret

printMsjEncriptado:
	push rax
	push rcx
	push rdx
	push rsi
	push rdi

	mov byte[varMsjEncriptado+r15], 10	;agregamos un cambio de linea
	inc r15

	mov rax, 1								;sys_write (code 1)
	mov rdi, 1								;file_descriptor (code 1 stdout)
	mov rsi, varMsjEncriptado				;address of the buffer to print out
	mov rdx, r15								;number of chars to print out
	syscall										;system call

	dec r15
	mov byte[varMsjEncriptado+r15], 0h	;volvemos a insertar el caracter null al final

	pop rdi
	pop rsi
	pop rdx
	pop rcx
	pop rax
ret

done:
	mov rax, 60							;sys_exit (code 60)
	mov rdi, 	0								;exit_code (code 0 successful)
	syscall
