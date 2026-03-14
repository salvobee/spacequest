import os
import re
import sys

def converti_mappa(file_input, ui_def_file, file_output):
    """
    Legge un file .asm esportato da CharPad (Row-Major) e crea un nuovo file
    riordinato per l'engine, iniettando i caratteri UI.
    """
    if not os.path.exists(file_input):
        print(f"Errore: Il file '{file_input}' non esiste.")
        return
    if not os.path.exists(ui_def_file):
        print(f"Errore: Il file di definizione UI '{ui_def_file}' non esiste.")
        return

    # 1. Carichiamo il file originale CharPad
    with open(file_input, 'r') as f:
        content = f.read()

    # Normalizziamo .byte in !byte per ACME
    content = content.replace('.byte', '!byte')

    # 2. Carichiamo i caratteri UI
    with open(ui_def_file, 'r') as f:
        ui_lines = f.readlines()
    
    ui_bitmaps_raw = []
    ui_attribs_raw = []
    current_mode = None # 'bitmap' o 'attrib'

    for line in ui_lines:
        line = line.strip()
        if not line: continue
        if '_bitmap' in line:
            current_mode = 'bitmap'
        elif '_attrib' in line:
            current_mode = 'attrib'
        elif line.startswith('!byte'):
            # Estraiamo i valori coma-separated
            bytes_str = line.replace('!byte', '').strip()
            parts = [p.strip() for p in bytes_str.split(',') if p.strip()]
            if current_mode == 'bitmap':
                ui_bitmaps_raw.extend(parts)
            elif current_mode == 'attrib':
                ui_attribs_raw.extend(parts)

    # 3. Estraiamo dati originali CharPad
    def get_raw_bytes(label, end_label=None):
        start = content.find(label)
        if start == -1: return []
        # Iniziamo la ricerca dal primo !byte dopo la label
        data_start = content.find('!byte', start)
        if data_start == -1: return []
        
        if end_label:
            end_pos = content.find(end_label, start)
            if end_pos == -1 or end_pos < data_start: 
                section = content[data_start:]
            else: 
                section = content[data_start:end_pos]
        else:
            section = content[data_start:]
        
        matches = re.findall(r'!byte\s+([\$0-9a-fA-F, \n]+)', section)
        data = []
        for match in matches:
            # Rimuoviamo eventuali commenti se sfuggiti al regex (anche se ora non dovrebbero esserci)
            clean_match = match.split(';')[0]
            parts = [p.strip() for p in clean_match.split(',') if p.strip()]
            for p in parts:
                if p.startswith('$') or p.isdigit():
                    data.append(p)
        return data

    # 4. Estraiamo costanti
    def get_const(name):
        match = re.search(fr'{name}\s*=\s*(\d+)', content)
        return int(match.group(1)) if match else 0

    map_wid = get_const('MAP_WID')
    map_hei = get_const('MAP_HEI')
    tile_count = get_const('TILE_COUNT')
    char_count = get_const('CHAR_COUNT')
    num_screens = map_wid // 10

    # Caricamento e slicing RIGIDO dei dati originali
    # char_count * 8 -> Bitmap per carattere
    charset_raw = get_raw_bytes('charset_data', 'charset_attrib_data')[:char_count * 8]
    # 1 byte per attributo carattere
    attrib_raw = get_raw_bytes('charset_attrib_data', 'chartileset_data')[:char_count]
    # tileset data: TILE_COUNT * WID * HEI (di solito 4x4=16)
    tiles_raw = get_raw_bytes('chartileset_data', 'chartileset_tag_data')[:tile_count * 16]
    map_raw = get_raw_bytes('map_data')

    # 5. Ricalcoliamo costanti per l'engine
    new_char_count = char_count + (len(ui_bitmaps_raw) // 8)
    new_charset_size = len(charset_raw) + len(ui_bitmaps_raw)
    new_attrib_size = len(attrib_raw) + len(ui_attribs_raw)

    # 6. Riordiniamo la mappa (Row-Major to Screen-Major)
    # map_raw e' una lista di stringhe es: ['$05', '$05', ...]
    all_tiles = [int(t.replace('$', ''), 16) for t in map_raw[:map_wid * map_hei]]
    
    screens = []
    for s in range(num_screens):
        screen_tiles = []
        for r in range(map_hei):
            row_start = r * map_wid
            screen_tiles.extend(all_tiles[row_start + s*10 : row_start + s*10 + 10])
        screens.append(screen_tiles)

    # 7. Generazione file finale
    with open(file_output, 'w') as f:
        f.write("\n; --- MAPPA CONVERTITA AUTOMATICAMENTE ---\n")
        f.write("; Origine: " + file_input + "\n")
        f.write("; UI Def: " + ui_def_file + "\n\n")
        
        # Costanti engine
        f.write("MAP_LEN = " + str(num_screens) + "\n")
        f.write("SCREEN_PTR !byte 0\n")
        f.write("SCREEN_NR !byte 0\n\n")
        
        # Costanti originali aggiornate
        f.write("TRUE = 1\nFALSE = 0\nCOLRMETH_PERCHAR = 2\n")
        f.write("COLOURING_METHOD = COLRMETH_PERCHAR\n")
        f.write("CHAR_MULTICOLOUR_MODE = TRUE\n")
        f.write("COLR_SCREEN = 0\nCOLR_CHAR_DEF = 11\nCOLR_CHAR_MC1 = 14\nCOLR_CHAR_MC2 = 6\n\n")
        
        f.write(f"CHAR_COUNT = {new_char_count}\n")
        f.write(f"TILE_COUNT = {tile_count}\n")
        f.write(f"TILE_WID = 4\nTILE_HEI = 4\n")
        f.write(f"MAP_WID = {map_wid}\nMAP_HEI = {map_hei}\n\n")

        f.write(f"SZ_CHARSET_DATA        = {new_charset_size}\n")
        f.write(f"SZ_CHARSET_ATTRIB_DATA = {new_attrib_size}\n")
        f.write(f"SZ_TILESET_DATA        = {len(tiles_raw)}\n")
        f.write(f"SZ_MAP_DATA            = {len(all_tiles)}\n\n")

        f.write("ADDR_TILESET_DATA      = $2000\n\n")

        # Tabelle puntatori screens
        f.write("; Tabelle puntatori schermi\n")
        f.write("ADDR_MAP_DATA_TABLE_LO\n")
        f.write("!byte " + ",".join([f">MAP_SCR{i}" for i in range(num_screens)]) + "\n")
        f.write("ADDR_MAP_DATA_TABLE_HI\n")
        f.write("!byte " + ",".join([f"<MAP_SCR{i}" for i in range(num_screens)]) + "\n\n")

        # CHARSET
        f.write("; CHARSET IMAGE DATA\n")
        f.write("ADDR_CHARSET_DATA\ncharset_data\n")
        for i in range(0, len(charset_raw), 16):
            f.write("!byte " + ",".join(charset_raw[i:i+16]) + "\n")
        f.write("; --- UI CHARS ---\n")
        for i in range(0, len(ui_bitmaps_raw), 8):
            f.write("!byte " + ",".join(ui_bitmaps_raw[i:i+8]) + "\n")
        f.write("\n")

        # ATTRIBUTES
        f.write("; CHARSET IMAGE ATTRIBUTE DATA\n")
        f.write("ADDR_CHARSET_ATTRIB_DATA\ncharset_attrib_data\n")
        for i in range(0, len(attrib_raw), 16):
            f.write("!byte " + ",".join(attrib_raw[i:i+16]) + "\n")
        f.write("; --- UI ATTRIBS ---\n")
        f.write("!byte " + ",".join(ui_attribs_raw) + "\n\n")

        # TILESET
        f.write("; CHARTILESET DATA\n")
        f.write("* = ADDR_TILESET_DATA\nchartileset_data\n")
        for i in range(0, len(tiles_raw), 16):
            f.write("!byte " + ",".join(tiles_raw[i:i+16]) + "\n")
        f.write("\n")

        # MAP DATA
        f.write("; MAP DATA (Reordered)\nmap_data\n")
        for i, screen in enumerate(screens):
            f.write(f"\n; --- Screen {i} ---\nMAP_SCR{i}\n")
            for r in range(map_hei):
                row = screen[r*10 : r*10 + 10]
                f.write("!byte " + ",".join([f"${t:02x}" for t in row]) + "\n")

    print(f"Successo! Mappa convertita in: {file_output}")

if __name__ == "__main__":
    # Parametri: [input_asm] [ui_def_asm] [output_asm]
    if len(sys.argv) < 4:
        print("Uso: python reorder_map.py [input.asm] [ui_def.asm] [output.asm]")
        # DEFAULT per test rapido
        in_file = 'code/maps/spaceship.asm'
        ui_file = 'code/data_ui_charset_def.asm'
        out_file = 'code/data_map.asm'
        converti_mappa(in_file, ui_file, out_file)
    else:
        converti_mappa(sys.argv[1], sys.argv[2], sys.argv[3])
