;============================================================
; Game Over Screen
;============================================================

!zone ShowGameOverAndWaitFire
ShowGameOverAndWaitFire
    lda #0
    sta GAME_STATUS
    ; Setup visual for Game Over
    jsr MenuPrepareVisuals ; Reuses the menu setup (hides sprites, text mode, clear screen)

    ; Draw GAME OVER text
    ; G=7, A=1, M=13, E=5, space=32, O=15, V=22, E=5, R=18
    ; GAME OVER = 7, 1, 13, 5, 32, 15, 22, 5, 18 (9 chars)
    
    lda #<GAMEOVER_TEXT
    sta ZEROPAGE_POINTER_1
    lda #>GAMEOVER_TEXT
    sta ZEROPAGE_POINTER_1+1
    lda #15             ; column
    sta PARAM1
    lda #12             ; row
    sta PARAM2
    lda #9              ; length
    sta PARAM3
    jsr MenuWriteTextAt

    ; Wait for FIRE
.WaitFire
    lda #$10
    bit $dc00
    bne .WaitFire

.WaitRelease
    lda #$10
    bit $dc00
    beq .WaitRelease

    rts

GAMEOVER_TEXT
    !byte 7, 1, 13, 5, 32, 15, 22, 5, 18
