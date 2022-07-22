# Neosweeper: Thorough ping sweeping and Nmap output beautifier 

## A thorough pingsweeper utilizing the built-in ping utility native to Linux, the Fping utility, and Nmap with the -sn flag. 
This tool will run each sweep and append the results to an IP_list.txt file. When all 3 are done, the tool will filter the .txt file for 
each unique entry and both display the found IP's as well as format and save them to Target_list.txt, which will be reformatted so can be used as an input for other utilities, such as nmap -iL.

A quick Nmap scan will then run, the result cleaned to present a simple and understandable output so you can start deciding on enumerating further.
meanwhile, a full port nmap scan will run to ensure we are being thorough. 

##### Probably a little overboard, but I wanted to be thorough before taking my eJPT certification. During my time preparing using INE I
found my self in a predicament that a pingsweep I had run in one of the labs (I think it was with nmap but can't recall) missed a single target, 
complicating the practice module I was doing. I decided to put together this little script as a tool to prevent that from happening again.
