# Auto-lock after some time
# xautolock -locker '$HOME/.config/lock.sh' -time 10&

# Auto-lock after suspend
# xss-lock -- '$HOME/.config/lock.sh'&

# Set wallpaper
feh --no-fehbg --bg-scale '$HOME/Pictures/wallpaper.png'&

xset +fp /home/aiden/.fonts
xset fp rehash
