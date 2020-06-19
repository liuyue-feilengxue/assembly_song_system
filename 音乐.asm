DATAS SEGMENT
    ;此处输入数据段代码  
    mus_freg dw 330,294,262,294,3 dup(330)
    		 dw 3 dup(294),330,392,392
    		 dw 330,294,262,294,4 dup(330)
    		 dw 294,294,330,294,262,-1
    mus_time dw 6 dup(25),50
    		 dw 2 dup(25,25,50)
    		 dw 12 dup(25),100
DATAS ENDS

STACKS SEGMENT
    ;此处输入堆栈段代码
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
    ;此处输入代码段代码
    
    mov al,0b6h
    out 43h,al
    mov dx,12h
    mov ax,348Ch
    div di
    out 42h,al
    mov al,ah
    out 42h,al
    in al,61h
    mov ah,al
    or al,3
    out 61h,al
wait1:
	mov cx,2800
delay:
	loop delay
	dec bx
	jnz wait1
	mov al,ah
	out 61h,al
    
    MOV AH,4CH
    INT 21H
CODES ENDS
    END START



