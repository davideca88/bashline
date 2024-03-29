STATUS=$1
function shell_status {
    [[ $STATUS != "0"  ]] && \
        printf "\[\e[1;31m\][$STATUS]\[\e[0;00m\]"
}

function distro_icon {
	[[ $(uname -o) = "Android" ]] && printf "\[\e[1;32m\]\uf531\[\e[m\]"
	[[ $(uname -n) = "arch" ]]    && printf "\[\e[1;38;5;27m\]\uf303\[\e[m\]"
}

function git_branch {
    BRANCH="\ue725 $(git branch 2>/dev/null | grep '^*' | colrm 1 2)"
    [[ $(git branch 2>/dev/null) ]] && printf " at \[\e[32m\]$BRANCH\[\e[0m\] " || return 0
}

printf "$(distro_icon):\[\e[1;34m\]\w\[\e[00m\]$(git_branch)$(shell_status)\$ "
