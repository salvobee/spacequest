;============================================================
; Gestione limiti schermo, debug keyboard e cambio schermata
;============================================================
; Questo modulo si occupa di:
; - respawn del player se cade troppo in basso
; - scorciatoie tastiera (debug) per cambiare schermata
; - trigger automatico cambio schermata quando il player
;   raggiunge i bordi orizzontali

;------------------------------------------------------------
; checkplayerposition
;------------------------------------------------------------
; Se lo sprite del player supera Y=200, lo respawna.
; Poi processa input tastiera di debug.
checkplayerposition
	lda VIC_SPRITE_Y_POS
	cmp #200
	bcc .SkipRespawn

	; reset bit X esteso (riporta in area "normale")
	lda #0
	sta VIC_SPRITE_X_EXTEND

	jsr init_player

.SkipRespawn
	jmp check_keyboard


;------------------------------------------------------------
; init_player
;------------------------------------------------------------
; Posizione iniziale del player in coordinate tile (x=5,y=5).
init_player
	lda #5
	sta PARAM1
	lda #5
	sta PARAM2
	ldx #0
	jsr CalcSpritePosFromCharPos
	rts


;------------------------------------------------------------
; check_keyboard (debug)
;------------------------------------------------------------
; SPACE: respawn player
; D:     forza schermata precedente
; U:     forza schermata successiva
check_keyboard
	lda #%11111111
	sta CIA1_DDRA
	lda #%00000000
	sta CIA1_DDRB

check_space
	lda #%01111111
	sta CIA1_PRA
	lda CIA1_PRB
	and #%00010000
	beq init_player

check_d
	lda #%11111011
	sta CIA1_PRA
	lda CIA1_PRB
	and #%00000100
	beq loadscreen_left

check_u
	lda #%11110111
	sta CIA1_PRA
	lda CIA1_PRB
	and #%01000000
	beq loadscreen_right
	rts


;------------------------------------------------------------
; checkscreenscroll
;------------------------------------------------------------
; Trigger automatico cambio schermata ai bordi orizzontali.
checkscreenscroll
	lda VIC_SPRITE_X_POS
	cmp #$1E
	beq checkxextend_left
	cmp #$44
	beq checkxextend_right
	rts

checkxextend_left
	lda VIC_SPRITE_X_EXTEND
	bne loadscreen_left
	rts

checkxextend_right
	lda VIC_SPRITE_X_EXTEND
	bne loadscreen_right
	rts


;------------------------------------------------------------
; loadscreen_left / loadscreen_right
;------------------------------------------------------------
; Cambia indice schermata, ricostruisce mappa e ricolloca player.
loadscreen_left
	lda SCREEN_NR
	cmp #00
	bne move_leftscreen
	rts

move_leftscreen
	ldx SCREEN_NR
	dex
	stx SCREEN_NR
	jsr init_buildmap

	lda #39
	jsr RepositionPlayerOnScreenTransition
	rts


loadscreen_right

; Etichetta legacy usata da routine di bootstrap/debug.
debug1
	lda SCREEN_NR
	cmp #MAP_LEN
	bne move_rightscreen
	rts

move_rightscreen
	ldx SCREEN_NR
	inx
	stx SCREEN_NR
	jsr init_buildmap

	lda #08
	jsr RepositionPlayerOnScreenTransition
	rts


;------------------------------------------------------------
; RepositionPlayerOnScreenTransition
;------------------------------------------------------------
; Input:
;   A = nuova tile X del player (ingresso lato opposto)
; Effetti:
;   - mantiene la tile Y corrente
;   - inverte bit estensione X per coerenza VIC
;   - aggiorna coordinate sprite reali via routine centrale
RepositionPlayerOnScreenTransition
	sta PARAM1
	lda SPRITE_CHAR_POS_Y
	sta PARAM2
	ldx #0
	jsr ToggleSpriteXExtendForPlayer
	jsr CalcSpritePosFromCharPos
	rts


;------------------------------------------------------------
; ToggleSpriteXExtendForPlayer
;------------------------------------------------------------
; Toggle del bit 0 del registro X-extend sprite.
ToggleSpriteXExtendForPlayer
	lda VIC_SPRITE_X_EXTEND
	eor #%00000001
	sta VIC_SPRITE_X_EXTEND
	rts
