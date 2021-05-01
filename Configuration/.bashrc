function rgmore(){
    rg -p "$@" | less -EXR
}

function rgmoreword(){
    rgmore -w "$@"
}

function rgmoreignorecase(){
    rgmore -i "$@"
}

alias ls='ls -F --color'
alias ll='ls -lF --color'
alias rm='rm -i'

export PS1="\u@\h(\w) "

export BR2_DL_DIR=~/buildroot/download
export PATH=$PATH:~/buildroot/buildroot-2021.02_virt/output/host/bin

