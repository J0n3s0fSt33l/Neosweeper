#Neosweeper: Thorough ping sweeping and Nmap output beautifier 

A thorough pingsweeper utilizing built-in ping utility native to Linux, the Fping utility, and Nmap's -sn flag. 
This tool will run each sweep and append the results to IP_list.txt. When all 3 are done, the tool will filter the .txt file for 
each unique entry and both display the found IP's as well save it to Target_list.txt, which will be reformatted so you can use as an input for 
other utilities, such as nmap -iL.

##Probably a little overboard, but I wanted to be thorough before taking my eJPT certification. During my time preparing using INE I
found my self in a predicament that a pingsweep I had run in one of the labs (I think it was with nmap but can't recall) missed a single target, 
complicating the practice module I was doing.I decided to put together this little script as a tool to prevent that from happening again.

##But it didn't stop there. After realizing Nmap was always going to be run after a ping sweep, I decided "why not?" and added an nmap scan to the script. 
this will do the basic -sC and -sV flags and clean up the output a little for simplified reading. At the end the script will output the ports and services
identified in a simple and clean format so you can start analyzing the data, while beginning a full port nmap scan on your target(s)
