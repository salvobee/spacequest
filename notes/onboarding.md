# SpaceQuest — Onboarding rapido

Questa nota serve per riprendere il progetto senza dover ricostruire tutto da zero.

## Flusso di esecuzione

1. `src/index.asm` imposta CPU/output, crea lo stub BASIC `SYS 2064` e include i moduli in questo ordine:
   - simboli/macros
   - `code/main.asm`
   - routine di init (`init_*`)
   - routine gameplay (`sub_*`)
   - dati (`data_*`)
   - risorse esterne (`load_resources.asm`)
2. In `code/main.asm` all'avvio vengono chiamate:
   - `disable_restore`
   - `setup_init`
   - `setup_irq`
3. La logica frame/gameplay gira in IRQ (`irq`):
   - `PlayerControl`
   - `checkplayerposition`

## Moduli principali da ricordare

- `code/init_setup.asm`
  - configura VIC/sprite/charset
  - copia charset e sprite in RAM
  - inizializza livello e posizione player (`resetplayerpos`)
- `code/init_setupirq.asm`
  - installa handler raster IRQ (`irq`) o variante `irq_nokrnl`
- `code/sub_spritehandler.asm`
  - input joystick + movimento player
  - salto/gravità/caduta
  - movimento orizzontale e controllo scroll
- `code/sub_screenhandler.asm`
  - gestione schermo corrente e scorrimento tra schermate
- `code/sub_decodemap.asm`
  - decodifica mappa multi-schermo

## Piano consigliato (micro-step)

1. **Stabilire baseline**: build + run in emulatore e verifica input base (sinistra/destra/salto).
2. **Strumentazione minima**: usare il border color (`$d020`) in 2-3 punti critici per misurare tempi/ordine chiamate.
3. **Collisioni verticali**: rivedere prima la caduta (gravità), poi il salto.
4. **Scroll/screen transition**: consolidare edge case su cambio schermata.
5. **Pulizia**: rinominare etichette criptiche e aggiungere commenti mirati.

## Checklist di debug utile

- Se il gioco sembra "fermo": controllare che l'IRQ sia installato e che `$d01a` abbia raster IRQ attivo.
- Se input non risponde: verificare lettura joystick in `PlayerControl` (`$dc00`).
- Se il player attraversa piattaforme: verificare routine verticali in `sub_spritehandler.asm` e lookup mappa in `sub_decodemap.asm`.
- Se lo schermo non cambia correttamente: verificare `checkscreenscroll`/screen handler e indice `SCREEN_NR`.

## Nota pratica

Il repo contiene toolchain storica Windows (`build.bat`, ACME/Exomizer). Per lavorare più veloce oggi conviene aggiungere uno script di build multipiattaforma (step successivo proposto).
