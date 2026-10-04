#!/bin/bash

# Smart Proxy Switcher
# F9 toggles between proxy disabled and the appropriate hostel proxy.
#
# Daytime: 06:00 - 23:59
# Night:   00:00 - 05:59

MODE=$(gsettings get org.gnome.system.proxy mode)
HOUR=$(date +%H)

if [ "$MODE" = "'none'" ]; then

    if [ "$HOUR" -ge 6 ]; then
        PROXY_HOST="hostelinternet.rgukt.ac.in"
        PERIOD="Day"
    else
        PROXY_HOST="staffnet.rgukt.ac.in"
        PERIOD="Night"
    fi

    PROXY_PORT=3128

    # Configure HTTP proxy
    gsettings set org.gnome.system.proxy.http host "$PROXY_HOST"
    gsettings set org.gnome.system.proxy.http port "$PROXY_PORT"

    # Configure HTTPS proxy
    gsettings set org.gnome.system.proxy.https host "$PROXY_HOST"
    gsettings set org.gnome.system.proxy.https port "$PROXY_PORT"

    # Enable manual proxy
    gsettings set org.gnome.system.proxy mode 'manual'

    notify-send \
        "Smart Proxy Switcher" \
        "$PERIOD proxy enabled: $PROXY_HOST:$PROXY_PORT"

else

    # Disable proxy
    gsettings set org.gnome.system.proxy mode 'none'

    notify-send \
        "Smart Proxy Switcher" \
        "Proxy disabled"

fi
