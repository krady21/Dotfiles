# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# bash color escape sequences
color_red=$'\001'$(tput setaf 1 2>/dev/null || echo $'\e[31m')$'\002'
color_green=$'\001'$(tput setaf 2 2>/dev/null || echo $'\e[32m')$'\002'
color_blue=$'\001'$(tput setaf 4 2>/dev/null || echo $'\e[34m')$'\002'
color_reset=$'\001'$(tput sgr 0 2>/dev/null || echo $'\e[0m')$'\002'

# dereference git symbolic reference HEAD to get branch name or sha1 of commit
# object and amend by information about current status of staging area
dereference_git_HEAD() {
    local sha1
    sha1=$(git rev-parse --short HEAD 2>&1)
    if [ $? -eq 0 ]; then
        local color_symref=$color_green
        local color_ref=$color_blue
        local dirty=$(git status --porcelain 2>&1)
        if [ ! -z "$dirty" ]; then
            color_symref=$color_red
            color_ref=$color_red
            dirty='*'
        fi
        GIT_HEAD_PROMPT="$color_symref($(git symbolic-ref --quiet --short HEAD)$dirty)$color_reset"
        if [ $? -ne 0 ]; then
            GIT_HEAD_PROMPT="$color_ref[$sha1$dirty]$color_reset"
        fi
    else
        GIT_HEAD_PROMPT=""
    fi
}

# run command before bash takes PS1 to build prompt
PROMPT_COMMAND="dereference_git_HEAD; $PROMPT_COMMAND"

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=120000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

# Automatically fix directory name typos when changing directory
shopt -s cdspell

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\] \[\033[01;34m\]\w\[\033[00m\] $GIT_HEAD_PROMPT \n\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\W\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

alias sudo='sudo '

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Set vim keybindings for bash
set -o vi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

alias apti='sudo apt install'
alias aptr='sudo apt remove'
alias apts='sudo apt-cache show'
alias aptu='sudo apt update && sudo apt upgrade'
alias ..='cd ..'
alias ...='cd ../../'
alias ....='cd ../../../'

alias vimrc='vim ~/.vimrc'
alias bashrc='vim ~/.bashrc'
alias tconf='vim ~/.tmux.conf'
alias ide='bash ~/ide.sh'

alias qgc='~/./QGroundControl.AppImage' 

alias open='xdg-open'
alias python='python3'
alias pip='pip3'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Hide terminal top bar(doesn't always work)
# if [ "$TERM" = "xterm-256color" ]; then
#   xprop \
#     -id $(xdotool getactivewindow) \
#     -f _MOTIF_WM_HINTS 32c \
#     -set _MOTIF_WM_HINTS "0x2, 0x0, 0x0, 0x0, 0x0"
# fi

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

export VISUAL=vim
export EDITOR="$VISUAL"

export PATH=$PATH:/opt/Xilinx/14.7/ISE_DS/ISE/bin/lin64:/opt/Xilinx/14.7/ISE_DS/ISE/sysgen/util:/opt/Xilinx/14.7/ISE_DS/ISE/../../../DocNav:/opt/Xilinx/14.7/ISE_DS/PlanAhead/bin:/opt/Xilinx/14.7/ISE_DS/EDK/bin/lin64:/opt/Xilinx/14.7/ISE_DS/EDK/gnu/microblaze/lin/bin:/opt/Xilinx/14.7/ISE_DS/EDK/gnu/powerpc-eabi/lin/bin:/opt/Xilinx/14.7/ISE_DS/EDK/gnu/arm/lin/bin:/opt/Xilinx/14.7/ISE_DS/EDK/gnu/microblaze/linux_toolchain/lin64_be/bin:/opt/Xilinx/14.7/ISE_DS/EDK/gnu/microblaze/linux_toolchain/lin64_le/bin:/opt/Xilinx/14.7/ISE_DS/common/bin/lin64

export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64

export PATH=$PATH:/usr/local/MATLAB/R2017a/bin

source $HOME/bin/*
