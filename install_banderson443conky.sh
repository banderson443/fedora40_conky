#!/bin/bash

echo "################################################################"
echo "Stopping conky's if available"
killall conky 2>/dev/null
sleep 1

### C H E C K I N G   E X I S T E N C E   O F   F O L D E R S ###
mkdir -p "$HOME/.config/autostart" "$HOME/.config/conky" "$HOME/.fonts"

### C L E A N I N G  U P  O L D  F I L E S ###
if find "$HOME/.config/conky" -mindepth 1 -print -quit | grep -q .; then
    echo "################################################################"
    read -rp "Everything in folder ~/.config/conky will be deleted. Are you sure? (y/n): " choice
    case "$choice" in 
        [yY]) rm -rf "$HOME/.config/conky/*" ;;
        [nN]) echo "No files have been changed in folder ~/.config/conky."; exit ;;
        *) echo "Invalid input. Script ended"; exit ;;
    esac
else
    echo "Installation folder is ready and empty. Files will now be copied."
fi

echo "################################################################"
echo "Copying files to ~/.config/conky."
cp -r * "$HOME/.config/conky/"

echo "################################################################"
echo "Ensuring conky autostarts next boot."
cp conky.desktop "$HOME/.config/autostart/start-conky.desktop"

### F O N T S ###
FONT="SourceSansPro-ExtraLight"
if ! fc-list | grep -iq "$FONT"; then
    echo "################################################################"
    echo "The font is not currently installed, would you like to install it now? (y/n)"
    read -r response
    if [[ "$response" =~ ^[yY]$ ]]; then
        echo "Installing the font to the ~/.fonts directory."
        cp "$HOME/.config/conky/fonts/*" "$HOME/.fonts"
        echo "Building new fonts into the cache files"
        fc-cache -fv "$HOME/.fonts"
        if fc-list | grep -iq "$FONT"; then
            echo "The font was successfully installed!"
        else
            echo "Something went wrong while trying to install the font."
        fi
    else
        echo "Skipping the installation of the font."
        echo "Please note that this conky configuration will not work correctly without the font."
    fi
fi

### S T A R T  O F  C O N K Y ###
echo "################################################################"
echo "Starting the conky"
conky -d -c "$HOME/.config/conky/LinuxLarge" 2>/dev/null

echo "################################################################"
echo "###################    T H E   E N D      ######################"
