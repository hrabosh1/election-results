conn='mysql --user=elections --password=elections -D elections2013';

c=1
while [ $c -le 2 ]
do
    

    clear
    echo " "
    echo " "
    echo "                                         ---  Získané mandáty  ---"
    echo " "
    echo " "

    $conn -e "SELECT * FROM v_StranyPrehledMandaty;" 

    echo "  "
    echo "  "
    echo "             ---  nalodění Piráti  ---"
    echo "  "
    echo "  "


    $conn -e "SELECT * FROM v_PiratiMandaty;"

    sleep 5

    clear
    echo " "
    echo " "
    echo "                                                         ---  Relativní podíly  ---"
    echo " "
    echo " "


    $conn -e  "SELECT * FROM v_StranyPrehledPodily" 

    echo "  "
    echo "  "
    echo "             ---  nalodění Piráti  ---"
    echo "  "
    echo "  "


    $conn -e  "SELECT * FROM v_PiratiMandaty;"
    
    sleep 5
   # (( c++ ))
done