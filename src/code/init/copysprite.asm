!zone CopySprites
CopySprites
	ldy #$00
	ldx #$00

	lda #00
	sta ZEROPAGE_POINTER_2
	lda #$d0
	sta ZEROPAGE_POINTER_2 + 1

	;4 sprites per loop
.SpriteLoop
	lda (ZEROPAGE_POINTER_1),y
	sta (ZEROPAGE_POINTER_2),y
	iny
	bne .SpriteLoop
	inx
	inc ZEROPAGE_POINTER_1+1
	inc ZEROPAGE_POINTER_2+1
	cpx #NUMBER_OF_SPRITES_DIV_4
	bne .SpriteLoop

	rts