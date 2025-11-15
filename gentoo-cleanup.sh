#!/bin/bash

# Get the list of installed packages
echo "Getting list of installed packages"
equery -Cq list --format '$cp' '*' |grep /|sort -u > installed

# Get the list of packages that emerge --empty-tree --newuse world
# would install (anything not in this list should be ok to remove)
echo "Getting list of necessary packages"
emerge --columns --emptytree --newuse --pretend --quiet --with-bdeps=y @world|awk '{print $2}'|sort -u > newworld

cat installed |grep --line-regexp -vf newworld > toremove

echo "Results:"
wc --lines --total=never installed newworld toremove

echo

if [ $(cat toremove|wc --lines) -gt 0 ]
then
  echo "Packages that can potentially be removed:"
  cat toremove|awk '{print "  - " $1}'
  echo
  echo "WARNING: There's no guarantee that they're not required"

  echo
  echo "If you're happy with the list of packages to remove, run this command to remove them:"
  echo
  echo '  emerge -Ca `cat toremove`'
else
  echo "No packages to remove"
fi

echo

