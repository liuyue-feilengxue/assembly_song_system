assume cs:codeseg, ds:dataseg, ss:stackseg
dataseg segment
;有需要的请修改这里，mus_freq为音调，mus_time为音长
;基础乐理自行学习
;4/4拍的歌，在mus_time中，一个节拍是25，半拍12，两拍50
;《刚好遇见你》由于音太高，调低8度，节奏也减慢
;只有副歌部分
mus_freq1 dw 262,262,262
		  dw 262,220,524,440,440,440,392
		  dw 392,330,330,262,294,262,262
		  dw 262,220,524,587,524,524,440
		  dw 440,392,330,392,294,262,247
		  dw 262,220,524,440,440,440,392
		  dw 392,392,330,392,294,262,294
		  dw 262,247,262,262,262,294
		  dw 330,294,262,262,247,262,262
		  dw -1
mus_time1 dw 3 dup(25)
		  dw 25,25,25,25,50,25,25
		  dw 25,25,25,25,50,25,25
		  dw 25,25,25,25,50,25,25
		  dw 25,25,25,25,50,25,25
		  dw 25,25,25,25,50,25,25
		  dw 25,25,25,25,50,25,25
		  dw 25,12,12,100,25,25
		  dw 25,12,12,25,12,12,100
;《成都》3/4拍，一拍25，两拍50，半拍12
mus_freq2 dw 196,262
		  dw 262,294,330
		  dw 392,330,330
		  dw 330,196
		  dw 262
		  dw 294,262,220
		  dw 196,196
		  dw 262,262,294,330
		  dw 440,330,392
		  dw 330,294
		  dw 262
		  dw 294,392
		  dw 330,294
		  dw 330,392
		  dw 392,330,392
		  dw 440,524,440
		  dw 330,294,262
		  dw 294,330,330
		  dw 196,392
		  dw 330,330
		  dw 294,262,262
		  dw 196,294,262
		  dw 330,294,262
		  dw 262
		  dw -1
mus_time2 dw 25,75
		  dw 50,12,12
		  dw 25,25,25
		  dw 25,50
		  dw 75
		  dw 25,25,25
		  dw 125,25
		  dw 75,50,12,12
		  dw 25,25,50
		  dw 25,25
		  dw 75
		  dw 50,25
		  dw 25,100
		  dw 25,75
		  dw 25,25,25
		  dw 25,25,75
		  dw 25,50,25
		  dw 50,25,125
		  dw 25,100
		  dw 25,25
		  dw 25,25,75
		  dw 25,50,25
		  dw 50,12,12
		  dw 200
		  
;《暧昧》（薛之谦版）4/4拍，由于曲速慢，所以一拍为50，半拍25
mus_freq3 dw 262,262,262,294,262
		  dw 392,440,330,330,294
		  dw 247,247,247,262,247
		  dw 330,392,247,294,262
		  dw 220,247,220,247,220
		  dw 330,349,262,220,247
		  dw 196,262,294,294
		  dw 349,330,330,294,262,294
		  dw 330,262,262,262,294,262
		  dw 392,440,330,330,294
		  dw 294,247,247,247,262,247
		  dw 330,392,247,294,262
		  dw 220,247,220,247,220
		  dw 330,349,220,262,247
		  dw 247,330,392,294,262
		  dw -1
mus_time3 dw 25,25,25,25,25
		  dw 25,100,25,25,100
		  dw 25,25,25,25,25
		  dw 25,100,25,25,100
		  dw 25,25,25,25,25
		  dw 25,100,25,25,75
		  dw 25,50,50,25
		  dw 50,25,25,25,50,25
		  dw 75,25,25,25,25,25
		  dw 25,100,25,25,25
		  dw 75,25,25,25,25,25
		  dw 25,100,25,25,100
		  dw 25,25,25,25,25
		  dw 25,100,25,25,25
		  dw 100,50,25,50,75
str1 db 'Please select the song you want',0ah,0dh,'$'
inbuf db 3 dup(?)
dataseg ends

stackseg segment
   db 100h dup (0)
stackseg ends

codeseg segment
start:
    mov ax, stackseg
    mov ss, ax
    mov sp, 100h

    mov ax, dataseg
    mov ds, ax
	
	;提示语
	MOV DX,OFFSET str1
    MOV AH,09H
    INT 21H
    ;输入需要演奏哪一首歌
a1:
	;输入
	 mov ah,01
	 int 21h
	;判断回车
	 cmp al,0dh
	 je contin
	;存入inpuf
	 mov inbuf[di],al
	 inc di
	 loop a1
contin:
	mov di,0
	cmp inbuf[di],31h
	je mus1
	cmp inbuf[di],32h
	je mus2
	cmp inbuf[di],33h
	je mus3
	
	jmp end_mus
	;第一首歌
mus1:
	lea si, mus_freq1
    lea di, mus_time1
    jmp freq
    ;初始化完成
mus2:
	lea si, mus_freq2
    lea di, mus_time2
    jmp freq
mus3:
	lea si, mus_freq3
    lea di, mus_time3

freq:
    mov dx, [si]
    cmp dx, -1;最后一个音符为-1，结束
    je end_mus
    call sound
    add si, 2
    add di, 2
    jmp freq

end_mus:
    mov ax, 4c00h
    int 21h

;演奏一个音符（书P389改编）
;si - 要演奏的音符的频率的地址（音高）
;di - 要演奏的音符的音长的地址（音持续时间）
sound:
    push ax
    push dx
    push cx
	
	;8253 芯片(定时/计数器)的设置
    mov al,0b6h    
    out 43h,al     
    mov dx,12h
    mov ax,348ch
    div word ptr [si] ;计算分频值,赋给ax。[si]中存放声音的频率值。***
    out 42h, al       ;先送低8位到计数器
    mov al, ah
    out 42h, al       ;后送高8位计数器

    ;设置8255芯片, 控制扬声器的开/关
    in al,61h   ;读取8255 B端口原值
    mov ah,al   ;保存原值到ah
    or al,3     ;使低两位置1，以便打开开关
    out 61h,al  ;开扬声器, 发声

    mov dx, [di]       ;保持[di]时长
wait1:
    mov cx, 50000
delay:
    loop delay
    dec dx
    jnz wait1

    mov al, ah         ;恢复扬声器端口原值
    out 61h, al

	mov cx, 10000
delay1:
    loop delay1
    
    pop cx
    pop dx
    pop ax
    ret

codeseg ends
end start

