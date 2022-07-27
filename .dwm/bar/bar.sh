#!/bin/dash

# ^c$var^ = fg color
# ^b$var^ = bg color

interval=0

# load colors!
. ~/.dwm/bar/themes/samir

cpu() {
    cpu_val=$(grep -o "^[^ ]*" /proc/loadavg)
    
    printf "^c$black^ ^b$green^ CPU"
    printf "^c$white^ ^b$grey^ $cpu_val"
}

#pkg_updates() {
#updates=$(doas xbps-install -un | wc -l) # void
#	updates=$(checkupdates | wc -l)   # arch , needs pacman contrib
# updates=$(aptitude search '~U' | wc -l)  # apt (ubuntu,debian etc)

#	if [ -z "$updates" ]; then
#		printf "^c$green^  Fully Updated"
#	else
#		printf "^c$green^  $updates"" updates"
#	fi
#}

battery() {
    charge_status=$((acpi -b | awk '{print $3}') | grep -o "Discharging")
    charge_percent=$(acpi -b | awk '{print $4}' | cut -d "%" -f 1)
    if [ "$charge_status" == "Discharging" ]; then
        if [ "$charge_percent" -lt "20" ]; then
            printf "^c$red^  $charge_percent%"
            elif [ "$charge_percent" -lt "40" ]; then
            printf "^c$yellow^  $charge_percent%"
            elif [ "$charge_percent" -lt "60" ]; then
            printf "^c$yellow^  $charge_percent%"
            elif [ "$charge_percent" -lt "80" ]; then
            printf "^c$green^  $charge_percent%"
        else
            printf "^c$green^  $charge_percent%"
        fi
    else
        printf "^c$green^  $charge_percent%"
    fi
}

brightness() {
    printf "^c$red^   "
    printf "^c$red^%.0f\n" $(light -G)
}

mem() {
    printf "^c$blue^^b$black^  "
    printf "^c$orange^ $(free -h | awk '/^Mem/ { print $3 }' | sed s/i//g)"
}

wlan() {
    case "$(cat /sys/class/net/w*/operstate 2>/dev/null)" in
        up) printf "^c$black^ ^b$dgreen^ 󰤨 ^d^%s" " ^c$blue^Con" ;;
        down) printf "^c$black^ ^b$blue^ 󰤭 ^d^%s" " ^c$blue^Discon" ;;
    esac
}

clock() {
    printf "^c$black^ ^b$darkblue^ 󱑆 "
    printf "^c$black^^b$blue^ $(date '+%I:%M %p')"
    
    printf "^c$black^ ^b$darkblue^ 📅 "
    printf "^c$black^^b$blue^😀 $(date '+%F :%a ') "
}

dwm_spotify () {
    if ps -C spotify > /dev/null; then
        PLAYER="spotify"
        elif ps -C spotifyd > /dev/null; then
        PLAYER="spotifyd"
    fi
    
    if [ "$PLAYER" = "spotify" ] || [ "$PLAYER" = "spotifyd" ]; then
        ARTIST=$(playerctl metadata artist)
        TRACK=$(playerctl metadata title)
        POSITION=$(playerctl position | sed 's/..\{6\}$//')
        DURATION=$(playerctl metadata mpris:length | sed 's/.\{6\}$//')
        STATUS=$(playerctl status)
        SHUFFLE=$(playerctl shuffle)
        
        if [ "$IDENTIFIER" = "unicode" ]; then
            if [ "$STATUS" = "Playing" ]; then
                STATUS="▶"
            else
                STATUS="⏸"
            fi
            
            if [ "$SHUFFLE" = "On" ]; then
                SHUFFLE=" 🔀"
            else
                SHUFFLE=""
            fi
        else
            if [ "$STATUS" = "Playing" ]; then
                STATUS="PLA"
            else
                STATUS="PAU"
            fi
            
            if [ "$SHUFFLE" = "On" ]; then
                SHUFFLE=" S"
            else
                SHUFFLE=""
            fi
        fi
        
        if [ "$PLAYER" = "spotify" ]; then
            printf "^c$green^ 🎶%s%s %s - %s " "$SEP1" "$STATUS" "$ARTIST" "$TRACK"
            printf "%0d:%02d" $((DURATION%3600/60)) $((DURATION%60))
            printf "%s\n" "$SEP2"
        else
            printf "Not playing"
        fi
    fi
}


while true; do
    
    [ $interval = 0 ] || [ $(($interval % 3600)) = 0 ] && updates=$(pkg_updates)
    interval=$((interval + 1))
    
    sleep 1 && xsetroot -name "$(dwm_spotify) $(battery) $(brightness) $(cpu) $(mem) $(wlan) $(clock)"
done
