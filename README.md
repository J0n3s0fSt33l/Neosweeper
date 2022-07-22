# Neosweeper: Thorough ping sweeping and Nmap output beautifier 

## A thorough pingsweeper utilizing the built-in ping utility native to Linux, the Fping utility, and Nmap with the -sn flag. 
This tool will run each sweep and append the results to an IP_list.txt file. When all 3 are done, the tool will filter the .txt file for 
each unique entry and both display the found IP's as well as format and save them to Target_list.txt, which will be reformatted so can be used as an input for other utilities, such as `nmap -iL`.
A quick Nmap scan will then run, the result cleaned to present a simple and understandable output so you can start deciding on enumerating further.
Meanwhile, a full port nmap scan will run to ensure we are being thorough.
## The Future
Ultimately I plan on adding more tools to the script and try to make this a 1 stop shop for basic enumeration (i.e. run `smbclient` on the target if port 445 is open and running SMB to get a list of shares and print the contents of the shares if possible.)

##### Backstory to this script
While using the INE Labs to prepare for the eJPT I experienced an issue with a ping sweep not catching a target, which led to me beating my head against a wall until I decided to look up a writeup and realized that after the fourth sweep I confirmed it existed. I decided to utilize different methods of ping sweeping, saving the output to a file and using `uniq` to give me a clean list of targets as well the option of being able to pass that file to Nmap.
