#!/bin/bash
# Gustavo Arnosti Neves - Dec 2018

# Modified from many other snippets
# Adapted to work virtually anywhere
# Works on busybox/ash

# This script:  https://gist.github.com/tavinus/925c7c9e67b5ba20ae38637fd0e06b07
# SO reference: https://stackoverflow.com/questions/16843382/colored-shell-script-output-library

export ESeq="\033["
export RCol="$ESeq"'0m'    # Text Reset

# Regular
export Bla="$ESeq"'0;30m'
export Red="$ESeq"'0;31m'
export Gre="$ESeq"'0;32m'
export Yel="$ESeq"'0;33m'
export Blu="$ESeq"'0;34m'
export Pur="$ESeq"'0;35m'
export Cya="$ESeq"'0;36m'
export Whi="$ESeq"'0;37m'

# Bold
export BBla="$ESeq"'1;30m'
export BRed="$ESeq"'1;31m'
export BGre="$ESeq"'1;32m'
export BYel="$ESeq"'1;33m'
export BBlu="$ESeq"'1;34m'
export BPur="$ESeq"'1;35m'
export BCya="$ESeq"'1;36m'
export BWhi="$ESeq"'1;37m'

# Underline
export UBla="$ESeq"'4;30m'
export URed="$ESeq"'4;31m'
export UGre="$ESeq"'4;32m'
export UYel="$ESeq"'4;33m'
export UBlu="$ESeq"'4;34m'
export UPur="$ESeq"'4;35m'
export UCya="$ESeq"'4;36m'
export UWhi="$ESeq"'4;37m'

# High Intensity
export IBla="$ESeq"'0;90m'
export IRed="$ESeq"'0;91m'
export IGre="$ESeq"'0;92m'
export IYel="$ESeq"'0;93m'
export IBlu="$ESeq"'0;94m'
export IPur="$ESeq"'0;95m'
export ICya="$ESeq"'0;96m'
export IWhi="$ESeq"'0;97m'

# Bold High Intensity
export BIBla="$ESeq"'1;90m'
export BIRed="$ESeq"'1;91m'
export BIGre="$ESeq"'1;92m'
export BIYel="$ESeq"'1;93m'
export BIBlu="$ESeq"'1;94m'
export BIPur="$ESeq"'1;95m'
export BICya="$ESeq"'1;96m'
export BIWhi="$ESeq"'1;97m'

# Bold High Intensity
export BIBla="$ESeq"'1;90m'
export BIRed="$ESeq"'1;91m'
export BIGre="$ESeq"'1;92m'
export BIYel="$ESeq"'1;93m'
export BIBlu="$ESeq"'1;94m'
export BIPur="$ESeq"'1;95m'
export BICya="$ESeq"'1;96m'
export BIWhi="$ESeq"'1;97m'

# Background
export On_Bla="$ESeq"'0;40m'
export On_Red="$ESeq"'0;41m'
export On_Gre="$ESeq"'0;42m'
export On_Yel="$ESeq"'0;43m'
export On_Blu="$ESeq"'0;44m'
export On_Pur="$ESeq"'0;45m'
export On_Cya="$ESeq"'0;46m'
export On_Whi="$ESeq"'0;47m'

# High Intensity Backgrounds
export On_IBla="$ESeq"'0;100m'
export On_IRed="$ESeq"'0;101m'
export On_IGre="$ESeq"'0;102m'
export On_IYel="$ESeq"'0;103m'
export On_IBlu="$ESeq"'0;104m'
export On_IPur="$ESeq"'0;105m'
export On_ICya="$ESeq"'0;106m'
export On_IWhi="$ESeq"'0;107m'

export BLACK=30
export RED=31
export GREEN=32
export YELLOW=33
export BLUE=34
export PURPLE=35
export CYAN=36
export WHITE=37

export REGULAR=0
export BOLD=1
export UNDERLINE=4

FOREGROUND_COLOR=$Whi
BACKGROUND_COLOR=$On_Bla

function set_background() {
    shopt -s nocasematch
    case $0 in
    white)
      BACKGROUND_COLOR=$On_Whi
      ;;
    black)
      BACKGROUND_COLOR=$On_Bla
      ;;
    green)
      BACKGROUND_COLOR=$On_Gre
      ;;
    red)
      BACKGROUND_COLOR=$On_Red
      ;;
    yellow)
      BACKGROUND_COLOR=$On_Yel
      ;;
    esac
    shopt -s nocasematch
}

function write() {
  echo -e "$1"
}

function writeln() {
  write "$1\n"
}

function get_text_style() {
  local style_code="${2:-0};${1:-$FOREGROUND_COLOR}"'m'
  echo "\033["''$style_code''
}

function get_background_style() {
  color=${1:-BACKGROUND_COLOR}
  offset=10
  color=""$((offset + color))""
  local style_code="\033["''${color}'m'
  echo $style_code
}

function style_text() {
  text=$1
  text_color=${2:-$FOREGROUND_COLOR}
  text_style=${3:-0}
  bg_color=${4:-$BACKGROUND_COLOR}

  local styled_text="$(get_text_style $text_color $text_style)$text$RCol"
  echo -e $styled_text
}

export -f set_background
export -f write
export -f writeln
export -f get_text_style
export -f get_background_style
export -f style_text
export FOREGROUND_COLOR
export BACKGROUND_COLOR
