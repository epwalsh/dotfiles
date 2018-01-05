#!/bin/bash

NOW_PLAYING=$(osascript <<EOF
if application "Spotify" is running then
	tell application "Spotify"
		if player state is playing then
			return (get artist of current track) & " - " & (get name of current track)
		else
			return ""
		end if
	end tell
else
	return ""
end if
EOF)

echo $NOW_PLAYING
