# i3bar using JSON
echo '{ "version": 1, "click_events": true }'

# Endless array
echo '['

# Simpler loop
echo '[]'

# Launch as background process
(while :;
do
  echo -n ",["
  echo -n "{\"name\":\"id_cpu\",\"background\":\"#283593\",\"full_text\":\"$(/usr/bin/env python3 /home/aiden/.config/i3status/cpu.py)%\"},"
  echo -n "{\"name\":\"id_time\",\"background\":\"#546E7A\",\"full_text\":\"$(date)\"}"
  echo -n "]"
  sleep 1
done) &

while read line;
do
  # DATE click
  if [[ $line == *"name"*"id_time"* ]]; then
    urxvt -e /home/aiden/.config/i3status/click_time.sh &

  # CPU click
  elif [[ $line == *"name"*"id_cpu"* ]]; then
    urxvt -e htop &
  fi
done
