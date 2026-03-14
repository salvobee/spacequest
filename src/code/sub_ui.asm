;============================================================
; UI Routines (Lives, Score, etc.)
;============================================================

;------------------------------------------------------------
; DrawLives
;------------------------------------------------------------
; Draws the current life count on the screen.
; Lives are shown on the 21st row (SCREEN_CHAR + 21*40).
; We use character 12 (L) and the number.
;------------------------------------------------------------
!zone DrawLives
DrawLives
    ; Position for lives: row 21, column 2
    ; SCREEN_CHAR + 21 * 40 + 2 = $CC00 + 840 + 2 = $CC00 + $0348 + 2 = $CF4A
    
    lda #67             ; Screen code for 'L' in expanded charset
    sta $CF4A
    
    lda #68             ; Screen code for '=' in expanded charset
    sta $CF4B
    
    lda LIVES           ; 0-5
    clc
    adc #69             ; '0' starts at 69 in expanded charset
    sta $CF4C
    
    ; Set colors (White = 1). Since we are in MC mode,
    ; color code < 8 means HIRES using background color and this color.
    lda #1
    sta $DF4A
    sta $DF4B
    sta $DF4C
    rts
