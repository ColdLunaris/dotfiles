#!/bin/sh
# Times the screen off and puts it to background
swayidle \
    timeout 10 "$HOME/.config/swaylock/lock.sh" \
    resume "$HOME/.config/swaylock/unlock.sh" \
    before-sleep 'playerctl pause' &
# Locks the screen immediately
swaylock -c $HOME/.config/swaylock/config
#swaylock --clock --indicator \
#    --datestr "%a %e.%m.%Y" --timestr "%k:%M:%S" \
#    --image $HOME/Pictures/Wallpapers/lockscreen.jpg --scaling fill \
#    --bs-hl-color b48eadff --caps-lock-bs-hl-color d08770ff --caps-lock-key-hl-color ebcb8bff \
#    --indicator-radius 100 --indicator-thickness 10 \
#    --inside-color 2e3440ff --inside-clear-color 81a1c1ff --inside-ver-color 5e81acff --inside-wrong-color bf616aff \
#    --key-hl-color a3be8cff --layout-bg-color 2e3440ff \
#    --line-uses-ring --ring-color 3b4252ff --ring-clear-color 88c0d0ff --ring-ver-color 81a1c1ff --ring-wrong-color 0d8770ff \
#    --separator-color 3b4252ff \
#    --text-color eceff4ff --text-clear-color 3b4252ff --text-ver-color 3b4252ff --text-wrong-color 3b4252ff
# Kills last background task so idle timer doesn't keep running
kill %%
