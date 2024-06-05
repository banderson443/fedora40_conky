# this little batch file will autostart conky
# and copy the configuration file to the standard place
# where conky looks for a configuration file
# Lua syntax!!


# killing whatever conkies are still working
echo "################################################################"
echo "Stopping conky's if available"


killall conky 2>/dev/null
sleep 1

##################################################################################################################
###################### C H E C K I N G   E X I S T E N C E   O F   F O L D E R S            ######################
##################################################################################################################



# if there is no hidden folder autostart then make one
[ -d $HOME"/.config/autostart" ] || mkdir -p $HOME"/.config/autostart"

# if there is no hidden folder conky then make one
[ -d $HOME"/.config/conky" ] || mkdir -p $HOME"/.config/conky"

# if there is no hidden folder fonts then make one
[ -d $HOME"/.fonts" ] || mkdir -p $HOME"/.fonts"

##################################################################################################################
######################              C L E A N I N G  U P  O L D  F I L E S                    ####################
##################################################################################################################

# removing all the old files that may be in ./config/conky with confirm deletion



if [ "$(ls -A ~/.config/conky)" ] ; then

	echo "################################################################"
	read -p "Everything in folder ~/.config/conky will be deleted. Are you sure? (y/n)?" choice

	case "$choice" in 
 	 y|Y ) rm -r ~/.config/conky/*;;
 	 n|N ) echo "No files have been changed in folder ~/.config/conky." & echo "Script ended!" & exit;;
 	 * ) echo "Type y or n." & echo "Script ended!" & exit;;
	esac

else
	echo "################################################################" 
	echo "Installation folder is ready and empty. Files will now be copied."

fi

echo "################################################################" 
echo "The files have been copied to ~/.config/conky."
# the standard place conky looks for a config file
cp -r * ~/.config/conky/

echo "################################################################" 
echo "Making sure conky autostarts next boot."
# making sure conky is started at boot
cp conky.desktop ~/.config/autostart/start-conky.desktop


##################################################################################################################
########################                           F O N T S                            ##########################
##################################################################################################################



echo "################################################################" 
echo "Installing the fonts if you do not have it yet - with choice"

FONT="SourceSansPro-ExtraLight"


if fc-list | grep -i $FONT >/dev/null ; then

	echo "################################################################" 
    echo "The font is already available. Proceeding ...";

else
	echo "################################################################" 
    echo "The font is not currently installed, would you like to install it now? (y/n)";
    read response
    if [[ "$response" == [yY] ]]; then
        echo "Installing the font to the ~/.fonts directory.";
        cp ~/.config/conky/fonts/* ~/.fonts
        echo "################################################################" 
        echo "Building new fonts into the cache files";
        echo "Depending on the number of fonts, this may take a while..." 
        fc-cache -fv ~/.fonts
		echo "################################################################" 
		echo "Check if the cache build was successful?";    
        if fc-list | grep -i $FONT >/dev/null; then
            echo "################################################################" 
            echo "The font was sucessfully installed!";
        else
        	echo "################################################################" 
            echo "Something went wrong while trying to install the font.";
        fi
    else
    	echo "################################################################" 	
        echo "Skipping the installation of the font.";
        echo "Please note that this conky configuration will not work";
        echo "correctly without the font.";
    fi

fi


##################################################################################################################
########################                    S T A R T  O F  C O N K Y                   ##########################
##################################################################################################################

echo "################################################################"
echo "Starting the conky"
echo "################################################################"

#starting the conky 
conky -d -c ~/.config/conky/LinuxLarge 2>/dev/null

echo "################################################################"
echo "###################    T H E   E N D      ######################"
echo "################################################################"
