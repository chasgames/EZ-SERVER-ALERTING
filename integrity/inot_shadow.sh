#!/bin/bash

mypidfile=/tmp/EZ-Server-Alerting-integrity-two.pid
firsttimerun=/var/tmp/EZ-Server-Alerting-integrity-two

if [ -e $mypidfile ]; then
  echo "script is already running"
  exit 1
fi

# Make sure PID file is removed on program exit.
trap "rm -f -- '$mypidfile'" EXIT

# Create a file with current PID to indicate that process is running.
echo $$ > "$mypidfile"

if ! [ -e $firsttimerun ]; then
 cp /etc/shadow $firsttimerun
fi


while inotifywait -e attrib /etc/shadow; do

ntfy send "$(
echo ":key: /etc/shadow has changed, New user has been added or something has changed about a user"
echo -e "The differences:\\n"
diff $firsttimerun /etc/shadow
)"

cp /etc/shadow $firsttimerun 
done
