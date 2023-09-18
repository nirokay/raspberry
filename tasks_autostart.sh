#!/bin/bash

# Legacy script - temporarily made to run without gui

#
# Quick Task Script to automatically start and restart discord
#       bots, because i broke my old one :') feelsbadman
#

# shellcheck disable=SC1090
source ~/raspberry/helpers.sh

# VARIABLES: ----------------------------------------------------------------------
PATH_config=~/task-config.sh
function reloadConfig() {
        # shellcheck disable=SC1090
        source "$PATH_config"
}
reloadConfig

# FUNCTIONS: ----------------------------------------------------------------------

# Starts a single, in $1 specified, bot
function startBot() {
        local BOT="$1"
        local PATH_FULL="$PATH_BOTS/$BOT"
        local CMD="./start.sh; node"
        [ -f "$PATH_FULL/bot.js" ] && CMD="node bot.js; node"

        local FULL_CMD="cd $PATH_FULL && $CMD"
        $FULL_CMD &
        disown $!
}

function runBotScript() {
        local BOT="$1"
        local SCRIPT="$2"

        local PATH_FULL="$PATH_BOTS/$BOT"
        local FULL_CMD="cd $PATH_FULL && $SCRIPT"

        $FULL_CMD &
        disown $!
}



# Calls startBot function for all bots in $LIST_BOTS
function startAllBots() {
        for bot in "${LIST_BOTS[@]}"; do
                startBot "$bot" && echo -e " | Starting Bot: $COL_startbot$bot$COL_reset $COL_path($PATH_BOTS/$bot)$COL_reset"
        done
}

# Kills all running processes (twice)
function killThis() {
        pkill "$1" && echo -e "$COL_killnode""Klling all $1 processes!$COL_reset" && pkill "$1"
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
runBotScript "Nimwit" "./runNimwit.sh"
runBotScript "NationBot" "./run.sh"

while true; do
        echo -e "(Re)Starting Bots at $COL_time$(date)$COL_reset" && main
        sleep "$RESTART_SECONDS"

        [ -z "$RESTART_SECONDS" ]                     && handleError "Restart time not specified!"              && exit 1
        [ "$RESTART_SECONDS" -lt "$RESTART_MINIMUM" ] && handleError "Restart Time under allowed minimum-time!" && exit 2

        echo -e "$COL_restart""Restarting Bots!$COL_reset\n"
done
