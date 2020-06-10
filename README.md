# OpenWRT Wifi Telegraf input plugin

This small script collects metrics about connected wifi clients and returns them in a format telegraf understands.

This script has been tested on a Turris Omnia and Telegraf for ARM.

## Installation
```
cp iw_wifi.sh /usr/bin/iw_wifi.sh
chmod u+x /usr/bin/iw_wifi.sh
```

Add the following snipplet to your telegraf configuration
```
[[inputs.exec]]
  ## Commands array
  commands = [
    "/usr/bin/iw_wifi.sh wlan0 wlan1"
  ]

  ## Timeout for each command to complete.
  timeout = "5s"
```

If this doesn't work for your openwrt model please create a PR