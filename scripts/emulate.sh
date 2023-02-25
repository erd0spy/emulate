#!/bin/bash

welcome() {
    RED='\033[0;31m'
    NC='\033[0m'
    echo -e "
    ${RED}
            ▓█████  ███▄ ▄███▓ █    ██  ██▓    ▄▄▄     ▄▄▄█████▓▓█████ 
            ▓█   ▀ ▓██▒▀█▀ ██▒ ██  ▓██▒▓██▒   ▒████▄   ▓  ██▒ ▓▒▓█   ▀ 
            ▒███   ▓██    ▓██░▓██  ▒██░▒██░   ▒██  ▀█▄ ▒ ▓██░ ▒░▒███   
            ▒▓█  ▄ ▒██    ▒██ ▓▓█  ░██░▒██░   ░██▄▄▄▄██░ ▓██▓ ░ ▒▓█  ▄ 
            ░▒████▒▒██▒   ░██▒▒▒█████▓ ░██████▒▓█   ▓██▒ ▒██▒ ░ ░▒████▒
            ░░ ▒░ ░░ ▒░   ░  ░░▒▓▒ ▒ ▒ ░ ▒░▓  ░▒▒   ▓▒█░ ▒ ░░   ░░ ▒░ ░
             ░ ░  ░░  ░      ░░░▒░ ░ ░ ░ ░ ▒  ░ ▒   ▒▒ ░   ░     ░ ░  ░
               ░   ░      ░    ░░░ ░ ░   ░ ░    ░   ▒    ░         ░   
               ░  ░       ░      ░         ░  ░     ░  ░           ░  ░
    ${NC}
    "
}

help() {
    echo -e "
    Usage:
        sudo ./emulate.sh firmware_file
    "
    exit 1
}

argumentcheck() {
    # Check firmware_file is provided
    if [ -z "$1" ]; then
        help
    fi
}

set_id() {
    for i in {0..1000};     
    do         
        if [ -f "$firmadyne_path/images/$i.tar.gz" ];         
        then
            continue      
        else         
            echo $i;             
            break;         
        fi;     
    done; 
}

extractor() {
    echo "[*] Extracting firmware"
    tag=$(sudo -- $firmadyne_path/sources/extractor/extractor.py -np -nk $firmware_name $firmadyne_path/images/ | grep "Tag:" | awk '{print $3;exit}')
    sudo mv $firmadyne_path/images/$tag.tar.gz $firmadyne_path/images/$id.tar.gz
    tar_file=$firmadyne_path/images/$id.tar.gz
    if [ -f "$tar_file" ]; then
        echo -e "\t* Extracted firmware successfully"
    else
        echo -e "\tFirmware extraction failed"
        exit
    fi
}

getArch() {
    echo "[*] Getting architecture..."
    arch=$(sudo -- scripts/getArch.sh $tar_file | grep "./bin/busybox: " | awk '{print $2}')
}

makeImage() {
    echo "[*] Building QEMU disk image..."
    sudo -- $firmadyne_path/scripts/makeImage.sh $id $arch > /dev/null 2>&1
}

inferNetwork() {
    echo "[*] Setting up the network connection..."
    interface=$(sudo -- scripts/inferNetwork.sh $id $arch | grep "Interfaces:")
    echo -e "\t$interface"
}

run() {
    echo "[*] Press any key to run QEMU"
    read -n 1 -s
    echo "[*] Running QEMU..."
    sudo -- scratch/$id/run.sh
}

main() {
    firmadyne_path="$(pwd)/firmadyne"

    argumentcheck $1
    welcome
    
    firmware_name="$(pwd)/$1"
    id=$(set_id)
    
    cd $firmadyne_path
    extractor $id 
    getArch 
    makeImage $id
    inferNetwork $id
    run $id
}

main $1