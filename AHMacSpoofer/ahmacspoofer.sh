#!/bin/bash


# Read the interfaces from file into an array
mapfile -t interfaces < interface.txt

# Display options

echo "Available Interfaces:"
sleep 2
for line in "${interfaces[@]}"; do
    echo "$line"
	sleep 1
done

# Prompt user to select a number
read -p $'\n\e[1;93m Enter the number of the interface you want to select: \e[0m' choice

# Look up the selected line
selected_line=$(grep "^$choice:" interface.txt)

if [ -n "$selected_line" ]; then
    # Extract the interface name
    selected_interface=$(echo "$selected_line" | cut -d':' -f2 | xargs)
    echo "You selected: $selected_interface"
    # You can now use $selected_interface in your script
else
    echo "Invalid selection."
fi
# Make sure interface exists
if ! ip link show "$selected_interface" &>/dev/null; then
    echo "Interface '$selected_interface' not found."
    exit 1
fi


default_option="Y"
read -p $'\n\e[1;93m Do you want to Change MAC address Randomly [Default is Y] [Y/N]: \e[0m' option
option_interface="${option:-${default_option}}"
if [[ $option_interface == "Y" || $option_interface == "y" || $option_interface == "Yes" || $option_interface == "yes" ]]; then

		# Generate a random MAC address (locally administered, unicast)
		hexchars="0123456789ABCDEF"
		first_byte="02"  # binary: 00000010 → unicast + locally administered
		mac="$first_byte"

		for i in {1..5}; do
		    octet="${hexchars:$((RANDOM % 16)):1}${hexchars:$((RANDOM % 16)):1}"
		    mac+=":$octet"
		done
		echo "Generating MAC address..."
		sleep 3
		echo "Random MAC generated: $mac"
		sleep 2

		# Bring the interface down
		echo "Bringing the interface down."
		sleep 3
		sudo ifconfig "$selected_interface" down 
		echo "Interface  $selected_interface has been set down"
		sleep 1
		echo "Changing the MAC address..."
		sleep 3
		# Change the MAC address
		sudo ifconfig "$selected_interface" hw ether  "$mac" 
		echo "Mac address has been changed."
		sleep 1
		echo "Bringing the Interface back up..." 
		sleep 3
		# Bring the interface back up
		sudo ifconfig "$selected_interface" up 
		sleep 3
		# Confirm the MAC address change
		echo "MAC address for $selected_interface changed to $mac"
		sleep 2
		sudo ifconfig
		sleep 2

else

	while true; do
			# Prompt for new MAC address
			read -p $'\n\e[1;93m Enter the new MAC address (First digit should like this: 02:XX:XX:XX:XX:XX): \e[0m' new_mac
			sleep 2

			# Validate MAC address format
			if [[ "$new_mac" =~ ^([a-fA-F0-9]{2}:){5}[a-fA-F0-9]{2}$ ]]; then
				# Ensure the first byte isn't 00, as this could be invalid
				first_byte=$(echo "$new_mac" | cut -d: -f1)
					if [[ "$first_byte" == "00" ]]; then
						echo "❌ MAC address cannot start with 00: It is reserved for system use. Please try again."
					else
						break  # Exit loop if MAC address is valid
					fi
			else
				echo "❌ Invalid MAC address format. Please enter a MAC address like 00:11:22:33:44:55."
			fi	
	done

			# Bring the interface down
			echo "Bringing the interface down."
			sleep 3
			sudo ifconfig "$selected_interface" down
			echo "Interface  $selected_interface has been set down"
			sleep 1
			echo "Changing the MAC address..."
			sleep 3
			# Change the MAC address
			sudo ifconfig "$selected_interface" hw ether  "$new_mac"
			echo "Mac address has been changed."
			sleep 1
			echo "Bringing the Interface back up..." 
			sleep 3
			# Bring the interface back up
			sudo ifconfig "$selected_interface" up 
			sleep 3
			# Confirm the MAC address change
			current_mac=$(ip link show "$selected_interface" | grep -oP 'ether \K[[:xdigit:]:]{17}')
			echo "MAC address for $selected_interface changed to: $current_mac"
			sleep 2
			sudo ifconfig
			sleep 2
	

fi






		










			
