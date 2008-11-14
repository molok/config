# .bashrc

unset PS1

export MPD_PORT=6600
export MPD_HOST=localhost
export HISTSIZE=99999
#export LC_TIME=it_IT
export EDITOR=vim

#export MANPAGER="col -b | view -c 'set ft=man nomod nolist titlestring=MANPAGE' -"
export MANPAGER="less -is"

# for using tor/privoxy under elinks
#export HTTP_PROXY=http://127.0.0.1:8118
alias alinks='HTTP_PROXY=http://127.0.0.1:8118 elinks'

export GDK_USE_XFT=1

alias vi='vim'
#alias c='killall -2 mpg123'
alias c='mpc next'
alias cp='cp -i'
alias cbak='/home/alebolo/Documents/prog/shell/cbak.sh' 
#alias e='exit'
alias gpp='g++ -Wno-deprecated'
alias linbak='cd $linbak'
LS='ls -F --group-directories-first --color=auto'
alias ls='$LS'
alias l='$LS'
alias la='$LS -la'
alias ll='$LS -l'
alias lll='$LS -Xhl'
alias lls='$LS -sSh'
alias lsh='$LS -sh1'
alias lsd='$LS | grep \/'
alias log='/home/alebolo/Documents/prog/shell/loglogin.sh'
alias man='man -a'
alias mkbak='/home/alebolo/Documents/prog/shell/mkbak.sh'
alias mkbaklite='/home/alebolo/Documents/prog/shell/mkbaklite.sh'
alias mutt='mutt -y'
alias mv='mv -i'
alias p='cd "$OLDPWD"'
alias prog='cd $prog'
alias py='python'
alias q='clear'
alias rm='rm -i'
alias s='cd ..'
alias h='history'

alias send2mob='obexftp -b 00:01:E3:3D:10:6C -p '
alias obextool='obextool --obexcmd "obexftp -b 00:01:E3:3D:10:6C"'
alias mld='telnet localhost 4000'
alias pacman='sudo pacman'
alias webshare='python -c "import SimpleHTTPServer;SimpleHTTPServer.test()"'
alias open='xdg-open'
shopt -s histappend

d(){
 sudo /etc/rc.d/$1 $2
} #end of d


function mnt(){
   DRIVE=/mnt/$1
   mount $DRIVE && cd $DRIVE && echo "${DRIVE} mounted."
}

function eject() {
   DRIVE=/mnt/$1
   if [[ $PWD = /mnt/$1 ]]; then cd ..; fi
   umount $DRIVE && sudo /usr/bin/eject $DRIVE && echo "${DRIVE} ejected."
}

function aurget() {
   for pac in $@; do 
      wget http://aur.archlinux.org/packages/$pac/$pac.tar.gz; 
   done; 
}

function lss() {
    tot=0
    ls -1sSh "$@"
    for x in "$@"; do
        let tot+=$(ls -s "$x" | cut -d\  -f1)
    done
    echo -n "total "
    if (( $tot > 1024 )); then
            echo $((tot/1024)) M
    else
            echo $tot K
    fi
}



# THE PROMPT!
#Black       0;30
#Red         0;31
#Green       0;32
#Brown       0;33
#Blue        0;34
#Purple      0;35
#Cyan        0;36
#Light Gray  0;37
#Dark Gray     1;30
#Light Red     1;31
#Light Green   1;32
#Yellow        1;33
#Light Blue    1;34
#Light Purple  1;35
#Light Cyan    1;36
#White         1;37

i=30
for color in black red green brown blue purple cyan lightgray; do
   export v_${color}="\033[0;${i}m"
   let i++;
done
i=30
for color in darkgray lightred lightgreen yellow lightblue lightpurple lightcyan white ; do
   export v_${color}="\033[1;${i}m"
   let i++;
done
v_nocolor="\033[0m"

#export PS1="\n(\u@\h):(`date +%Y.%m.%d` - \t):(\w)\n\$? \\$ "

fprompt(){
PREV_RET_VAL=$?
PS1=""

#    if test `whoami` != "root"
#    then
#        PS1="${PS1}${COLOR_CYAN_BOLD}\u${COLOR_NONE}"
#    else
#        PS1="${PS1}${COLOR_RED_BOLD}\u${COLOR_NONE}"
#    fi

#    PS1="${PS1}@\h"


if test $PREV_RET_VAL -eq 0
then {
#PS1="\n${v_blue}(${v_green}\u@\h${v_blue}):\
PS1="\ek\e\\\\\[${v_nocolor}\]\[${v_blue}\](\[${v_green}\]\u@\h\[${v_blue}\]):\
(\[${v_yellow}\]`date +%Y.%m.%d` - \t\[${v_blue}\]):\
(\[${v_purple}\]\w\[${v_blue}\])\
\n\[${v_nocolor}\]\
\[${v_blue}\](\!)\[${v_nocolor}\]\
\\$> "
} else {
#PS1="\n${v_blue}(${v_green}\u@\h${v_blue}):\
PS1="\ek\e\\\\\[${v_blue}\](\[${v_green}\]\u@\h\[${v_blue}\]):\
(\[${v_yellow}\]`date +%Y.%m.%d` - \t\[${v_blue}\]):\
(\[${v_purple}\]\w\[${v_blue}\])\
\n\[${v_red}\](\${?})\[${v_nocolor}\]\
\[${v_blue}\](\!)\[${v_nocolor}\]\
\\$> "
} fi
history -a
} #end of fprompt

PROMPT_COMMAND=fprompt

#PS1="\n${v_blue}(${v_green}\u@\h${v_blue}):\
#(${v_yellow}`date +%Y.%m.%d`- \t${v_blue}):\
#(${v_purple}\w${v_blue})\
#\n\$? ${v_nocolor}\\$ "
#\n\$([ $? -eq 0 ] && echo -en $v_blue aa || echo -en $v_red aa)\$? ${v_nocolor}\\$ "

export PROMPT_COMMAND
#export PROMPT_COMMAND='echo -n -e "\033k\033\134"'
# Source global definitions
if [ -f /etc/bashrc ]
then
	. /etc/bashrc
fi

if [ -r ~/.bash_bindings ]; then
    source ~/.bash_bindings
fi

#export PROMPT_COMMAND=""
#export PS1='\[\033k\033\\\]\u@\h:\w\$ '
#export PS1='\ek\e\\\u@\h:\w\$ '

#source /etc/bash_completion
PATH=$PATH:~/bin:/usr/local/bin:/opt/local/lib/postgresql83/bin
#export TERM=xterm
#export LC_CTYPE=en_US.UTF-8
#export LANG=en_US

if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

export MAKEFLAGS="-j2"
alias port='sudo port -v'
export MANPATH=$MANPATH:/opt/local/man
alias cp='cp'
alias mv='mv'
export HISTCONTROL=ignoredups
export HISTTIMEFORMAT='%F %T '
export blog="ftp://themolok.netsons.org/"
export EMAIL='CHANGEME!'

export DISPLAY=:0.0


function mkcd(){
mkdir -p "$1"
cd "$1"
}

set -o vi
bind -m vi-insert control-l:clear-screen

LS_COLORS='di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:tw=30;42:ow=30;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.lzma=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.rar=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:';
export LS_COLORS
