CODE    SEGMENT BYTE PUBLIC 'CODE'
        ASSUME CS:CODE,DS:CODE

IF1
        %OUT    EGA.CPI creation file
        %OUT    .
        %OUT    CP SRC files:
        %OUT    .
        %OUT    .       CODE PAGE:  667
ENDIF

EGA667: DW     LEN_667                  ; SIZE OF ENTRY HEADER
        DW     POST_EGA667,0            ; POINTER TO NEXT HEADER
        DW     1                        ; DEVICE TYPE
        DB     "EGA     "               ; DEVICE SUBTYPE ID
        DW     667                      ; CODE PAGE ID
        DW     3 DUP(0)                 ; RESERVED
        DW     OFFSET DATA667,0         ; POINTER TO FONTS
LEN_667 EQU    ($-EGA667)               ;
                                        ;
DATA667:DW     1                        ; CART/NON-CART
        DW     3                        ; # OF FONTS
        DW     LEN_D667                 ; LENGTH OF DATA
D667:                                   ;
        DB     16,8                     ; CHARACTER BOX SIZE
        DB     0,0                      ; ASPECT RATIO (UNUSED)
        DW     256                      ; NUMBER OF CHARACTERS
                                        ;
        INCLUDE 667-8X16.ASM            ;
                                        ;
        DB     14,8                     ; CHARACTER BOX SIZE
        DB     0,0                      ; ASPECT RATIO (UNUSED)
        DW     256                      ; NUMBER OF CHARACTERS
                                        ;
        INCLUDE 667-8X14.ASM            ;
                                        ;
        DB     8,8                      ; CHARACTER BOX SIZE
        DB     0,0                      ; ASPECT RATIO (UNUSED)
        DW     256                      ; NUMBER OF CHARACTERS
                                        ;
        INCLUDE 667-8X8.ASM             ;
                                        ;
LEN_D667        EQU ($-D667)            ;
                                        ;
POST_EGA667     EQU     $               ;
                                        ;
CODE    ENDS                            ;
        END                             ;
