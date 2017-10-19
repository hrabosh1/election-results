
#!/usr/bin/env bash

conn='mysql --user=elections --password=elections -D elections2013'

CRUrl=https://volby.cz/pls/ps2013/vysledky
CRSoubor=vysledky

HlasyUrl=https://volby.cz/pls/ps2013/vysledky_kandid
HlasySoubor=vysledky_kandid

function firstRun() {
	if $conn -e "SHOW databases;"; then
		echo "Mysql ok"
	else	
		echo "No mysql, create..."
		sudo mysql < create.sql
		$conn < parseXml.sql
	fi;
}


function updateData() {

    # import celkových výsledků
    rm "$CRSoubor"
    wget "$CRUrl"

    iconv -f CP1250 -t utf8 "$CRSoubor" | tail -n +2 > CRInput.xml

    $conn -e "call ParseXml('$(cat CRInput.xml)')"
    
    
    # import preferenčních hlasů

    # celé xml je příliš velké a není ho možné předat v příkazové řádce
    # xml je proto rozděleno podle krajů a ty jsou zpracovávány postupně
    rm "$HlasySoubor"
    wget "$HlasyUrl"
    iconv -f CP1250 -t utf8 "$HlasySoubor" | tail -n +2 > RawHlasyInput.xml 
    
    # dva soubory jsou možná divné, ale nemám rád státo pipe, kde každá dělá něco jiného
    cat RawHlasyInput.xml | tr '\n' ' ' | sed 's/<\/KRAJ>/&\
    /g' | sed 's/<KRAJ /\
    &/g' > HlasyInput.xml

    # zpracování po jednotlivých krajích
    while read KrajXml; do
        
        if [ ${#KrajXml} -gt 10000 ]; then #alespoň nějaký test; když se do procedury nacpe nesmysl, tak nenajde node KRAJ a nic neudálá
            ## aktualizace počtu hlasů pro jednotlivé kandidáty a aktualizace počtu odevzdaných hlasů v jednotlivých krajích
            $conn -e "call ParseKrajXml('$(echo $KrajXml)')" ;
        fi
    
    done < HlasyInput.xml
    
    # seřazení kandidátů a označení kandidátů s mandátem
    $conn -e "call SeradKandidatyPodlePreferenci();  call OznacZvoleneKandidaty(); call  SpocitejStranyPrehled()"; # přepočet preferencí by měl být před výběrem zvolených poslanců
}


c=1
while [ $c -le 1 ]
do
    updateData
    #sleep 60
    (( c++ ))
done






rm vysledky
wget https://volby.cz/pls/ps2013/vysledky 
iconv -f CP1250 -t utf8 vysledky | tail -n +2 > input.xml 
mysql --user=elections --password=elections -D elections -e "call ParseXml('$(cat input.xml)')"

   
