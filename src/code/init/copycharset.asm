;------------------------------------------------------------
;copies charset from ZEROPAGE_POINTER_1 to ZEROPAGE_POINTER_2
;------------------------------------------------------------

!zone CopyCharSet
CopyCharSet
	  ;set target address ($F000)
	  lda #$00
	  sta ZEROPAGE_POINTER_2
	  lda #$F0
	  sta ZEROPAGE_POINTER_2 + 1

	  ldx #$00
	  ldy #$00
	  lda #0
	  sta PARAM2

.NextLine
	  lda (ZEROPAGE_POINTER_1),Y
	  sta (ZEROPAGE_POINTER_2),Y
	  inx
	  iny
	  cpx #$08
	  bne .NextLine
	  cpy #$00
	  bne .PageBoundaryNotReached
	  
	  ;we've reached the next 256 bytes, inc high byte
	  inc ZEROPAGE_POINTER_1 + 1
	  inc ZEROPAGE_POINTER_2 + 1

.PageBoundaryNotReached

	  ;only copy 254 chars to keep irq vectors intact
	  inc PARAM2
	  lda PARAM2
	  cmp #254
	  beq .CopyCharsetDone
	  ldx #$00
	  jmp .NextLine

.CopyCharsetDone
	  rts
