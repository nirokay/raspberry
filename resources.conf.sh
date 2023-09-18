#!/bin/bash
# Resources for this repo

# Location of this repo
export RASPBERRY_FILES=~/raspberry

# Discord bots
export DISCORD_BOT_LOCATION=~/DiscordBots
export DISCORD_BOTS=( Nimwit NationBot LunaLoop )
export DISCORD_BOTS_RESTART_SECONDS=172800 # 48h

# Main file, that starts all tasks
export STARTUP_FILE="$RASPBERRY_FILES/temptasks.sh"

