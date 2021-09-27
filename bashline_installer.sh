#!/bin/env bash

function check_depends {
    MD=0
    [[ $(/bun/env bash) ]] || printf "Missing dependency: bash" && MD=1
    [[ $(/bin/env git) ]]  || printf "Missing dependency: git"  && MD=1

    [[ $MD -ne 0 ]] && exit 1
}

function install_fonts {
    if [[ $(uname -o) = "Android" ]]; then
        printf "\e[1;32mInstalling Meslo Nerdfont\e[m\n"
        printf "CAUTION: it will overwrite your old ~/.termux/font.ttf\n"
        printf "(If you don't undertand the above, say Y)\n"
        printf "Want to continue? [Y/n]: "
            read resp
        if { [[ $resp -n ]] && [[ $resp != "Y" ]] || [[ $resp != "y" ]] ;}; then
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
    cat <<EOF > $HOME/.config/bashline/bashline.sh
    STATUS=$1
function shell_status {
    [[ $STATUS != "0"  ]] &&			\
    printf "\[\e[1;31m\][$STATUS]\[\e[0;00m\]"
}

function distro_icon {
    printf "\[\e[1;32m\]\uf531\[\e[00m\]"
}

function git_branch {
    BRANCH="\ue725 $(git branch 2>/dev/null | grep '^*' | colrm 1 2)"
    [[ $(git branch 2>/dev/null) ]] && printf " at \[\e[32m\]$BRANCH\[\e[0m\] " || return 0
}

printf "$(distro_icon):\[\e[1;34m\]\w\[\e[00m\]$(git_branch)$(shell_status)\$ "
EOF

    cat <<EOF >> $HOME/.bashrc
# BASHLINE CONFIGS

function prompt_command {
    STATUS=$?
    export PS1=$($HOME/.config/bashline/bashline.sh $STATUS)
}

export PROMPT_COMMAND=prompt_command
EOF
}

check_depends
install_fonts
create_dir
cp_files
