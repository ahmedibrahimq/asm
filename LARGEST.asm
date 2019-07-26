.MODEL SMALL
.STACK
.DATA
    LIST    DB 80,81,78,65,23,45,89,90,10,99
    RESULT  DB 80
    P       DB 2 DUP("$"),"$"
.CODE
    MAIN PROC FAR
        MOV AX,@Data
        MOV DS,AX
        ;------------
        MOV CX,10
        LEA SI,LIST
        ADD SI,1
        
        WHO_LARGER:
            MOV AL,[SI]
            CMP RESULT,AL
            JL YES
            JMP NO
            YES:
                MOV RESULT,AL
            NO:
                INC SI
                DEC CX
        JNZ WHO_LARGER
        ;------------
        MOV AX,4C00H
        INT 21H
    MAIN ENDP   
    END MAIN
