#!/bin/bash
# Source: modified from github.com/AaronLasseigne/tmux_battery_charge_indicator 

UNCHARGE_SYMBOL='▯'
CHARGE_SYMBOL='▮'

if [[ `uname` == 'Linux' ]]; then
  current_charge=$(cat /proc/acpi/battery/BAT1/state | grep 'remaining capacity' | awk '{print $3}')
  total_charge=$(cat /proc/acpi/battery/BAT1/info | grep 'last full capacity' | awk '{print $4}')
else
  battery_info=`ioreg -rc AppleSmartBattery`
  current_charge=$(echo $battery_info | grep -o '"CurrentCapacity" = [0-9]\+' | awk '{print $3}')
  total_charge=$(echo $battery_info | grep -o '"MaxCapacity" = [0-9]\+' | awk '{print $3}')
fi

charged_slots=$(echo "(($current_charge/$total_charge)*10)+1" | bc -l | cut -d '.' -f 1)
if [[ $charged_slots -gt 10 ]]; then
  charged_slots=10
fi

if [[ $charged_slots -lt 3 ]]; then
    echo -n '#[fg=colour41]'
elif [[ $charged_slots -lt 5 ]]; then
    echo -n '#[fg=colour42]'
elif [[ $charged_slots -lt 7 ]]; then
    echo -n '#[fg=colour43]'
elif [[ $charged_slots -lt 9 ]]; then
    echo -n '#[fg=colour44]'
else
    echo -n '#[fg=colour45]'
fi

for i in `seq 1 $charged_slots`; do echo -n "$CHARGE_SYMBOL"; done

if [[ $charged_slots -lt 10 ]]; then
  for i in `seq 1 $(echo "10-$charged_slots" | bc)`; do echo -n "$UNCHARGE_SYMBOL"; done
fi
