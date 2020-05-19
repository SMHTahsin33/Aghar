#!/bin/bash

echo " "
echo "    ___         __              "
echo "   /   | ____ _/ /_  ____ ______"
echo "  / /| |/ __  / __ \/ __  / ___/"
echo " / ___ / /_/ / / / / /_/ / /    "
echo "/_/  |_\__, /_/ /_/\__,_/_/     "
echo "      /____/                    "
echo " 	   "
echo "[*] A tool for Active, Passive, Peramuted Subdomain Enumeration"
echo "[*] Coded By Mehedi Hasan Remon (@mehedi1194)"
echo " "

echo " "
echo "[*] Doing Passive Enumeration"
subenum -d $1 &>/dev/null
tfile=$1-$(date +'%Y-%m-%d').txt
massdns -r ~/Tool/massdns/lists/resolvers.txt -t A -o S $tfile -w $tfile.A2 &>/dev/null # set the path of your resolver.txt
cat $tfile.A2 | grep CNAME > $tfile.CNAME2
awk -F " " '{print $1;}' $tfile.A2 > $tfile.A3
awk -F " " '{print $1;}' $tfile.CNAME2 > $tfile.CNAME3
sed s/.$// $tfile.A3 | sort -u > $tfile.A
sed s/.$// $tfile.CNAME3 | sort -u > $tfile.CNAME

echo " "
echo "[*] Doing Active Enumeration"
python ~/Tool/massdns/scripts/subbrute.py ~/Desktop/all2.txt $1 >> $1.subbrute  # set the path of subbrute.py and all.txt
massdns -r ~/Tool/massdns/lists/resolvers.txt -t A -o S $1.subbrute -w $1.subbrute.A2 &>/dev/null   # set the path of your resolver.txt
cat $1.subbrute.A2 | grep CNAME > $1.subbrute.CNAME2
awk -F " " '{print $1;}' $1.subbrute.A2 > $1.subbrute.A3
awk -F " " '{print $1;}' $1.subbrute.CNAME2 > $1.subbrute.CNAME3
sed s/.$// $1.subbrute.A3 | sort -u > $1.subbrute.A
sed s/.$// $1.subbrute.CNAME3 | sort -u > $1.subbrute.CNAME


echo " "
echo "[*] Gathering Active & Passive subdomains"
cat $tfile.A $1.subbrute.A | sort -u > $1.active.passive

echo " "
echo "[*] Doing Permute Enumeration "
altdns -i $1.active.passive -o $1.permute.out -w ~/Tool/altdns/words.txt #set the path of AltDNS words.txt
massdns -r ~/Tool/massdns/lists/resolvers.txt -t A -o S $1.permute.out -w $1.permutation.resolved3 --flush &>/dev/null # set the path of your resolver.txt
cat $1.permutation.resolved3 | grep CNAME > $1.permutation.CNAME3
awk -F " " '{print $1;}' $1.permutation.resolved3 > $1.permutation.resolved2
awk -F " " '{print $1;}' $1.permutation.CNAME3 > $1.permutation.CNAME2
sed s/.$// $1.permutation.resolved2 > $1.permutation.resolve
sed s/.$// $1.permutation.CNAME2 > $1.permutation.CNAME

echo " "
echo "[*] Gathering Active Passive Peramuted Subdomains in one place"
cat $1.active.passive $1.permutation.resolve | sort -u > $1.final.resolved
cat $tfile.CNAME $1.subbrute.CNAME $1.permutation.CNAME | sort -u > $1.final.CNAME

echo " "
echo "[*] Removing all extra files"

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
echo "[*] Now i am done with Subdomain Enumeration Process"
echo "[*] Rest of all you have to do yourself"
echo "[*] Allah Hafiz"