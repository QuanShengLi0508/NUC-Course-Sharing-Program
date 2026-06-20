DSG   SEGMENT 
DATA DB 31H,32H,61H,41H,42H,03H,77H,81H,93H,55H
RESULT DB 10 DUP(0)
DSG ENDS
CSG SEGMENT
ASSUME CS:CSG,DS:DSG
START:
      	 MOV AX,DSG
         MOV DS,AX
         CALL CONVERT 
MOV AH,4CH
         INT 21H
CONVERT PROC
	      LEA SI,DATA
         LEA DI,RESULT  
      	MOV CX,10 
NEXT1:   MOV AL,[SI]
         ROL AL,1
ROL AL,1
ROL AL,1
ROL AL,1
         AND AL,0FH
         MOV BL,10
         MUL BL
         MOV DL,[SI]
         AND DL,0FH
         ADD AL,DL
         MOV [DI],AL
         INC SI
INC DI
         LOOP NEXT1
         RET
CONVERT ENDP
         
CSG ENDS
END START