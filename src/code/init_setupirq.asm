setup_irq

	;sei					; set up interrupt
	lda #$7f
	sta $dc0d			; turn off the CIA interrupts
	sta $dd0d
	and $d011			; clear high bit of raster line
	sta $d011		

	ldy $80				; trigger on first scan line
	sty $d012

	lda #<irq		; load interrupt address
	ldx #>irq
	sta $0314
	stx $0315

	lda #$01 			; enable raster interrupts
	sta $d01a
	;cli
	rts					; back to BASIC

setup_irq_nokrnl
	SEI
	LDA #$35
	STA $01          ;Switch off the KERNAL ROM via value #$35
	LDA #$01
	STA $D01A
	LDA #<irq_nokrnl
	LDX #>irq_nokrnl        
	LDY #$80
	STA $FFFE
	STX $FFFF
	STY $D012
	LDA #$1B
	STA $D011
	LDA #$7F
	STA $DC0D
	LDA $DC0D
	CLI
	rts
		
disable_irq
	sei 		; disabilita interrupt
	lda #$ea    
	sta $0315 
	lda #$31 
	sta $0314 
	lda #$81 
	sta $dc0d 
	lda #0 
	sta $d01a 
	inc $d019 
	lda $dc0d  
	cli
