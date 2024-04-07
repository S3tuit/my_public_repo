# Librerie in uso nel codice
import os
import shutil
import csv
import sys

def get_files_data(file, path, map_type):
    '''
    Ottiene name, size, raw_type, type di ogni file.

    files: lista di nome_file.estensione
    path: percorso (str) dove sono situati i file
    map_type: dizionario mappare tipi file a nome. mp3->audio
    '''

    files_data = {'name':[], 'raw_type':[], 'size':[], 'type':[]}

    file_path = os.path.join(path, file)

    # Controllo file non è una directory o recap.csv
    if os.path.isfile(file_path) and file!='recap.csv':

        size = os.path.getsize(file_path)
        name, extens = os.path.splitext(file)
            
        if size and name and extens: # Per essere sicuro che i dati esistono
            files_data['name'].append(name)
            files_data['size'].append(size)
            files_data['raw_type'].append(extens)
            good_type = 'None' # Nel caso non c'è l'estensione del file, append 'None'

            for f_type in map_type.keys():
                if extens in map_type[f_type]:
                    good_type = f_type
                    break
            files_data['type'].append(good_type)

        else:
            print(f'Missing data for {file}!')

    return files_data # Pandas-style


def move_files(files_data, path, map_dir, verbose=True):
    '''
    Sposta i file in una sub-directory in base al type.

    files_data: dizionario stile Pandas. Ogni key-value pair e' una colonna
    path: percorso (str) dove sono situati i file
    map_dir: dizionario mappare file alla cartella. audio->audios
    verbose: stampa diverse info su ogni file se True
    '''

    for idx in range(len(files_data['name'])): # Accedere ad ogni file
        dir_name = None
        for name in map_dir.keys(): # Ottenere nome sub-directory
            if files_data['type'][idx] in map_dir[name]:
                dir_name = name

        dir_path = path + '/' + dir_name
        if not os.path.exists(dir_path): # Verifica esistenza sub-directory
            os.makedirs(dir_path)
        
        # Sposta il file
        curr_path = path + '/' + files_data['name'][idx] + files_data['raw_type'][idx]
        new_path = dir_path + '/' + files_data['name'][idx] + files_data['raw_type'][idx]
        shutil.move(curr_path, new_path)

        if verbose: # stampa i dati del singolo file
            name = files_data['name'][idx]
            file_type = files_data['type'][idx]
            size = files_data['size'][idx]
            print(f'{name} type:{file_type} size:{size}B')


def get_recap(files_data, path):
    '''
    Crea un file csv con le info dei files.

    files_data: dizionario stile Pandas. Ogni key-value pair e' una colonna
    path: percorso (str) dove si vuole salvare il file csv
    name: nome del file csv senza estensione
    '''

    file_path = os.path.join(path, "recap.csv")

    # Verifica se il file esiste già
    mode = 'a' if os.path.exists(file_path) else 'w'

    # Se recap non esiste, lo crea. Altrimenti aggiunge le info
    with open(file_path, mode, newline='') as csvfile:
        fieldnames = ['name', 'type', 'size (B)']
        writer = csv.DictWriter(csvfile, fieldnames=fieldnames)

        if mode == 'w':
            writer.writeheader()

        # Scriviamo i dati dei file nel CSV
        for i in range(len(files_data['name'])):
            writer.writerow({
                'name': files_data['name'][i],
                'type': files_data['type'][i],
                'size (B)': files_data['size'][i]
            })


def main():

    # Controlla il numero di argomenti passati
    if (args_count := len(sys.argv)) > 2:
        print(f"Specifica un solo argomento, non {args_count - 1}.")
        raise SystemExit(2)
    elif args_count < 2:
        print("Specifica un argomento.")
        raise SystemExit(2)

    path = './files'
    file_path = os.path.join(path, sys.argv[1])

    # Controlla la validita' del file passato
    if not os.path.exists(file_path):
        print(f"Il file {sys.argv[1]} non esiste.")
        raise SystemExit(1)
    elif os.path.isdir(file_path):
        print(f"Il file {sys.argv[1]} e' una cartella. Impossibile spostarla.")
        raise SystemExit(1)
    elif sys.argv[1] == 'recap.csv':
        print('Impossibile spostare il file recap.csv')
        raise SystemExit(1)
    
    files_data = {'name':[], 'raw_type':[], 'size':[], 'type':[]}

    map_type = {
        'audio': {'.mp3', '.wav', '.flac'},
        'doc': {'.txt', '.odt', '.doc', '.docx', '.pdf'},
        'image': {'.jpg', '.jpeg', '.png', '.gif', '.bmp', '.svg'},
        'video': {'.mp4', '.avi', '.mov', '.mkv', '.wmv'}
    }

    map_dir = {
        'audios': {'audio'},
        'docs': {'doc'},
        'images': {'image'},
        'videos': {'video'}
    }

    # Aggiornamento del recap
    files_data = get_files_data(sys.argv[1], path, map_type)
    move_files(files_data, path, map_dir)
    get_recap(files_data, path)

if __name__ == '__main__':
    main()