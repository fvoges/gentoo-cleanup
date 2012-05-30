#!/bin/bash

equery -Cq list '*' |grep /|sed -e "s:-r[[:digit:]]*::;s:_p[[:digit:]]::;s:_pre[[:digit:]]::;s:_alpha[[:digit:]]::;s:_beta[[:digit:]]::;s:_rc[[:digit:]]::;s:\.[[:alnum:]]*$::g;s:\.[[:alnum:]]*$::g;s:\.[[:alnum:]]*$::g;s:\.[[:alnum:]]*$::g;s:-[[:digit:]][[:alnum:]]*$::;s:[[:space:]]::g"|sort -u > installed
emerge -ep --newuse world|grep ebuild.*/|sed -e "s:^\[ebuild .......\] ::;s: .*$::g;s: ::g;s:-r[[:digit:]]*::;s:_p[[:digit:]]::;s:_pre[[:digit:]]::;s:_alpha[[:digit:]]::;s:_beta[[:digit:]]::;s:_rc[[:digit:]]::;s:\.[[:alnum:]]*$::g;s:\.[[:alnum:]]*$::g;s:\.[[:alnum:]]*$::g;s:\.[[:alnum:]]*$::g;s:-[[:digit:]][[:alnum:]]*$::;s:[[:space:]]::g;s:^.*$:^\0$:g"|sort -u > newworld
cat installed |grep -vf newworld >toremove
wc -l installed newworld toremove
cat toremove

