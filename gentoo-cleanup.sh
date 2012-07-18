#!/bin/bash

# regex to remove package version
# it works from the end to the begining
REGEX=""
REGEX="${REGEX} s:-r[[:digit:]]+::;"
REGEX="${REGEX} s:_p[[:digit:]]+::;"
REGEX="${REGEX} s:_pre[[:digit:]]+::;"
REGEX="${REGEX} s:_alpha[[:digit:]]::;"
REGEX="${REGEX} s:_beta[[:digit:]]::;"
REGEX="${REGEX} s:_rc[[:digit:]]::;"
REGEX="${REGEX} s:(\.[[:alnum:]]*)+$::g;"
REGEX="${REGEX} s:-[[:digit:]][[:alnum:]]*$::;"
REGEX="${REGEX} s:[[:blank:]]::g;"

# regex to remove emerge's output
REGEX2=""
REGEX2="${REGEX2} s:^\[ebuild........\] ::;"
REGEX2="${REGEX2} s:[[:blank:]].*$::g;"

# Get the list of installed packages
equery -Cq list '*' |grep /|sed -re "${REGEX}"|sort -u > installed

# Get the list of packages that emerge --empty-tree --newuse world
# would install (anything not in this list should be ok to remove)
emerge -ep --newuse --with-bdeps=y @world|grep ebuild.*/|sed -re "${REGEX2} ${REGEX}"|sort -u > newworld

cat installed |grep --line-regexp -vf newworld > toremove
wc -l installed newworld toremove
cat toremove

echo
echo 'emerge -Ca `cat toremove`'

