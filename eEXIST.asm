.MODEL SMALL
.STACK
.DATA
    S   DB  "exercise"
    ANS DB  0
    E   DB "e"
.CODE
    MAIN PROC FAR
    MOV AX,@Data
    MOV DS,AX
    ;----------
    LEA SI,S
    MOV CX,8
    
    FIND_e:
        MOV DH,E
        CMP [SI],DH
        JE YES
        JMP NO
        YES:
            INC ANS
        NO:
        INC SI
        DEC CX
    JNZ FIND_e
    
    CALL PRINT
    ;----------
    MOV AX,4C00H
    INT 21H
    MAIN ENDP
    
    
    PRINT PROC NEAR
        MOV DL,ANS
        ADD DL,30H
        MOV AH,02H
        INT 21H
        RET
    PRINT ENDP
    
    END MAIN
