
 ORG 0000H
 AJMP START
 ORG 0030H		;?
START:  LCALL FORMAT
        MOV A,#00H
	MOV DPTR,#8000H
	MOVX @DPTR,A；送地址
        LCALL DY1
        MOVX A,@DPTR；开始A/D转换
        LCALL CONVER
        LCALL DISP8279
        LCALL DELAY
        AJMP START
        
FORMAT:
      MOV 78H,#0H ;        ;
      MOV 79H,#8H ;
      MOV 7AH,#0H ;
      MOV 7BH,#9H ;
      MOV 7CH,#12H ;-
      MOV 7DH,#12H ;-
      MOV 7EH,#0H ;0
      MOV 7FH,#0H ;0
      RET
CONVER:
      MOV  R0,A
      ANL A,#0FH
      MOV 7FH,A
      MOV A,R0
      SWAP A
      ANL A,#0FH
      MOV 7EH,A
      RET
      
DISP8279:                       ;显示子程序,缓冲区为78H-7FH
C8279  EQU  0E001H       ;)7fffH
D8279  EQU  0E000H       ;7FFEH
       MOV DPTR,#C8279
       MOV A,#0H
       MOVX @DPTR,A         ; 写8279方式字
       MOV A,#2aH
       MOVX @DPTR,A          ;写分频系数
       MOV A,#0D0H
       MOVX @DPTR,A          ;清显示
       MOV A,#90H
       MOVX @DPTR,A          ;设置从左边开始写入数据
DISP1: MOVX A,@DPTR
       JB ACC.7,DISP1        ;读8279工作是否正常
       MOV R0,#78H           ;显示缓冲首址
       MOV R1,#08H
DISP2: MOV A,@R0
       MOV DPTR,#TAB
       MOVC A,@A+DPTR        ;查字型
       MOV DPTR,#D8279
       cpl a
       MOVX @DPTR,A          ;送字型到8279显示
       INC R0
       DJNZ R1,DISP2
       RET
;字型代码
TAB: DB 0C0H,0F9H,0A4H,0B0H,99H,92H,82H,0F8H    ;0,1,2,3,4,5,6,7
     DB 80H,90H,88H,83H,0C6H,0A1H,86H,08EH   ;8,9,A,B,C,D,E,F
     DB 08CH,0C1H,0BFH,91H,89H,0C7H,0FFH,07FH   ; P(10),U(11),-(12),Y(13),H(14),L(15),关(16) ,.(17)

CLEAR8279:MOV DPTR,#C8279        ;清显示 子程序
          MOV A,#0D0H
          MOVX @DPTR,A
          RET

DY:	PUSH 02H              ;延时子程序
DELAY1:  PUSH 02H
DELAY2: PUSH 02H
DELAY3: DJNZ R2,DELAY3
	POP 02H
	DJNZ R2,DELAY2
	POP 02H
	DJNZ R2,DELAY1
	POP 02H
	DJNZ R2,DY
	RET
        
 DY1:MOV R7,#0FFh
      DJNZ R7,$
      RET

 DELAY:MOV R6,#0FFh
 DELY2:MOV R7,#0FFh
 DELY1:DJNZ R7,DELY1
       DJNZ R6,DELY2
       RET
       

       
END
