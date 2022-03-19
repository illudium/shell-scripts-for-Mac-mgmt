#!/bin/sh

### chrome update needed notification
### Requirements: swiftDialog, https://github.com/bartreardon/swiftDialog
### Which itself requires macOS 11 (Big Sur) or later
###
### Suggested install location: /usr/local/bin/chromeUserPromptedUpdate.sh
### For associated launchd plist, see https://github.com/illudium/shell-scripts-for-Mac-mgmt/blob/main/com.core.chromeUserPromptedUpdate.plist

currentUser=$(scutil <<< "show State:/Users/ConsoleUser" | awk '/Name :/ { print $3 }')

runAsUser() {
    if [[ $currentUser != "loginwindow" ]]; then
        uid=$(id -u "$currentUser")
        launchctl asuser $uid sudo -u $currentUser "$@"
    fi
 }

if [ ! -f "/Applications/Google Chrome.app/Contents/Info.plist" ]
 then
echo "<result>Chrome isn't installed</result>"
exit 0
fi

INSTALLEDVERSION=$( defaults read "/Applications/Google Chrome.app/Contents/Info.plist" CFBundleShortVersionString )
CURRENTVERSION=$( curl -s https://omahaproxy.appspot.com/history | awk -F',' '/mac,stable/{print $3; exit}' )


if [[ "$INSTALLEDVERSION" == "$CURRENTVERSION" ]]; then
 echo "<result>Chrome is up to date, version $CURRENTVERSION</result>"

 else

 echo "<result>Chrome is out of date</result>"
  runAsUser  /usr/local/bin/dialog --titlefont "colour=$color,size=24" --ontop --title 'Chrome udpate needed (IT-Automated check):' --button1text "Click to Continue..." --message "Sorry to interrupt, but your version of Chrome is out of date.  \nNot to worry ! :-) We can get that fixed now...  \n  \nPlease click Continue (below) to start the update process.  \n  \nNOTE: You'll need to relaunch your Chrome browser when prompted.  \nYour current tabs will all be restored."
  runAsUser osascript -e 'tell application "Google Chrome" to open location "chrome://help"'
fi
