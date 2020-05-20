#!/bin/bash
# USING ANSI COLORS
Gcyan="\e[0;49;33m"
Cyan="\e[0;49;36m"
STOP="\e[0m"
#COLOUR DECLARATION END
#INTRO STARTED
echo -e "${Gcyan}"
echo " "
echo "    ___         __              "
echo "   /   | ____ _/ /_  ____ ______"
echo "  / /| |/ __  / __ \/ __  / ___/"
echo " / ___ / /_/ / / / / /_/ / /    "
echo "/_/  |_\__, /_/ /_/\__,_/_/     "
echo "      /____/                    "
echo -e "${STOP}"
echo -e "${Cyan}"
echo "[*] A Tool for Active, Passive and Permuted Subdomain Enumeration"
echo "[*] Coded By Mehedi Hasan Remon (@mehedi1194)"
echo -e "${STOP}"
#INTRO ENDS
echo "  "
echo -e "${Gcyan}[*] Doing Passive Enumeration${STOP}"
subenum -d $1 &>/dev/null
tfile=$1-$(date +'%Y-%m-%d').txt
massdns -r ~/Tool/massdns/lists/resolvers.txt -t A -o S $tfile -w $tfile.A2 &>/dev/null # set the path of your resolver.txt
cat $tfile.A2 | grep CNAME > $tfile.CNAME2
awk -F " " '{print $1;}' $tfile.A2 > $tfile.A3
awk -F " " '{print $1;}' $tfile.CNAME2 > $tfile.CNAME3
sed s/.$// $tfile.A3 | sort -u > $tfile.A
sed s/.$// $tfile.CNAME3 | sort -u > $tfile.CNAME

echo " "
echo -e "${Gcyan}[*] Doing Active Enumeration${STOP}"
python ~/Tool/massdns/scripts/subbrute.py ~/Desktop/all2.txt $1 >> $1.subbrute  # set the path of subbrute.py and all.txt
massdns -r ~/Tool/massdns/lists/resolvers.txt -t A -o S $1.subbrute -w $1.subbrute.A2 &>/dev/null   # set the path of your resolver.txt
cat $1.subbrute.A2 | grep CNAME > $1.subbrute.CNAME2
awk -F " " '{print $1;}' $1.subbrute.A2 > $1.subbrute.A3
awk -F " " '{print $1;}' $1.subbrute.CNAME2 > $1.subbrute.CNAME3
sed s/.$// $1.subbrute.A3 | sort -u > $1.subbrute.A
sed s/.$// $1.subbrute.CNAME3 | sort -u > $1.subbrute.CNAME


echo " "
echo -e "${Gcyan}[*] Gathering Active & Passive Subdomains${STOP}"
cat $tfile.A $1.subbrute.A | sort -u > $1.active.passive

echo " "
echo -e "${Gcyan}[*] Doing Subdomain Permutation Enumeration${STOP}"
altdns -i $1.active.passive -o $1.permute.out -w ~/Tool/altdns/words.txt #set the path of AltDNS words.txt
massdns -r ~/Tool/massdns/lists/resolvers.txt -t A -o S $1.permute.out -w $1.permutation.resolved3 --flush &>/dev/null # set the path of your resolver.txt
cat $1.permutation.resolved3 | grep CNAME > $1.permutation.CNAME3
awk -F " " '{print $1;}' $1.permutation.resolved3 > $1.permutation.resolved2
awk -F " " '{print $1;}' $1.permutation.CNAME3 > $1.permutation.CNAME2
sed s/.$// $1.permutation.resolved2 > $1.permutation.resolve
sed s/.$// $1.permutation.CNAME2 > $1.permutation.CNAME

echo " "
echo -e "${Gcyan}[*] Gathering Active & Passive Permuted Subdomains Together${STOP}"
cat $1.active.passive $1.permutation.resolve | sort -u > $1.final.resolved
cat $tfile.CNAME $1.subbrute.CNAME $1.permutation.CNAME | sort -u > $1.final.CNAME

echo " "
echo -e "${Gcyan}[*] Removing all extra files${STOP}"

rm $tfile
rm $tfile.A
rm $tfile.A2
rm $tfile.A3
rm $1.subbrute
rm $tfile.CNAME
rm $tfile.CNAME2
rm $tfile.CNAME3
rm $1.subbrute.A
rm $1.permute.out
rm $1.subbrute.A3
rm $1.subbrute.A2
rm $1.subbrute.CNAME
rm $1.active.passive
rm $1.subbrute.CNAME2
rm $1.subbrute.CNAME3
rm $1.permutation.CNAME
rm $1.permutation.CNAME3
rm $1.permutation.CNAME2
rm $1.permutation.resolve
rm $1.permutation.resolved2
rm $1.permutation.resolved3 

echo " "
echo -e "${Cyan}"
echo "[*] Subdomain Enumeration Process Completed"
echo "[*] Rest Of The Processing Has To Be Done Manually"
echo "[*] Allah Hafiz"
echo -e "${STOP}"
