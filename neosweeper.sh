#!/bin/bash

#Prompts the user for the first 3 octets of the network 
read -rp "Enter the target IP or Network:" targetip
static=$( echo "$targetip" | awk -F '.' '{print $1,$2,$3; }' | sed 's/\ /./g'). 
pwd="pwd | awk -F '/' '{print $NF}'" 

#Creates and navigates to a Neosweep directory to manage log files
if [ ! -d "Neosweep" ] && [ "$pwd" != "Neosweep" ]; then
	echo "Creating and navigating to Neosweep directory"
	mkdir Neosweep && cd ./Neosweep || exit
elif [ -d "Neosweep" ]; then
	cd ./Neosweep || exit
fi
	

echo "$targetip" >> Target_list.txt
if [ "$(echo "$targetip" | awk -F '.' '{print $4}')" = "0/24" ]; then
	echo "Commencing Network Sweep."

#Performs a single ping to each IP in the network.
	echo "Commencing Shell Ping:"
	for oc4 in {1..254}; do
		ping -c 1 "$static""$oc4" | grep "64 bytes" | cut -d " " -f 4 | tr -d ":" >> IP_list.txt &
	done
	echo "Shell Ping Complete."
	
#Performs an Fping scan on the network. Added in case anyone prefers this over another method.
	echo "Commencing Fping Scan:"
	fping -a -g "$static"0/24 1>>IP_list.txt 2>/dev/null
	echo " " >> IP_list.txt && echo "Fping Scan Complete."

#Performs an Nmap ping sweep.
	echo "Commencing Nmap Scan:"
	nmap -sn "$static"0/24 | grep "$static" | cut -f 5- -d ' ' >> IP_list.txt
	echo "Nmap Scan Complete."
	sort -u IP_list.txt | sort -t . -k 4,4n | tee Target_list.txt
	rm IP_list.txt 
fi

#For loop for Port Scanning/Service Detection:
awk '{print $1}' Target_list.txt | while read -r t; do
	nmap -sC -sV -v "$t" | sudo tee Nmap-First.txt	
	grep "open " < Nmap-First.txt | sed 's/[^.0-9][^.0-9]*/ /g' | awk '{print $1}' >> Open-ports.txt-temp
	grep "open " < Nmap-First.txt > Services.txt-temp && echo " " >> Services.txt-temp
done

#Cleanup logs
sort Services.txt-temp | sed '/Discovered/d' | sort -n | uniq > Services.txt
sort -n Open-ports.txt-temp | uniq > Open-ports.txt && rm Services.txt-temp Open-ports.txt-temp
clear
echo "The following services were discovered: "
cat Services.txt
echo
printf "Port Scan Results:\n"
cat Open-ports.txt
echo
echo "Start going through the data while a full port Nmap scan runs."
nmap -sC -sV -vv -O -p- -oN Nmap-full.txt -iL Target_list.txt
read -rsp "Press [ENTER] to continue."
