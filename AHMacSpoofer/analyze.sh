#!/bin/bash
echo "Interface checks Initializing..."
i=0
> interface.txt  # Clear the file at the beginning

for interface in $(ls /sys/class/net); do
    if [ "$interface" = "lo" ]; then 
        continue
    fi
    ((i++))
    printf "%d: %s\n" "$i" "$interface" >> interface.txt
done
sleep 2
echo "Interface has been captured and directing to script..."
sleep 2
sudo chmod +x ./AHMacSpoofer/ahmacspoofer.sh
bash ./AHMacSpoofer/ahmacspoofer.sh
