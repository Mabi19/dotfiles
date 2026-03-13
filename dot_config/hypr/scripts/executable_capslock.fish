#!/usr/bin/env fish

set active $(hyprctl devices -j | jq '.keyboards | map(select(.main))[0].capsLock')
if test $active = 'true'
    mabictl osd -i input-keyboard-symbolic -t "cAPS lOCK ENABLED"
else
    mabictl osd -i input-keyboard-symbolic -t "Caps Lock disabled"
end
