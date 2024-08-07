#!/bin/bash

# Replace this with the actual RPC address of your trusted node and daemon
NODE_RPC="https://rpc.testnet.elys.network"
DAEMON="elysd"

# Function to get the latehst block height of the network
get_latest_height() {
  curl -s $NODE_RPC/status | jq -r '.result.sync_info.latest_block_height' 2>/dev/null
}

# Function to get the current block height of your node using ping
get_current_height_ping() {
  $DAEMON query block | jq -r '.block.header.height' 2>/dev/null
}

# Function to check if the node is catching up
is_catching_up() {
  $DAEMON status | jq -r '.SyncInfo.catching_up' 2>/dev/null
}

# Get the current block height
current_height=$(get_current_height_ping)

# Get the latest block height
latest_height=$(get_latest_height)

# Check if the node is catching up
catching_up=$(is_catching_up)

# Ensure we have valid heights before proceeding
if [[ -z "$current_height" || -z "$latest_height" || -z "$catching_up" ]]; then
  echo "Error: Unable to fetch block heights or catching up status."
  exit 1
fi

# Calculate block difference
block_difference=$((latest_height - current_height))

# Assuming an average block time (e.g., 6 seconds)
average_block_time=4

# Calculate ETA in seconds
eta_seconds=$((block_difference * average_block_time))

# Convert ETA to hours, minutes, and seconds
eta_hours=$((eta_seconds / 3600))
eta_minutes=$(( (eta_seconds % 3600) / 60 ))
eta_seconds=$((eta_seconds % 60))


# echo "Catching Up: $catching_up"
echo "Chain's Height: $current_height"
echo "Your Height: $latest_height"
echo "Blocks to Catch Up: $block_difference"

if [[ "$catching_up" == "true" ]]; then
  if [[ $block_difference -gt 0 ]]; then
    echo "Estimated Time to Catch Up: ${eta_hours}h ${eta_minutes}m ${eta_seconds}s"
  else
    echo "Your node is ahead of or at the latest network block height."
  fi
else
  echo "Your node is up to date."
fi