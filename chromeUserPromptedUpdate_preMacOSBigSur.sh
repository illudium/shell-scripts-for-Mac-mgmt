#!/bin/sh

### chrome install update script


logfile="/Library/Logs/GoogleChromeInstallScript.log"

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
  runAsUser osascript -e 'display dialog "(Core Support): Your version of Chrome is out of date, please let it update & then you will need to relaunch Chrome when prompted. Your current tabs will all be restored !" buttons "Ok" default button 1 giving up after (8) with icon caution'
  #runAsUser osascript -e 'display dialog "you will need to relaunch Chrome when prompted. Your current tabs will all be restored" buttons "OK" default button 1 giving up after (300)'
  runAsUser osascript -e 'tell application "Google Chrome" to open location "chrome://help"'
 fi







