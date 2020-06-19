assume cs:codeseg, ds:dataseg, ss:stackseg
dataseg segment
;����Ҫ�����޸����mus_freqΪ������mus_timeΪ����
;������������ѧϰ
;4/4�ĵĸ裬��mus_time�У�һ��������25������12������50
;���պ������㡷������̫�ߣ�����8�ȣ�����Ҳ����
;ֻ�и��貿��
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
;���ɶ���3/4�ģ�һ��25������50������12
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
		  
;����������Ѧ֮ǫ�棩4/4�ģ�����������������һ��Ϊ50������25
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
	
	;��ʾ��
	MOV DX,OFFSET str1
    MOV AH,09H
    INT 21H
    ;������Ҫ������һ�׸�
a1:
	;����
	 mov ah,01
	 int 21h
	;�жϻس�
	 cmp al,0dh
	 je contin
	;����inpuf
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
	;��һ�׸�
mus1:
	lea si, mus_freq1
    lea di, mus_time1
    jmp freq
    ;��ʼ�����
mus2:
	lea si, mus_freq2
    lea di, mus_time2
    jmp freq
mus3:
	lea si, mus_freq3
    lea di, mus_time3

freq:
    mov dx, [si]
    cmp dx, -1;���һ������Ϊ-1������
    je end_mus
    call sound
    add si, 2
    add di, 2
    jmp freq

end_mus:
    mov ax, 4c00h
    int 21h

;����һ����������P389�ıࣩ
;si - Ҫ�����������Ƶ�ʵĵ�ַ�����ߣ�
;di - Ҫ����������������ĵ�ַ��������ʱ�䣩
sound:
    push ax
    push dx
    push cx
	
	;8253 оƬ(��ʱ/������)������
    mov al,0b6h    
    out 43h,al     
    mov dx,12h
    mov ax,348ch
    div word ptr [si] ;�����Ƶֵ,����ax��[si]�д��������Ƶ��ֵ��***
    out 42h, al       ;���͵�8λ��������
    mov al, ah
    out 42h, al       ;���͸�8λ������

    ;����8255оƬ, �����������Ŀ�/��
    in al,61h   ;��ȡ8255 B�˿�ԭֵ
    mov ah,al   ;����ԭֵ��ah
    or al,3     ;ʹ����λ��1���Ա�򿪿���
    out 61h,al  ;��������, ����

    mov dx, [di]       ;����[di]ʱ��
wait1:
    mov cx, 50000
delay:
    loop delay
    dec dx
    jnz wait1

    mov al, ah         ;�ָ��������˿�ԭֵ
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

