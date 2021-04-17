bin\acme index.asm
pause
bin\exomizer sfx basic build\spr.prg -o build\sprite.prg
REM c1541 -attach diskimage\diskimage.d64 -delete sprite -write build\sprite.prg sprite
pause
rem ..\..\Emu\WinVICE-3.1-x86\x64 build\sprite.prg
rem x64 build\sprite.prg