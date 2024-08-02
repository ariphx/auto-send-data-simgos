#!/bin/bash
clear
# Warna
RESET='\033[0m'
BOLD='\033[1m'
UNDERLINE='\033[4m'
BLACK='\033[0;30m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[0;37m'

# Daftar URL yang akan dikunjungi
urls=(
    "http://192.168.1.4/webservice/kemkes/ihs/encounter/send"
    "http://192.168.1.4/webservice/kemkes/ihs/medication/send"
    "http://192.168.1.4/webservice/kemkes/ihs/observation/send"
    "http://192.168.1.4/webservice/kemkes/ihs/procedure/send"
    "http://192.168.1.4/webservice/kemkes/ihs/condition/send"
)

# Fungsi untuk menampilkan informasi URL
function visit_url() {
    local url=$1

    # Menggunakan curl untuk mendapatkan status code dan waktu respons
    response=$(curl -s -w "HTTP_STATUS:%{http_code} TIME_TOTAL:%{time_total}\n" -o /tmp/response_content.txt "$url")

    # Menampilkan URL dan hasil status
    echo -e "${RED}Visiting ${WHITE}$url${RESET}"
    echo -e "${RED}HTTP Status Code: ${RESET}$(echo "$response" | grep 'HTTP_STATUS' | cut -d':' -f2)"
    echo -e "${RED}Total Time: ${RESET}$(echo "$response" | grep 'TIME_TOTAL' | cut -d':' -f2) seconds"

    # Menampilkan bagian awal dari konten
    echo -e "${RED}Content :${RESET}"
    head -c 500 /tmp/response_content.txt
    echo -e "\n${RESET}---------------------------------------------${RESET}\n"
}

# Banner dan Menu
function show_banner() {
    echo -e "  _______________________"
    echo -e "< Auto Finish Data SIMGOS >"
    echo -e "  -----------------------"
    echo -e "         \   ^__^ "
    echo -e "          \  (oo)\_______"
    echo -e "             (__)\       )\/\\    ${BOLD}- \e[4;38;5;190mCode by arip${RESET} -"
    echo -e "                 ||----w |"
    echo -e "                 ||     ||"
    echo -e ""
    echo -e ""
    echo -e "1. Start		${BOLD}${RED}2. Exit${RESET}"
    echo " "
}

# Menampilkan Banner dan Memilih Menu
function menu() {
    local choice
    show_banner

    read -p " >> " choice

    case $choice in
        1)
            echo -e "${RESET}"
            
            # Proses Kunjungan Pertama
            echo -e "${RED}		      ${UNDERLINE}Memulai Proses visit${RESET}${RED}...${RESET}"
	    echo ""
            for url in "${urls[@]}"; do
                visit_url "$url"
                echo ""
                sleep 1
            done
            
            # Proses Kunjungan Ulang
            echo -e "${RED}                   ${UNDERLINE}Memulai Pengulangan Proses visit${RESET}${RED}...${RESET}"
            echo ""
	    for url in "${urls[@]}"; do
                visit_url "$url"
                echo ""
                sleep 1
            done
            ;;
        2)
            echo -e "${RED}Exiting...${RESET}"
            exit 0
            ;;
        *)
            echo -e " >> ${RED}Invalid${RESET}"
            sleep 1
            clear
            menu
            ;;
    esac
}

# Menjalankan Menu
menu

