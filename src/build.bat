bin\acme index.asm
pause
bin\exomizer sfx basic build\spr.prg -o build\sprite.prg
REM c1541 -attach diskimage\diskimage.d64 -delete sprite -write build\sprite.prg sprite
pause
REM x64sc build\sprite.prg

pause