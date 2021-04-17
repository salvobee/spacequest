disable_restore:
	lda #<patch_02a
	sta $0328
	lda #>patch_02a
	sta $0329
	lda #<patch_02b
	sta $fffa
	lda #>patch_02b
	sta $fffb
	rts
	
patch_02a:
    lda #$ff
    sec
    rts
patch_02b:
    rti