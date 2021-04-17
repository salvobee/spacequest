!cpu 6502
!to "build/spr.prg", cbm

;============================================================
; caricamento simboli per locazioni di memoria comuni
;============================================================

!source "code/setup_symbols.asm"
!source "code/setup_macros.asm"


*=$0801

;SYS 2064
!byte $0C,$08,$0A,$00,$9E,$20,$32,$30,$36,$34,$00,$00,$00,$00,$00

!source "code/main.asm"

;============================================================
; routine di inizializzazione e setup eseguite all'inizio
;============================================================
!source "code/init_disablerestore.asm"
!source "code/init_setup.asm"
!source "code/init_setupirq.asm"
;!source "code/init_setupstableirq.asm"
!source "code/init_copycharset.asm"
!source "code/init_copysprite.asm"

;============================================================
; routine di gestione del programma
;============================================================
;!source "code/sub_inputcontrols.asm"
!source "code/sub_decodemap.asm"
!source "code/sub_screenhandler.asm"
!source "code/sub_spritehandler.asm"


;============================================================
; dati e tabelle
;============================================================

;!source "code/data_screenchars.s"
!source "code/data_screen.asm"
!source "code/data_spritevars.asm"
!source "code/data_map.asm"

;============================================================
; caricamento delle risorse esterne 
;============================================================

!source "code/load_resources.asm"