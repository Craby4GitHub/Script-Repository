#!/usr/bin/env bash

# DO NOT RUN THIS SCRIPT AS ROOT! LETS ENSURE THAT HERE:
[[ "$UID" == 0 ]] && echo -e "This script cannot be run as root! \n exiting..." && exit 1

# Lets create a function for some colored text:

springgreen4() {
    if (( $# == 0 )) ; then
        xargs -r -I{} echo -e "\e[38;5;29m"{}"\e[0m" < /dev/stdin
    else
        echo -e "\e[38;5;29m${@}\e[0m"
    fi
}

# A simple script to download the various themes that I like to have installed for Oh-My-Zsh:

###################################################################
#now lets start downloading themes, they'll each go to the $ZSH/custom/themes folder in their own named folder.
###################################################################

# AgnosterZak Theme: https://github.com/zakaziko99/agnosterzak-ohmyzsh-theme
git clone https://github.com/zakaziko99/agnosterzak-ohmyzsh-theme.git $ZSH/custom/themes/agnosterzak

# Alien ZSH Theme: https://github.com/eendroroy/alien
git clone https://github.com/eendroroy/alien.git $ZSH/custom/themes/alien

# Blokkzh ZSH Theme: https://github.com/KorvinSilver/blokkzh
git clone https://github.com/KorvinSilver/blokkzh.git $ZSH/custom/themes/blokkzh

# Bullet-Train Theme: https://github.com/caiogondim/bullet-train.zsh
git clone https://github.com/caiogondim/bullet-train.zsh.git $ZSH/custom/themes/bullet-train

# Headline Theme: https://github.com/Moarram/headline
git clone https://github.com/Moarram/headline.git $ZSH/custom/themes/headline

# Oh-My-Via Theme: https://github.com/badouralix/oh-my-via
git clone https://github.com/badouralix/oh-my-via.git $ZSH/custom/themes/oh-my-via

# Powerlevel10K Theme: https://github.com/romkatv/powerlevel10k
git clone https://github.com/romkatv/powerlevel10k.git $ZSH/custom/themes/powerlevel10k

# Zeroastro ZSH Theme: https://github.com/zeroastro/zeroastro-zsh-theme
git clone https://github.com/zeroastro/zeroastro-zsh-theme.git $ZSH/custom/themes/Zeroastro

###################################################################

# Now we'll create a switch statement to set any of these as our default zsh Theme:

springgreen4 "Choose your ZSH Theme:"
springgreen4 "1. AgnosterZak"
springgreen4 "2. Alien"
springgreen4 "3. Blokkzh"
springgreen4 "4. Bullet-Train"
springgreen4 "5. Headline"
springgreen4 "6. Oh-My-Via"
springgreen4 "7. Powerlevel10K"
springgreen4 "8. Zeroastro"
springgreen4 "9. None for now, just installing."

read -p "Enter your choice (1 through 9): " Choice

case $Choice in
    1)
        # AgnosterZak:
        sed -i 's,ZSH_THEME=".*",ZSH_THEME="agnosterzak/agnosterzak",g' ~/.zshrc
        ;;
    2)
        # Alien:
        sed -i 's,ZSH_THEME=".*",ZSH_THEME="alien/alien",g' ~/.zshrc
        ;;
    3)
        # Blokkzh:
        sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="blokkzh/blokkzh"' ~/.zshrc
        ;;
    4)
        # Bullet-Train:
        sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="bullet-train/bullet-train"' ~/.zshrc
        ;;
    5)
        # Headline:
        sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="headline/headline"' ~/.zshrc
        ;;
    6)
        # Oh-My-Via:
        sed -i 's,ZSH_THEME=".*",ZSH_THEME="oh-my-via/via",g' ~/.zshrc
        ;;
    7)
        # Powerlevel10K:
        sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="powerlevel10k/powerlevel10k"' ~/.zshrc
        ;;
    8)
        # Zeroastro:
        sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="zeroastro/zeroastro"' ~/.zshrc
        ;;
    *)
        echo "User input 9 or invalid input, not editing current Oh-My-Zsh Theme."
        exit
        ;;
esac


# Lastly lets source our .zshrc and get everything into our active session:
source ~/.zshrc
