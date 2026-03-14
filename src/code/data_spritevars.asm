;============================================================
; Variabili e tabelle di stato sprite/player
;============================================================
; Nota: manteniamo i nomi storici per compatibilità con il codice
; esistente, ma aggiungiamo alias "parlanti" per rendere il sorgente
; più leggibile durante studio e refactor.

;address of sprite pointers
SPRITE_POINTER_BASE     = SCREEN_CHAR + 1016

;number of sprites divided by four
NUMBER_OF_SPRITES_DIV_4 = 32

;sprite number constant
SPRITE_BASE             = 64
SPRITE_PLAYER           = SPRITE_BASE + 0

;offset from calculated char pos to true sprite pos
SPRITE_CENTER_OFFSET_X  = 8
SPRITE_CENTER_OFFSET_Y  = 13

;entries of jump table
JUMP_TABLE_SIZE         = 10

;entries of fall table
FALL_TABLE_SIZE         = 10

;------------------------------------------------------------
; Alias leggibili (non cambiano layout in RAM)
;------------------------------------------------------------
PLAYER_JUMP_INPUT_READY = UPRELEASED
PLAYER_JUMP_PHASE       = PLAYER_JUMP_POS
PLAYER_FALL_PHASE       = PLAYER_FALL_POS
PLAYER_PIXEL_X          = SPRITE_POS_X
PLAYER_PIXEL_Y          = SPRITE_POS_Y
PLAYER_CHAR_X           = SPRITE_CHAR_POS_X
PLAYER_CHAR_Y           = SPRITE_CHAR_POS_Y
PLAYER_CHAR_X_OFFSET    = SPRITE_CHAR_POS_X_DELTA
PLAYER_CHAR_Y_OFFSET    = SPRITE_CHAR_POS_Y_DELTA
PLAYER_X_EXTEND_MASK    = SPRITE_POS_X_EXTEND
ANIM_FRAME_INDEX        = PLY1_ANMT_CURFRAME
ANIM_DIRECTION          = PLY1_DIR
ANIM_FRAME_DELAY        = PLY1_ANMT_DLY

;------------------------------------------------------------
; Stato input/salto
;------------------------------------------------------------
; 1 = pulsante SU rilasciato (possibile nuovo salto)
; 0 = pulsante SU già consumato, attende rilascio
UPRELEASED !byte 01

; indice corrente della curva di salto
PLAYER_JUMP_POS
          !byte 0

; profilo di salto: quanti pixel risalire a frame, fase per fase
PLAYER_JUMP_TABLE
          !byte 8,8,8,8,8,4,2,1,0,0

; indice corrente della curva di caduta
PLAYER_FALL_POS
          !byte 0

; profilo di accelerazione in caduta (gravità semplificata)
FALL_SPEED_TABLE
          !byte 1,1,2,2,3,3,3,3,3,3

;------------------------------------------------------------
; Stato geometrico sprite (8 sprite totali)
;------------------------------------------------------------
SPRITE_POS_X
          !byte 0,0,0,0,0,0,0,0
SPRITE_POS_X_EXTEND
          !byte 0
SPRITE_CHAR_POS_X
          !byte 0,0,0,0,0,0,0,0
SPRITE_CHAR_POS_X_DELTA
          !byte 0,0,0,0,0,0,0,0
SPRITE_CHAR_POS_Y
          !byte 0,0,0,0,0,0,0,0
SPRITE_CHAR_POS_Y_DELTA
          !byte 0,0,0,0,0,0,0,0
SPRITE_POS_Y
          !byte 0,0,0,0,0,0,0,0

; maschera bit per selezionare sprite N nei registri VIC condivisi
BIT_TABLE
          !byte 1,2,4,8,16,32,64,128

;------------------------------------------------------------
; Stato animazione player 1
;------------------------------------------------------------
PLY1_ANMT_CURFRAME
          !byte 0

; 0 = fermo/non deciso, 1 = sinistra, 2 = destra
PLY1_DIR
          !byte 0

; countdown frame per rallentare l'animazione
PLY1_ANMT_DLY
          !byte 4

PLY1_ANMT_MVRGT_SIZE = 8
PLY1_ANMT_MVRGT
          !byte 64,66,68,70,72,74,76,78
          !byte 112,114,116,118,120,122,124,126

PLY1_ANMT_MVLFT_SIZE = 8
PLY1_ANMT_MVLFT
          !byte 80,82,84,86,88,90,92,94
