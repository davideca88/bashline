#!/bin/env bash

function check_depends {
    MD=0
    [[ $(type -f bash) ]] || {printf "Missing dependency: bash" && MD=1}
    [[ $(type -f git) ]]  || {printf "Missing dependency: git"  && MD=1}

    [[ $MD -ne 0 ]] && exit 1
}

function install_fonts {
    if [[ $(uname -o) = "Android" ]]; then
        printf "\e[1;32mInstalling Meslo Nerdfont\e[m\n"
        printf "CAUTION: it will overwrite your old ~/.termux/font.ttf\n"
        printf "(If you don't undertand the above, say Y)\n"
        printf "Want to continue? [Y/n]: "
            read resp
        if [[ $resp != "Y" ]] || [[ $resp != "y" ]]; then
            printf "Aborting installation of font.\n"
            return
        fi

        curl https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf \
            -O $HOME/.termux/font.ttf
    else
        printf "\e[1;32mInstalling Meslo Nerdfont\e[m\n"
        mkdir -p $HOME/.local/share/fonts/
        curl https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf \
            -O $HOME/.local/share/fonts/MesloLGS\ NF\ Regular.ttf
        printf "Set your Terminal Font as \"MesloLGS NF Regular\""
    fi
}

function create_dir {
    mkdir -p $HOME/.config/bashline/
}

function cp_files {
    curl https://raw.githubusercontent.com/davideca27/bashline/main/files/bashline.sh \
        > $HOME/.config/bashline/bashline.sh
    curl https://raw.githubusercontent.com/davideca27/bashline/main/files/_bashrc     \
        >> $HOME/.bashrc
}
check_depends
install_fonts
create_dir
cp_files
