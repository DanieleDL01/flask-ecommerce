# Procedura per installare e avviare il progetto

## 1. Installare le dipendenze

È necessario avere Python e PostgreSQL installati. Aprire un terminale nella cartella del progetto.

### macOS/Linux

```bash
python3 -m venv venv
source venv/bin/activate
python -m pip install -r requirements.txt
```

### Windows

```powershell
py -m venv venv
.\venv\Scripts\Activate.ps1
python -m pip install -r requirements.txt
```

## 2. Configurare il database

1. Aprire **pgAdmin 4** e connettersi al proprio server PostgreSQL.
2. Creare un nuovo database chiamato `ShopData`.
3. Importare i dati dal file `database.sql`, fornito con il progetto.

Se `database.sql` è un normale script SQL in formato testo, aprire il database `ShopData` in pgAdmin, selezionare **Tools → Query Tool**, aprire il file ed eseguirlo.

In alternativa, dal terminale si può eseguire:

```bash
psql -U tuo_utente -d ShopData -f database.sql
```

Sostituire `tuo_utente` con il nome dell'utente PostgreSQL utilizzato localmente.

**Nota:** se il file è un backup PostgreSQL in formato Custom o Tar, utilizzare invece la funzione **Restore** di pgAdmin.

## 3. Avviare il progetto

Con l'ambiente virtuale attivo, eseguire:

```bash
python run.py
```

Il sito sarà disponibile all'indirizzo:

http://127.0.0.1:5000/

## Note

- Non è necessario caricare la cartella `venv` nel repository: viene creata localmente seguendo le istruzioni sopra.
- Assicurarsi che la configurazione dell'applicazione utilizzi il database PostgreSQL locale `ShopData` e le credenziali corrette.
