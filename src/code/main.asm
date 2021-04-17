
; Codice principale eseguito all'avvio del programma

; BNE branch se diverso da zero o da operando di confronto
; BEQ branch se uguale a zero o diverso

jsr disable_restore
jsr setup_init
jsr setup_irq
;setup_irq_nokrnl
;jsr init_sid
jmp *



GameLoop  
          jsr WaitFrame
          jsr PlayerControl
          jmp GameLoop


!zone WaitFrame
          ;wait for the raster to reach line $f8
          ;this is keeping our timing stable
          
          ;are we on line $F8 already? if so, wait for the next full screen
          ;prevents mistimings if called too fast
WaitFrame 
          lda $d012
          cmp #$F8
          beq WaitFrame

          ;wait for the raster to reach line $f8 (should be closer to the start of this line this way)
.WaitStep2
          lda $d012
          cmp #$F8
          bne .WaitStep2
          
          rts
		  
irq 
	inc $d020
	 jsr PlayerControl ; $0aa1
	 jsr checkplayerposition ; $0a51
	 ;jsr play_sid
	 dec $d020
	 dec $d019
	 jmp $ea31  

irq_nokrnl
		STA $fe
        LDA $DC0D
        STX $fc
        STY $fd
		inc $d020
		 jsr PlayerControl ; 0ad9
		 LDA #$01
        STA $D019
        LDY $fd
        LDX $fc
        LDA $fe
		dec $d020
        RTI
		 ;jsr play_sid
		 
		 ; dec $d019
		 ; jmp $ea31  

