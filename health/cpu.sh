#!/bin/bash
#source ../settings.conf #import thresholds

getCPU=$(cat /proc/loadavg | awk '{print $3}') #first column 1 minute, 2nd column 5 minutes, 3rd column 15 minutes
#Have to use bc cos floating point comparison
if (( $(echo "$getCPU > $CPUALERT" | bc -l) )); then
ntfy send "$(
        echo ":zap: CPU busy.. $getCPU avg on $(hostname) as on $(date)"
        echo -e "Top CPU apps: \n"
ps axo pid,args,pcpu --sort -pcpu | head -n 5
)"

###ALERTDELAY###
sed -i 's/HEALTHDELAY=0/HEALTHDELAY=1/g' "$DIR"/settings.conf
echo "sed -i 's/HEALTHDELAY=1/HEALTHDELAY=0/g' "$DIR"/settings.conf" > "$DIR"/health/job.txt
at now + "$ALERT_DELAY_PERIOD" < "$DIR"/health/job.txt
#sed -i 's/HEALTHDELAY=1/HEALTHDELAY=0/g' "$DIR"/settings.conf | at now + 5 min #"$ALERT_DELAY_PERIOD"

fi

