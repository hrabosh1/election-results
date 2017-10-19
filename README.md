# Sledování průběžných výsledků voleb

Co je potřeba:

1. Mariadb
2. Bash (wget, iconv) 

Spustíte `./start.sh`. 

Při prvním spuštění se vás skript zeptá na heslo pro sudo, aby mohl vytvořit uživatele a DB a v mysql. 

## TODO

- [x] sehnat data
- [x] parsování dat
- [x] interpretace dat
- [ ] zobrazení dat
- [ ] doladit cyklus stahování dat

# popis

drtivá většina činnosti probíhá v databázových procedurách. Shell (nebo jakýkoliv jiný příkazový řádek) se stará pouze o stažení XML a jeho odeslání do databáze kde je soubor zpracován.
Toto řešení má výhodu v tom že je možné procedury spouštět bez jejich upravování (nastavování cest ke staženém xml) z libovolného adresáře a OS.
Nejprve je potřeba vytořit DB - jsou zde dva soubory, které obsahují statická data pro dané volby (názvy a čísla stran, jména kandidátů a jejich pořadí) a všechny procedury.
Pro nalití dynamických dat je potřeba spustit ImportData.sh (případně tímto skriptem inspirovanou variantu pro Win). Tento skript stáhne všechna potřebná data, nalije je do db a provede všechny přepočty. Skript je možné buď spouštět CRONem, nebo naznačeným nekonečným while cyklem s nastaveným sleep. Zdroj dat je aktualizován každou minutu, nemá smysl je tahat častěji.
Vystup.sh je jednoduchý skript, který zajišťuje základní textové cyklické vypisování dat do okna konzole.
Nad db může vzniknout libovolná aplikace, která se nijak nestará o vznik dat - pouze je zobrazuje. Všechna data jsou předem napočítávána, takže by db měla vydržet i relativně velkou zátěž.
