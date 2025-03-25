#!/bin/bash

# Path to Openbox rc.xml file
RC_FILE="$HOME/.config/openbox/rc.xml"

# Extract Openbox keybindings and their associated actions
keybindings=$(grep -oP '<keybind key="\K[^"]+' "$RC_FILE" | \
    while read -r key; do
        # Extract the associated action/command for each keybind
        action=$(grep -A 2 "<keybind key=\"$key\">" "$RC_FILE" | \
                 grep -oP '<command>\K[^<]+')

        # Try to detect common actions based on the command
        if [[ "$action" == *"workspace"* ]]; then
            workspace_num=$(echo "$action" | grep -oP '\d+')
            action="Switch to Workspace $workspace_num"
        elif [[ "$action" == *"Move"* ]] && [[ "$action" == *"workspace"* ]]; then
            workspace_num=$(echo "$action" | grep -oP '\d+')
            action="Move to Workspace $workspace_num"
        elif [[ "$action" == *"Execute"* ]]; then
            action="Execute command"
        elif [[ "$action" == *"Run"* ]]; then
            action="Run application"
        fi

        # Format output as "KEY - DESCRIPTION"
        echo "$key - $action"
    done)

# Check if keybindings were found
if [[ -z "$keybindings" ]]; then
    echo "No keybindings found."
    exit 1
fi

# Format the output for Rofi
formatted_keybindings=$(echo "$keybindings" | column -t -s '-')

# Display the formatted keybindings in Rofi
selected=$(echo "$formatted_keybindings" | rofi -dmenu -normal-window -i -p "Openbox Keybindings" -line-padding 4 -hide-scrollbar -theme ~/.config/suckless/rofi/keybinds.rasi)

# Check if user selected something
if [ -n "$selected" ]; then
    # Extract the command to execute from the selection
    command=$(echo "$selected" | awk -F' - ' '{print $2}' | xargs)
    if [ -n "$command" ]; then
        # Execute the associated command
        nohup $command &>/dev/null &
    fi
fi
