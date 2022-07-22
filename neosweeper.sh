#!/bin/bash

#Prompts the user for the first 3 octets of the network 
read -rp "Enter the target IP or Network: " TARGETIP 
STATIC=$( echo "$TARGETIP" | awk -F '.' '{print $1,$2,$3; }' | sed 's/\ /./g'). 
PWD="pwd | awk -F '/' '{print $NF}'" 

#Creates and navigates to a Neosweep directory to manage log files
if [ ! -d "Neosweep" ] && [ "$PWD" != "Neosweep" ]; then
	echo "Creating and navigating to Neosweep directory"
	mkdir Neosweep && cd ./Neosweep || exit
elif [ -d "Neosweep" ]; then
	cd ./Neosweep || exit
fi
	

echo "$TARGETIP" >> Target_list.txt
if [ "$(echo "$TARGETIP" | awk -F '.' '{print $4}')" = "0/24" ]; then
	echo "Commencing Network Sweep."
	sleep 1

#Performs a single ping to each IP in the network.
	echo "Commencing Shell Ping:"
	for OC4 in {1..254}; do
		ping -c 1 "$STATIC""$OC4" | grep "64 bytes" | cut -d " " -f 4 | tr -d ":" >> IP_list.txt &
	done
	echo "Shell Ping Complete."
	
#Performs an Fping scan on the network. Added in case anyone prefers this over another method.
	echo "Commencing Fping Scan:"
	fping -a -g "$STATIC"0/24 1>>IP_list.txt 2>/dev/null
	echo " " >> IP_list.txt &&echo "Fping Scan Complete."

	#Performs an Nmap ping sweep.
	echo "Commencing Nmap Scan:"
	nmap -sn "$STATIC"0/24 | grep "$STATIC" | cut -f 5- -d ' ' >> IP_list.txt
	echo "Nmap Scan Complete."
	sort IP_list.txt | uniq | sort -t . -k 4,4n | tee Target_list.txt
	rm IP_list.txt 
fi

#For loop for Port Scanning/Service Detection:

	awk '{print $1}' Target_list.txt | while read -r T; do
	nmap -sC -sV -v "$T" | sudo tee Nmap-First.txt	
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
nmap -sC -sV -vv -O -p- -iL Target_list.txt
read -rsp "Press [ENTER] to continue."