!cpu 6502
!to "build/spr.prg", cbm

;============================================================
; caricamento simboli per locazioni di memoria comuni
;============================================================

!source "code/setup/symbols.asm"
!source "code/setup/macros.asm"


*=$0801

;SYS 2064
!byte $0C,$08,$0A,$00,$9E,$20,$32,$30,$36,$34,$00,$00,$00,$00,$00

!source "code/main.asm"

;============================================================
; routine di inizializzazione e setup eseguite all'inizio
;============================================================
!source "code/init/disablerestore.asm"
!source "code/init/setup.asm"
!source "code/init/setupirq.asm"
;!source "code/init/setupstableirq.asm"
!source "code/init/copycharset.asm"
!source "code/init/copysprite.asm"

;============================================================
; routine di gestione del programma
;============================================================
;!source "code/sub/inputcontrols.asm"
!source "code/sub/decodemap.asm"
!source "code/sub/startmenu.asm"
!source "code/sub/screenhandler.asm"
!source "code/sub/gameover.asm"
!source "code/sub/spritehandler.asm"
!source "code/sub/ui.asm"


;============================================================
; dati e tabelle
;============================================================

;!source "code/data/screenchars.s"
!source "code/data/screen.asm"
!source "code/data/spritevars.asm"
!source "code/data/gamevars.asm"
!source "code/data/map.asm"

;============================================================
; caricamento delle risorse esterne 
;============================================================

!source "code/load_resources.asm"
