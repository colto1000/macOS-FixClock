#!/bin/sh

##
## Script by Colton Nicholas
##
## Some Code referenced from https://www.reddit.com/r/MacOS/comments/17oznvu/comment/k93fe2d
##  and https://community.jamf.com/t5/jamf-pro/force-checking-quot-set-time-zone-automatically-using-current/m-p/266337
##  and https://stackoverflow.com/a/71623262
##  and https://gist.github.com/krohne/298c6393cf3dd6063b054dd297ba7714
##  and https://apple.stackexchange.com/a/233381
##
##
## Tested with macOS Sonoma 14.1.2 to fix issues with time synchronization.
##

# Elevation to root
if [ "$EUID" -ne 0 ]
then
    exec sudo -s "$0" "$@"
fi

echo " ** Deleting com.apple.timed.plist..."
rm /var/db/timed/com.apple.timed.plist

sleep 1

echo " ** Enabling Location Services..."
/usr/bin/defaults write /var/db/locationd/Library/Preferences/ByHost/com.apple.locationd LocationServicesEnabled -int 1
uuid=$(/usr/sbin/system_profiler SPHardwareDataType | grep "Hardware UUID" | cut -c22-57)
/usr/bin/defaults write /var/db/locationd/Library/Preferences/ByHost/com.apple.locationd.$uuid LocationServicesEnabled -int 1

sleep 1

echo " ** Configuring Automatic Timezone..."
/usr/bin/defaults write /Library/Preferences/com.apple.timezone.auto Active -bool YES
/usr/bin/defaults write /private/var/db/timed/Library/Preferences/com.apple.timed.plist TMAutomaticTimeOnlyEnabled -bool YES
/usr/bin/defaults write /private/var/db/timed/Library/Preferences/com.apple.timed.plist TMAutomaticTimeZoneEnabled -bool YES
/usr/sbin/systemsetup -setusingnetworktime on
/usr/sbin/systemsetup -gettimezone
/usr/sbin/systemsetup -getnetworktimeserver

#sleep 1

secs=10
while [ $secs -ge 1 ]
do
	printf "\r\033[K ** Rebooting in %.d seconds..." $((secs--))
	sleep 1
done

echo "\n ** Rebooting now."
#reboot
rm ~/Library/Preferences/ByHost/com.apple.loginwindow.*.plist # Do not reopen Windows on boot
osascript -e 'tell application "System Events" to restart' # macOS Soft Reboot

# Should never reach this point if reboot succeeds
sudo -k
