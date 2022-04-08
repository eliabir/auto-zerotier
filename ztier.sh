#!/bin/bash

# Colors
BLUE="\e[34m"
GREEN="\e[32m"
RED="\e[31m"
YELLOW="\e[1;33m"
ENDCOL="\e[0m"

# Check that script is running as root
if [[ $EUID != 0 ]]; then
	echo "Run script as root"
	exit 1
fi

# Load .env variables
export $(grep -v '^#' .env | xargs)

# Get ZeroTier network ID
NETWORK_ID=$(zerotier-cli listnetworks | sed -n '2 p' | awk '{print $3}')

NETWORK_NAME=$(zerotier-cli listnetworks | sed -n '2 p' | awk '{print $4}')

if [ -z $NETWORK_ID ]
then
	read -p "Join a network? (Y/n): " CHOICE

	if [ "$CHOICE" == "Y" ] || [ "$CHOICE" == "y" ] || [ -z $CHOICE ]
	then
		echo "Available networks:"
        	echo
        	echo "1. Elias_Network"

        	read -p "Connect to: " CHOICE

        	if [ $CHOICE -eq 1 ]
        	then
                	echo
			sudo zerotier-cli join $ELIAS_NETWORK; echo
		fi

	else
		echo "Goodbye!"
		exit 0
	fi	

else
	echo "Connected to  ${NETWORK_NAME} ${NETWORK_ID}"
	echo
	read -p "Leave network? (Y/n): " CHOICE
	if [ "$CHOICE" == "Y" ] || [ "$CHOICE" == "y" ] || [ -z $CHOICE ]
	then
		echo
		sudo zerotier-cli leave ${NETWORK_ID}; echo
	else
		echo "Goodbye!"
		exit 0
	fi

fi
