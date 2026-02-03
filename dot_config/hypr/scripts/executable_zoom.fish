#!/usr/bin/env fish

set current $(hyprctl getoption cursor:zoom_factor -j | jq '(.float)')
echo $current

if test $current -gt 1
    hyprctl keyword cursor:zoom_factor 1
else
    hyprctl keyword cursor:zoom_factor 1.5
end
