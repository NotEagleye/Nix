#!/usr/bin/env bash
# ~/.config/i3/media_control.sh

VOLUME_STEP=5
BRIGHTNESS_STEP=5

ICON_VOL_HIGH=""
ICON_VOL_MUTED=""
ICON_MIC_ACTIVE=""
ICON_MIC_MUTED=""
ICON_BRIGHT=""

get_volume() {
    wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{printf "%.0f", $2 * 100}'
}

is_muted() {
    wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -q "MUTED"
}

send_vol() {
    vol=$(get_volume)

    if is_muted; then
        dunstify -a "Volume" -r 2593 -u low -h int:value:0 " Volume Muted"
    else
        if [ -n "$vol" ]; then
            dunstify -a "Volume" -r 2593 -u low -h int:value:"$vol" "  Volume: ${vol}%"
        else
            dunstify -a "Volume" -r 2593 -u low " Volume Error"
        fi
    fi
}

is_mic_muted() {
    wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | grep -q "MUTED"
}

send_mic() {
    if is_mic_muted; then
        dunstify -a "Microphone" -r 2595 -u low " Microphone Muted"
    else
        mic_vol=$(wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | awk '{print $2}')
        mic_pct=$(echo "$mic_vol * 100" | bc | cut -d'.' -f1)
        dunstify -a "Microphone" -r 2595 -u low -h int:value:"$mic_pct" " Microphone Unmuted"
    fi
}

get_brightness() {
    brightnessctl -m | cut -d',' -f4 | tr -d '%'
}

send_bri() {
    bri=$(get_brightness)
    dunstify -a "Brightness" -r 2594 -u low -h int:value:"$bri" " Brightness: ${bri}%"
}

case "$1" in
    vol_up)
        wpctl set-volume @DEFAULT_AUDIO_SINK@ ${VOLUME_STEP}%+ -l 1.0
        send_vol
        ;;
    vol_down)
        wpctl set-volume @DEFAULT_AUDIO_SINK@ ${VOLUME_STEP}%- -l 1.0
        send_vol
        ;;
    vol_mute)
        wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
        send_vol
        ;;
    mic_mute)
        wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
        send_mic
        ;;
    bri_up)
        brightnessctl set +${BRIGHTNESS_STEP}%
        send_bri
        ;;
    bri_down)
        brightnessctl set ${BRIGHTNESS_STEP}%-
        send_bri
        ;;
esac
