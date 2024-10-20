#!/bin/sh

#other code here

quit_all_adobe_apps ()
{
osascript <<EOF
tell application "System Events"
	set adobeApps to displayed name of (every process whose background only is false and (name starts with "Adobe" or name is "Distiller")) as list
end tell

repeat with appName in adobeApps
	set end of adobeApps to appName
end repeat

try
	if adobeApps is not {} then
		repeat with currentApp in adobeApps
			if application currentApp is running then
				try
					tell application currentApp to activate
					tell application currentApp to quit
				end try
			end if
		end repeat
	end if
end try
EOF
}

# other code here

quit_all_adobe_apps