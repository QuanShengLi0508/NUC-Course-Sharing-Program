CODE SEGMENT
       ASSUME CS:CODE
START: MOV AX,00H
       MOV DX,0600H
AA1:   MOV AL,00H
       OUT DX,AL
       CALL DELAY
       MOV AL,7FH
       OUT DX,AL
       CALL DELAY
       JMP AA1
DELAY: PUSH CX
       MOV CX,0FFFFH
AA2:   PUSH AX
       POP AX
       LOOP AA2
       POP CX
       RET
CODE ENDS
END START
