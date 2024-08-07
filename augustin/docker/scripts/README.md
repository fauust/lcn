# Tools in here
## Trouble Schooting
I made a shell script [script](trouble_tools/NetworkScan.sh) to trouble shoot networks. It takes an ip range as argument and scans all the IPs in the range to test if the ports in the [file](trouble_tools/port.txt) respond. It saves 3 files with lists of adresses , ports and the services answering on them.

I use it to trouble shoot VM's networks, see wich ports are opened. There is probably an existing tool to do this but i am proud of this one.

As a matter of fact i found out that several students in the room have a lot of services opened and accessible on the local network such as ssh-server on port 22, monitoring interfaces and PHP-myAdmin without authentification.

