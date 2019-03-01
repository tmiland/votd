#!/usr/bin/env bash

# Original author: Ava Gailliot
# Original script: https://github.com/mztriz/votd
# Modified by Tommy Miland - 2019
# A small shell script to print Bible Gateway's VOTD in KJV
#------------------------------------------------------------------------------#
#
# MIT License
#
# Copyright (c) 2019 Tommy Miland
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#
#------------------------------------------------------------------------------#

# Icons used for printing
CROSS='✝'
BQUOTE='❝'
EQUOTE='❞'
# Use colors, but only if connected to a terminal, and that terminal
# supports them.
if which tput >/dev/null 2>&1; then
  ncolors=$(tput colors)
fi
if [ -t 1 ] && [ -n "$ncolors" ] && [ "$ncolors" -ge 8 ]; then
  RED="$(tput setaf 1)"
  GREEN="$(tput setaf 2)"
  YELLOW="$(tput setaf 3)"
  BLUE="$(tput setaf 4)"
  BOLD="$(tput bold)"
  NC="$(tput sgr0)"
else
  RED='\033[0;31m'
  GREEN='\033[0;32m'
  YELLOW='\033[0;33m'
  BLUE='\033[0;34m'
  BOLD="\033[1m"
  NC='\033[0m'
fi
# Maximum column width
width=$((70))
# RSS feed URL for BG
# Source base for this script: https://github.com/mztriz/votd
# 9 is KJV - https://www.biblegateway.com/usage/linking/versionslist/
VOTD_ID=9
VOTD_URL=https://www.biblegateway.com/usage/votd/rss/votd.rdf?$VOTD_ID
# More version can be added here
case "$VOTD_ID" in
  9)
    VOTD_VERSION=KJV
    ;;
esac
# Grab VOTD from XML in URL
get_votd () {
  curl --silent --connect-timeout 10 "$VOTD_URL"
}

TITLE=$(
  get_votd |
  grep '<title>' |
  sed -n 1p |
  sed -e 's/<[^>]*>//g' |
  sed 's/^[ \t]*//' 
)

DESCRIPTION=$(
  get_votd |
  grep '<description>' |
  sed -n 1p |
  sed -e 's/<[^>]*>//g' |
  sed 's/^[ \t]*//' 
)

MESSAGE=$(
  get_votd |
  grep -o '&ldquo.*' |
  cut -f2- -d';' |
  cut -d '&' -f1 |
  sed -e 's/^[[:space:]]*//' |
  fold -w ${width} -s
)

VERSE=$(
  get_votd |
  grep '<title>' |
  sed -n 2p |
  sed -e 's/<[^>]*>//g' | 
  xargs echo -n
)

RIGHTS=$(
  get_votd |
  grep '<dc:rights>' |
  sed -n 2p |
  sed -e 's/<[^>]*>//g'
)

header () {
  clear
  echo -e "${BLUE}${BOLD}${TITLE}${NC} ${CROSS}"
  echo -e "${DESCRIPTION}"
  echo -e "${GREEN}"
  echo '  _    ______  __________  '
  echo ' | |  / / __ \/_  __/ __ \ '
  echo ' | | / / / / / / / / / / / '
  echo ' | |/ / /_/ / / / / /_/ /  '
  echo ' |___/\____/ /_/ /_____/   '
  echo -e "${NC}"
  echo -e "${BQUOTE}${BLUE}${MESSAGE}${NC}${EQUOTE} ${GREEN}${VERSE}${NC} ${YELLOW}(${VOTD_VERSION})${NC}\n"
  echo -e "${RIGHTS}"
}

votd() {
  header
}

votd "$@"
