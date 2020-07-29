#!/bin/bash

PKGS=""

confirm() {
    # call with a prompt string or use a default
    read -r -p "${1:-Are you sure? [y/N]} " response
    case "$response" in
        [yY][eE][sS]|[yY]) 
            true
            ;;
        *)
            false
            ;;
    esac
}

checkpkg() {
    if [[ ! -e $1 ]] ; then
        PKGS="$PKGS $2"
    fi
}

checkpkg /usr/bin/git git
checkpkg /usr/bin/tmux tmux
checkpkg /usr/bin/vim vim

if [[ "${#PKGS}" -gt 0 ]]; then
    # check last apt update
    # https://askubuntu.com/questions/410247/how-to-know-last-time-apt-get-update-was-executed
    # https://stackoverflow.com/questions/19463334/how-to-get-time-since-file-was-last-modified-in-seconds-with-bash
    PKGCACHE=/var/cache/apt/pkgcache.bin
    TIME_DIFF=$(($(date +%s) - $(date +%s -r $PKGCACHE)))
    if [[ "${TIME_DIFF}" -gt 43200 ]] ; then
        echo
        echo "It's been >12 hours since apt update was ran."
        sudo apt-get update -y
    fi
    echo 
    echo "Installing packages $PKGS"
    sudo apt-get install -y $PKGS
else
    echo "- All packages already installed."
fi

if ! $(grep -q "dtoverlay=dwc2" /boot/config.txt); then
    echo "Setting up USB gadget mode"
    wget -O /tmp/rpi4-usb.sh https://raw.githubusercontent.com/kmpm/rpi-usb-gadget/master/rpi4-usb.sh
    chmod +x /tmp/rpi4-usb.sh
    /tmp/rpi4-usb.sh
else
    echo "- USB gadget mode already configured"
fi
