#!/bin/bash

function jumpto
{
    label=$1
    cmd=$(sed -n "/$label:/{:a;n;p;ba};" $0 | grep -v ':$')
    eval "$cmd"
    exit
}

start=${1:-"start"}

jumpto $start

pacman="pacman"
dnf="dnf"
emerge="emerge"
zypp="zypp"
apt="apt-get"

declare -A osInfo;
osInfo[/etc/redhat-release]=dnf
osInfo[/etc/arch-release]=pacman
osInfo[/etc/gentoo-release]=emerge
osInfo[/etc/SuSE-release]=zypp
osInfo[/etc/debian_version]=apt-get

for f in ${!osInfo[@]}
do
    if [[ -f $f ]];then
        echo Package manager Found !: ${osInfo[$f]}
        if [[ "${osInfo[$f]}" = "$pacman" ]] ;then
        	start:
            	echo ********** APP LIST **********
            	echo "1> nvidia Drivers"
            	echo "2> Desktop Environment/ Window Manager"
            	echo "3> Login/Display Manager"
            	echo "4> Multimedia Apps (Audio/Video)"
            	echo "5> Development Tools (Build Tools + Languages)"
            	echo "6> Productivity Apps"
            	echo "7> Terminal setup"
            	echo "8> Exit"
            	read input1
            
            	if [[ "$input1" -eq 1 ]] ;then
            		echo -e "\e[31m IMPORTANT NOTE: Do not install nvidia drivers if you are using virtual machine without nvidia gpu passthrough which is only available in Desktop. \e[0m"
            		echo -e "\e[32m If you are using this on laptop/Desktop without virtual machine you are safe to install it. \e[0m"
            		echo -e "\e[37m \e[0m"
			sudo pacman -S nvidia-lts nvidia-utils nvidia-settings
            		cd /etc/
            		sudo cp mkinitcpio.conf mkinitcpiobackup.conf
            		sed -i '/MODULES/c\MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)' mkinitcpio.conf
            		sudo mkinitcpio -P
            		jumpto start
            	elif [[ "$input1" -eq 2 ]] ;then
                	echo ********** Desktop Environments **********
            		echo "1> Gnome"
            		echo "2> KDE"
            		echo "3> Cinnamon"
            		echo "4> Deepin"
            		echo "5> LXQT"
            		echo "6> Mate"
            		echo "7> XFCE"
            		echo "8> i3"
            		echo "9> bspwm"
            		echo "10> awesome"
            		read deinput
         
			if [[ "$deinput" -eq 1 ]] ;then
				echo GNOME Desktop Environmment Installation
				sudo pacman -S gnome --noconfirm
				echo -e "\e[32m Install Display Manager (Recommended GDM) \e[0m"
				echo -e "\e[37m \e[0m"
				jumpto dmmenu
		
			elif [[ "$deinput" -eq 2 ]] ;then
				echo "KDE Desktop Environment Installation"
				sudo pacman -S sddm --noconfirm
				sudo pacman -S --needed plasma kde-applications-meta --noconfirm
				echo -e "\e[32m Install Display Manager (Recommended SDDM) \e[0m"
				echo -e "\e[37m \e[0m"
				jumpto dmmenu
			elif [[ "$deinput" -eq 3 ]] ;then
				echo "Cinnamon Desktop Environment Installation"
				sudo pacman -S cinnamon --noconfirm
				sudo pacman -S cinnamon-settings-daemon
				echo -e "\e[32m Install Display Manager (Recommended Lightdm/GDM) \e[0m"
				echo -e "\e[37m \e[0m"
				jumpto dmmenu
			elif [[ "$deinput" -eq 4 ]] ;then
				echo "Deepin Desktop Environment Installation"
				sudo pacman -S --needed deepin deepin-extra
				echo -e "\e[32m Install Display Manager (Recommended Lightdm) \e[0m"
				echo -e "\e[37m \e[0m"
				jumpto dmmenu
			elif [[ "$deinput" -eq 5 ]] ;then
				echo "LXQT Desktop Environment Installation"
				sudo pacman -S lxqt
				echo -e "\e[32m Install Display Manager (Recommended Lightdm) \e[0m"
				echo -e "\e[37m \e[0m"
				jumpto dmmenu
			elif [[ "$deinput" -eq 6 ]] ;then
				echo "Mate Desktop Environment Installation"
				sudo pacman -S mate
				echo -e "\e[32m Install Display Manager (Recommended Lightdm) \e[0m"
				echo -e "\e[37m \e[0m"
				jumpto dmmenu
			elif [[ "$deinput" -eq 7 ]] ;then
				echo "XFCE Desktop Environment Installation"
				sudo pacman -S xfce4
				echo -e "\e[32m Install Display Manager (Recommended Lightdm) \e[0m"
				echo -e "\e[37m \e[0m"
				jumpto dmmenu
			elif [[ "$deinput" -eq 8 ]] ;then
				echo "i3 Window Manager Installation"
				sudo pacman -S i3-gaps i3lock i3status-rust
				echo -e "\e[32m Install Display Manager (Recommended Lightdm) \e[0m"
				echo -e "\e[37m \e[0m"
				jumpto dmmenu
			elif [[ "$deinput" -eq 9 ]] ;then
				echo "bspwm Installation"
				jumpto dmmenu
			elif [[ "$deinput" -eq 10 ]] ;then
				echo "awesome window Manager Installation"
				yay -S awesome rofi picom i3lock-fancy xclip ttf-roboto polkit-gnome materia-theme lxappearance flameshot pnmixer network-manager-applet xfce4-power-manager qt5-styleplugins papirus-icon-theme -y
				git clone https://github.com/ChrisTitusTech/titus-awesome ~/.config/awesome
				mkdir -p ~/.config/rofi
				cp $HOME/.config/awesome/theme/config.rasi ~/.config/rofi/config.rasi
				sed -i '/@import/c\@import "'$HOME'/.config/awesome/theme/sidebar.rasi"' ~/.config/rofi/config.rasi
				cd /etc/
				sed -i -e '$aXDG_CURRENT_DESKTOP=Unity' environment
				sed -i -e '$aQT_QPA_PLATFORMTHEME=gtk2' environment
				jumpto dmmenu		            
	    		fi
	    
            	elif [[ "$input1" -eq 3 ]] ;then
			dmmenu:
			echo -e "\e[31m Install only one Display Manager \e[0m"
			echo -e "\e[37m \e[0m"
            		echo Login / Display Managers
                	echo i> Lightdm
            		echo ii> GDM
            		echo iii> SDDM
            		echo Enter the Option :
            		read $dminput
            	
#################################### LIGHT DM ############################################            	
            		if [[ "$dminput" -eq 1 ]] ;then
            			sudo pacman -S lightdm-webkit2-greeter numlockx --noconfirm
            			yay -S lightdm-webkit2-theme-glorious
            			cd /etc/lightdm
            			sudo sed -i '/#greeter-session=/c\greeter-session=lightdm-webkit2-greeter' lightdm.conf
            			sudo sed -i '/#greeter-setup-script=/c\greeter-setup-script=/usr/bin/numlockx on' lightdm.conf
            			sudo sed -i '/webkit_theme        = antergos/c\webkit_theme        = glorious' lightdm-webkit2-greeter.conf
            			sudo systemctl enable lightdm.service
            			jumpto start
################################## GDM #########################################################            	
            		elif [[ "$dminput" -eq 2 ]] ;then
            			sudo pacman -S gdm --noconfirm
            			sudo systemctl enable gdm.service
				jumpto start
################################## SDDM ########################################################            		
            		elif [[ "$dminput" -eq 3 ]] ;then
            			sudo pacman -S sddm --noconfirm
            			cd /usr/lib/sddm/sddm.conf.d/
				yay -S sddm-theme-sugar-candy-git
            			sudo sed -i '/Numlock=/c\Numlock=on' default.conf
            			sudo sed -i '/Current=/c\Current=Sugar-Candy' default.conf
            			sudo systemctl enable sddm.service
				jumpto start
			fi            	
            	
	    	elif [[ "$input1" -eq 4 ]] ;then
	    		echo "Multimedia Installations"
	    		sudo pacman -S mpv vlc ffmpeg
	    		yay -S mps-youtube-git
	    		yay -S youtube-viewer
			jumpto start
	    
	    	elif [[ "$input1" -eq 5 ]] ;then
	    		echo "Development Tools Installation"
	    	
	    		sudo pacman -S cmake clang nodejs npm jdk11-openjdk
	    		curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
			# input 1
			source $HOME/.cargo/env
			source ~/.profile
			jumpto start
	    	
	    	elif [[ "$input1" -eq 6 ]] ;then
	    		echo Productivity Apps Installation
	    		yay -S notion-app-enhanced whatsapp-for-linux newsflash 
			jumpto start
	    	
	    	elif [[ "$input1" -eq 7 ]] ;then
	    		echo "Terminal Setup"
			jumpto start
	    	
	    	elif [[ "$input1" -eq 8 ]] ;then
	    		jumpto end
	    		
	    	fi
		
	fi
    fi
done
end:
