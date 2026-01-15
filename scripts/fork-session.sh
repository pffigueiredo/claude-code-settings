#!/bin/bash
# Open a new terminal in Cursor and fork Claude session

CWD="$(pwd)"
CMD="cd '$CWD' && claude --continue --fork-session"

osascript <<EOF
tell application "System Events"
    tell process "Cursor"
        set frontmost to true
        delay 0.3
        -- Open Command Palette: Cmd+Shift+P
        keystroke "p" using {command down, shift down}
        delay 0.5
        -- Type command to split terminal
        keystroke "Terminal: Split Terminal"
        delay 0.3
        key code 36
        delay 1
        keystroke "$CMD"
        key code 36
    end tell
end tell
EOF
