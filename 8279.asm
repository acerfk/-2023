
      ORG 0000H
      AJMP MAIN
      ORG 0030H
MAIN: MOV SP,#60H
      MOV 6FH,#70H
      MOV 70H,#8H ;        ;70H-77HΪ��ʾ������ ��ʾ"8279--1"
      MOV 71H,#02H ;
      MOV 72H,#7H ;
      MOV 73H,#9H ;
      MOV 74H,#12H ;
      MOV 75H,#12H ;
      MOV 76H,#12H ;
      MOV 77H,#01H ;

LOOP:      LCALL DISP          ;����ʾ
      MOV R2,#5H        ;��ʱ����
      LCALL DELAY
      ;   ȡ��ֵ

     LCALL GETKEY
     LCALL DISP

      MOV R2,#5H
      LCALL DELAY
      SJMP LOOP


DISP:                       ;��ʾ�ӳ���,������Ϊ70H-77H
C8279  EQU  0E001H       ;
D8279  EQU  0E000H       ;
       MOV DPTR,#C8279
       MOV A,#0H
       MOVX @DPTR,A         ; д8279��ʽ��
       MOV A,#2aH
       MOVX @DPTR,A          ;д��Ƶϵ��
       MOV A,#0D0H
       MOVX @DPTR,A          ;����ʾ
       MOV A,#90H
       MOVX @DPTR,A          ;���ô���߿�ʼд������
DISP1: MOVX A,@DPTR
       JB ACC.7,DISP1        ;��8279�����Ƿ�����
       MOV R0,#70H           ;��ʾ������ַ
       MOV R1,#08H
DISP2: MOV A,@R0
       MOV DPTR,#TAB
       MOVC A,@A+DPTR        ;������
       MOV DPTR,#D8279
       cpl a
       MOVX @DPTR,A          ;�����͵�8279��ʾ
       INC R0
       DJNZ R1,DISP2
       RET
;���ʹ���
TAB: DB 0C0H,0F9H,0A4H,0B0H,99H,92H,82H,0F8H    ;0,1,2,3,4,5,6,7
     DB 80H,90H,88H,83H,0C6H,0A1H,86H,08EH   ;8,9,A,B,C,D,E,F
     DB 08CH,0C1H,0BFH,91H,89H,0C7H,0FFH,07FH   ; P(10),U(11),-(12),Y(13),H(14),L(15),��(16) ,.(17)

CLEAR8279:MOV DPTR,#C8279        ;����ʾ �ӳ���
          MOV A,#0D0H
          MOVX @DPTR,A
          RET
          
GETKEY:   MOV DPTR,#C8279
          MOVX A,@DPTR
          ANL A,#07H
          CJNE A,#0H,GET1
          JMP GETKEY
GET1:     MOV DPTR,#D8279
          MOVX A,@DPTR
          MOV B,A
          MOV R2,#00H
          MOV DPTR,#KEYDATA
KEY1:     MOV A,#00H
          MOVC A,@A+DPTR
          CJNE A,B,KEY2
          JMP KEY3
KEY2:     INC DPTR
          INC R2
          JMP KEY1

          
KEY3:    MOV A,6FH
         MOV R1,A
          MOV A,R2
          MOV @R1,A
          INC 6FH
          CJNE R1,#78h,KEY4
          MOV 6FH,#70H
KEY4:   RET
KEYDATA:  DB 23H,2BH,33H,3BH , 22H,2AH,32H,3AH
          DB 21H,29H,31H,39H,20H,28H,30H,38H
          
DELAY:	PUSH 02H              ;��ʱ�ӳ���
DELAY1:  PUSH 02H
DELAY2: PUSH 02H
DELAY3: DJNZ R2,DELAY3
	POP 02H
	DJNZ R2,DELAY2
	POP 02H
	DJNZ R2,DELAY1
	POP 02H
	DJNZ R2,DELAY
	RET
     END
