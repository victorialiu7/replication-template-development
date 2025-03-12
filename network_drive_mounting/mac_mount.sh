#!/bin/bash


#!/bin/bash

# Copy script from Azure website 
# Directions in Readme under "Mounting a Network Drive for Macs"
fileShareScript=smb://victoriaaeabitbucket:w2QumdNGuFCnqY%2BG0S7fjoMv%2BVNi%2F8%2BlS2V9NyKsTbyACN7N5urIrmwKe117302O%2BB5U5WTruLgV%2BAStUoYHiA%3D%3D@victoriaaeabitbucket.file.core.windows.net/aearep-6173

# Connect to Azure File Share
# Make sure port 445 is available (not blocked or used)
open $fileShareScript

# Wait for the connection to establish
sleep 5

# Add the mounted SMB share to Finder sidebar using AppleScript
# Make sure to give VScode access to System Events
# 1. 
# 2. 
osascript <<EOF
tell application "Finder"
   activate
   delay 1
   set theFolder to POSIX file "/Volumes/$fileShare" as alias
   select theFolder
   tell application "System Events"
       tell process "Finder"
           keystroke "t" using {command down, control down}
       end tell
   end tell
end tell
EOF
