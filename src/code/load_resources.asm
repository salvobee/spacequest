;CHARSET
	;!binary "resources/j.chr"
  
SPRITES
  ;!binary "resources/astronaut.spr",1024,3
  !binary "resources/newsprites.spr",4096,3
  
*=$3Fa0
; $0B18
lda #<debug1
lda #>debug1
brk
; $0FD2
lda #<ADDR_MAP_DATA_TABLE_LO
lda #>ADDR_MAP_DATA_TABLE_LO
brk
; $2000
lda #<ADDR_TILESET_DATA
lda #>ADDR_TILESET_DATA
brk
; $1273
lda #<MAP_SCR0
lda #>MAP_SCR0
brk
; $12A5
lda #<MAP_SCR1
lda #>MAP_SCR1
brk
; $12D7
lda #<MAP_SCR2
lda #>MAP_SCR2
brk
; $1309
lda #<MAP_SCR3
lda #>MAP_SCR3