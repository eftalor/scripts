#!/bin/bash 
#Script for updating GeoIP on a bunch of web servers. 
#Downloads to local server and copies to web servers
#Needs geoip packages installed

rm /tmp/geoipupdate.out
/usr/bin/geoipupdate > /tmp/geoipupdate.out

grep "GeoIP Database up to date" /tmp/geoipupdate.out
GEOOUT=`tail -3 /tmp/geoipupdate.out`
echo $GEOOUT

if [[ $GEOOUT == *"up to date"* ]] 
then
  echo "MaxMind GeoIP is up to date, skipping update!";  exit 0
else
#For easy distinction ,define var per environment
NODESENV1="mc-fed1 mc-fed2 mc-fed3 mc-stg-fed1 tc-fed1 tc-fed2 tc-fed3 tc-fed4 tc-fed5 tc-fed6 tc-fed7 tc-stg-fed1 tc-stg-fed2"
NODESENV2="dapp10 dapp12 dapp13 dapp14"
NODESENV2="rcapp1 rcapp2 rcapp3 rcapp4 rcapp5 rcapp6 rcapp7 rcapp8 rcapp9 rcapp10 rcapp11 rcapp12 rcapp13 rcapp14  rcapp19 rcapp20 rcapp21 rcapp22 rcapp23 rcapp24 rcapp25 rcapp26 rcapp27 rcapp28"

#one var to rule them all
NODESALL=`echo ${NODESENV1} ${NODESENV2}`
NODESNORESTART="counter1 counter2 counter3" 

echo "Updating GeoIP and restarting Apache"
for NODE in $NODESALL
do
echo "----Updating node: $NODE----"
echo "Time is: `date`"
scp /usr/share/GeoIP/GeoIP*.dat $NODE:/usr/share/GeoIP/ ; ssh $NODE "/etc/init.d/apache2 restart"
sleep 30
done

echo "Updating GeoIP on counter nodes"
for COUNTERNODE in $NODESNORESTART
do
echo "----Updating node: $COUNTERNODE----"
echo "Time is: `date`"
scp -i ~/.ssh/andris.pem /usr/share/GeoIP/GeoIP*.dat $COUNTERNODE:/usr/share/GeoIP/
sleep 30
done


fi

