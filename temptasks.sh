#!/bin/bash

# Legacy script

#
# Quick Task Script to automatically start and restart discord
#       bots, because i broke my old one :') feelsbadman
#

# VARIABLES: ----------------------------------------------------------------------
PATH_config=~/task-config.sh
function reloadConfig() {
        source "$PATH_config"
}
reloadConfig

# FUNCTIONS: ----------------------------------------------------------------------

# Starts a single, in $1 specified bot
function startBot() {
        local BOT="$1"
        local PATH_FULL="$PATH_BOTS/$BOT"
        local CMD="./start.sh; node"
        [ -f "$PATH_FULL/bot.js" ] && CMD="node bot.js; node"

        lxterminal --geometry=10x10 -t "Running Bot: $1" -e "cd $PATH_FULL; $CMD"
}

# Calls startBot function for all bots in $LIST_BOTS
function startAllBots() {
        for bot in "${LIST_BOTS[@]}"; do
                startBot "$bot" && echo -e " | Starting Bot: $COL_startbot$bot$COL_reset $COL_path($PATH_BOTS/$bot)$COL_reset"
        done
}

# Kills all running node processes (twice)
function killNode() {
        pkill node && echo -e "$COL_killnode""Klling all node processes!$COL_reset" && pkill node
}

function killThis() {
        pkill $1 && echo -e "$COL_killnode""Klling all $1 processes!$COL_reset" && pkill $1
}

# Prints errors in red (error text is provided $1 variable)
function handleError() {
        echo -e "ERROR: $COL_error$1$COL_reset"
}


# MAIN: ---------------------------------------------------------------------------

function main() {
        reloadConfig
        killThis "luvit"
        killThis "node"
        startAllBots
}


# MAIN LOOP: ----------------------------------------------------------------------
lxterminal --geometry=50x70 -t "Nimwit" -e "cd ~/DiscordBots/Nimwit; ./runNimwit.sh"
lxterminal --geometry=50x70 -t "NationBot" -e "cd ~/DiscordBots/NationBot; ./run.sh"
while true; do
        echo -e "(Re)Starting Bots at $COL_time$(date)$COL_reset" && main
        sleep "$RESTART_SECONDS"

        [ -z "$RESTART_SECONDS" ]                     && handleError "Restart time not specified!"              && exit 1
        [ "$RESTART_SECONDS" -lt "$RESTART_MINIMUM" ] && handleError "Restart Time under allowed minimum-time!" && exit 2

        echo -e "$COL_restart""Restarting Bots!$COL_reset\n"
done
