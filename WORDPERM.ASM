.MODEL SMALL
.STACK
.DATA
    ;TBL DB "AHMED$$$$$$$$$$$","IBRAHIM$$$$$$$$$","MAHMOUD$$$$$$$$$","$"
    TBL DB 5 DUP(16 DUP("$")),"$"
    LEN DW  0,16,32,48,64
    MAX_LEN DW 15
    TBL_LEN DW 0
    _CX DW 5 DUP(4)
    _NL DB 0DH,0AH
    PERM DB 32768 DUP("$"),"$"
    PERM_LEN DW 0
    _$ DB "$"
    PATH DB "c:\files\list.txt",00H
    HANDLE DW ?
    ;---------
    MSG1 DB "PLEASE input words seperated by TAB PRESS",0DH,0AH,"Max word length 15 characters",0DH,0AH,"PLS press ENTER when you finish",0DH,0AH,"MAX 5 WORDS",0DH,0AH,"If you exceed limits, the program will start automatically",0DH,0AH,0DH,0AH,"***********let's Begin***********",0DH,0AH,0DH,0AH,"$"
    MSG2 DB 0DH,0AH,"---------------------",0DH,0AH,"GENERATED SUCCESSFULLY",0DH,0AH,"---------------------",0DH,0AH,0DH,0AH,"PLS FIND YOUR WORD LIST AT c:\files\list.txt",0DH,0AH,"$"
    MSG3 DB 0DH,0AH,0DH,0AH,"***********Your Wordlist***********",0DH,0AH,0DH,0AH,"$"
    ;---------
.CODE
    MAIN PROC FAR
        MOV AX,@Data
        MOV DS,AX
        MOV ES,AX
        ;---------------
        ;
        
        LEA DX,MSG1
        CALL PRINT_MSG
        
        CALL READ_WORDS
        
        LEA DI,PERM
        MOV CX,TBL_LEN
    L1: 
        MOV _CX,CX
        CALL GET_L1_WORD
        CALL COPYTO
        CALL NEW_WORD
        CMP TBL_LEN,1
        JE _1
        MOV _CX,CX
        MOV CX,TBL_LEN
        L2:       
            MOV _CX+2,CX
            CMP CX,_CX
            JE _2
            CALL CONCAT2
            CMP TBL_LEN,2
            JE _2
            MOV _CX+2,CX
            MOV CX,TBL_LEN
            L3:
                MOV _CX+4,CX
                CMP CX,_CX
                JE _3
                CMP CX,_CX+2
                JE _3
                CALL CONCAT3
                CMP TBL_LEN,3
                JE _3
                MOV _CX+4,CX
                MOV CX,TBL_LEN
                ;
                CALL L4L5
                ;
                MOV CX,_CX+4
            _3: LOOP L3
            MOV CX,_CX+2   
        _2: LOOP L2
        MOV CX,_CX
    _1: LOOP L1
        ;
        MOV PERM_LEN,DI
        LEA AX,PERM
        SUB PERM_LEN,AX
        ;
        CALL CREATE_FILE
        CALL WRITE_FILE
        CALL CLOSE_FILE
        
        ;------------
        LEA DX,MSG2
        CALL PRINT_MSG
        
        ;------------
        MOV AX,4C00H
        INT 21H
    MAIN ENDP 
    
    READ_WORDS PROC NEAR
        MOV CX,5 ;MAX 5 WORDS AS INPUT
    LP:
        MOV DI,5
        SUB DI,CX
        SHL DI,1
        CALL READ_WORD
        INC TBL_LEN
        CMP AL,13   ;IS_ENTER_KEY
        JE __RET
        CALL NL
        LOOP LP
    __RET:
        LEA DX,MSG3
        CALL PRINT_MSG
        RET
    READ_WORDS ENDP
    
    READ_WORD PROC NEAR
        PUSH CX
        MOV CX,15 ;LENGTH LIMITS 15 BYTES
        LEA BX,TBL
        ADD BX,LEN+DI
        READ_CHAR:
            MOV AH,01H
            INT 21H
            
            CMP AL,9   ;IS_TAB_KEY
            JE _BREAK
            CMP AL,13   ;IS_ENTER_KEY
            JE _BREAK
            
            MOV [BX],AL
            INC BX
            LOOP READ_CHAR
        _BREAK:
        POP CX
        RET
    READ_WORD ENDP

    
    ;---------------------------------
    ;
    L4L5 PROC NEAR
        L4:
            MOV _CX+6,CX
            CMP CX,_CX
            JE _4
            CMP CX,_CX+2
            JE _4
            CMP CX,_CX+4
            JE _4
            CALL CONCAT4
            CMP TBL_LEN,4
            JE _4
            MOV _CX+6,CX
            MOV CX,TBL_LEN
            L5:
                MOV _CX+8,CX
                CMP CX,_CX
                JE _5
                CMP CX,_CX+2
                JE _5
                CMP CX,_CX+4
                JE _5
                CMP CX,_CX+6
                JE _5
                CALL CONCAT5
            _5: LOOP L5
            MOV CX,_CX+6
        _4: LOOP L4
        RET
    L4L5 ENDP
    ;
    ;---------------------------------
    ;
    CONCAT2 PROC NEAR
        CALL GET_L1_WORD
        CALL COPYTO
        CALL GET_L2_WORD
        CALL COPYTO
        CALL NEW_WORD
        RET
    CONCAT2 ENDP
    
    CONCAT3 PROC NEAR
        CALL GET_L1_WORD
        CALL COPYTO
        CALL GET_L2_WORD
        CALL COPYTO
        CALL GET_L3_WORD
        CALL COPYTO
        CALL NEW_WORD
        RET
    CONCAT3 ENDP
    
    
    CONCAT4 PROC NEAR
        CALL GET_L1_WORD
        CALL COPYTO
        CALL GET_L2_WORD
        CALL COPYTO
        CALL GET_L3_WORD
        CALL COPYTO
        CALL GET_L4_WORD
        CALL COPYTO
        CALL NEW_WORD
        RET
    CONCAT4 ENDP
    
    CONCAT5 PROC NEAR
        CALL GET_L1_WORD
        CALL COPYTO
        CALL GET_L2_WORD
        CALL COPYTO
        CALL GET_L3_WORD
        CALL COPYTO
        CALL GET_L4_WORD
        CALL COPYTO
        CALL GET_L5_WORD
        CALL COPYTO
        CALL NEW_WORD
        RET
    CONCAT5 ENDP
    ;
    ;----------------------------
    ;
    GET_L1_WORD PROC NEAR

        MOV BX,TBL_LEN
        SUB BX,_CX
        SHL BX,1
        MOV SI,LEN+BX
        RET
    GET_L1_WORD ENDP
    
    GET_L2_WORD PROC NEAR
        MOV BX,TBL_LEN
        SUB BX,_CX+2
        SHL BX,1
        MOV SI,LEN+BX
        RET
    GET_L2_WORD ENDP
    
    GET_L3_WORD PROC NEAR
        MOV BX,TBL_LEN
        SUB BX,_CX+4
        SHL BX,1
        MOV SI,LEN+BX
        RET
    GET_L3_WORD ENDP

    GET_L4_WORD PROC NEAR
        MOV BX,TBL_LEN
        SUB BX,_CX+6
        SHL BX,1
        MOV SI,LEN+BX
        RET
    GET_L4_WORD ENDP
    
    GET_L5_WORD PROC NEAR
        MOV BX,TBL_LEN
        SUB BX,_CX+8
        SHL BX,1
        MOV SI,LEN+BX
        RET
    GET_L5_WORD ENDP
    ;
    ;----------------------------------------------
    ;
    COPYTO PROC NEAR
        LEA BX,TBL
        ONE_CHAR:
            MOV DL,[BX+SI]
            CMP DL,_$
            JE R
            MOV [DI],DL
            INC DI
            INC SI
            JMP ONE_CHAR
    R:
        RET
    COPYTO ENDP
    
    NEW_WORD PROC NEAR
        MOV [DI],BYTE PTR 0DH
        INC DI
        MOV [DI],BYTE PTR 0AH
        INC DI
        RET
    NEW_WORD ENDP

    ;------------------------
    
    CREATE_FILE PROC NEAR
        MOV AH, 3CH
        MOV CX,00
        LEA DX,PATH
        INT 21H
        MOV HANDLE,AX
        RET
    CREATE_FILE ENDP
    
    
    WRITE_FILE PROC NEAR
        MOV AH, 40H
        MOV BX,HANDLE
        MOV CX,PERM_LEN
        LEA DX,PERM
        INT 21H
        RET
    WRITE_FILE ENDP
    
    
    CLOSE_FILE PROC NEAR
        MOV AH, 3EH
        MOV BX,HANDLE
        INT 21H
        RET
    CLOSE_FILE ENDP
    ;
    ;------------------------------
    ;
    
    PRINT_MSG PROC NEAR 
        MOV AH,09H
        INT 21H
        RET
    PRINT_MSG ENDP
    NL PROC NEAR
        LEA DX,_NL
        MOV AH,09H
        INT 21H
        RET
    NL ENDP
    
    END MAIN
