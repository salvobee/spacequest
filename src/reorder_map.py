
import re
import sys
import os

def converti_mappa(file_input):
    """
    Legge un file .asm esportato da CharPad (Row-Major) e crea un nuovo file
    con i dati ordinati per Schermate (Screen-Major) richiesti dall'engine.
    """
    if not os.path.exists(file_input):
        print(f"Errore: Il file '{file_input}' non esiste.")
        return

    # 1. Carichiamo il file originale esportato
    with open(file_input, 'r') as f:
        content = f.read()

    # 2. Rileviamo le dimensioni (MAP_WID e MAP_HEI)
    wid_match = re.search(r'MAP_WID\s*=\s*(\d+)', content)
    hei_match = re.search(r'MAP_HEI\s*=\s*(\d+)', content)
    
    if not wid_match or not hei_match:
        print("Errore: Impossibile trovare MAP_WID o MAP_HEI nel file.")
        return

    map_wid = int(wid_match.group(1))
    map_hei = int(hei_match.group(1))
    num_screens = map_wid // 10

    # 3. Estraiamo i dati grezzi della mappa
    map_start = content.find('map_data')
    if map_start == -1:
        print("Errore: Label 'map_data' non trovata.")
        return
        
    # Cerchiamo tutte le righe che contengono dati byte
    map_lines = re.findall(r'(?:\.byte|!byte)\s+(.*)', content[map_start:])
    all_tiles = []
    for line in map_lines:
        tiles = line.replace('$', '').split(',')
        all_tiles.extend([int(t, 16) for t in tiles if t.strip()])

    expected_tiles = map_wid * map_hei
    if len(all_tiles) < expected_tiles:
        print(f"Attenzione: Trovati solo {len(all_tiles)} tile, ne servirebbero {expected_tiles}.")
    
    all_tiles = all_tiles[:expected_tiles]

    # 4. Riordiniamo i dati: l'engine vuole 50 byte per lo Schermo 0, poi dello Schermo 1, ecc.
    screens = []
    for s in range(num_screens):
        screen_tiles = []
        for r in range(map_hei):
            row_start = r * map_wid
            # Prendiamo i 10 tile della riga 'r' appartenenti allo schermo 's'
            screen_tiles.extend(all_tiles[row_start + s*10 : row_start + s*10 + 10])
        screens.append(screen_tiles)

    # 5. Generiamo il file di OUTPUT (Risultato)
    # Creiamo un nome basato sull'input, es: 'data_map_ship.asm' -> 'data_map_ship_CONVERTITO.asm'
    nome_base = os.path.splitext(file_input)[0]
    file_output = nome_base + "_CONVERTITO.asm"

    output = []
    output.append(f"; --- MAPPA CONVERTITA PER SPACEQUEST ---")
    output.append(f"; Generata da: {file_input}")
    output.append(f"MAP_LEN = {num_screens}\n")
    
    output.append("; Tabelle puntatori (Convenzione Engine: _LO=High, _HI=Low)")
    output.append("ADDR_MAP_DATA_TABLE_LO")
    output.append("!byte " + ",".join([f">MAP_SCR{i}" for i in range(num_screens)]))
    output.append("ADDR_MAP_DATA_TABLE_HI")
    output.append("!byte " + ",".join([f"<MAP_SCR{i}" for i in range(num_screens)]))
    output.append("\nmap_data")

    for i, screen in enumerate(screens):
        output.append(f"; --- Schermata {i} ---")
        output.append(f"MAP_SCR{i}")
        for r in range(map_hei):
            line_tiles = screen[r*10 : r*10 + 10]
            output.append("!byte " + ",".join([f"${t:02x}" for t in line_tiles]))

    with open(file_output, 'w') as f_out:
        f_out.write("\n".join(output))
    
    print(f"Successo! Il file convertito e pronto all'uso e: {file_output}")

if __name__ == "__main__":
    # Come si usa?
    # python reorder_map.py [nome_file_export_charpad.asm]
    if len(sys.argv) > 1:
        file_da_elaborare = sys.argv[1]
    else:
        file_da_elaborare = r'code/data_map_ship.asm'
        
    converti_mappa(file_da_elaborare)
