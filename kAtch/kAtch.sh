#!/bin/bash

# Determine the directory where the script is located
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Load configurations and functions
source "$DIR/config/node_config.sh"
source "$DIR/func/get_heights.sh"
source "$DIR/func/check_status.sh"
source "$DIR/func/chain_info.sh"


# Get the chain name from the external node
chain_name=$(get_chain_name)

# Get the current block height of the local node
current_height=$(get_local_node_current_height)

# Get the latest block height of the external network
latest_height=$(get_ext_node_latest_height)

# Check if the local node is catching up
catching_up=$(is_local_node_catching_up)

# Get the average block time from the external node
avg_block_time=$(get_ext_node_avg_block_time)

# Ensure we have valid data before proceeding
if [[ -z "$current_height" || -z "$latest_height" || -z "$catching_up" || -z "$avg_block_time" ]]; then
  echo "Error: Unable to fetch data from nodes."
  exit 1
fi

# Calculate block difference
block_difference=$((latest_height - current_height))

# Calculate ETA in seconds
eta_seconds=$((block_difference * avg_block_time))

# Convert ETA to hours, minutes, and seconds
eta_hours=$((eta_seconds / 3600))
eta_minutes=$(( (eta_seconds % 3600) / 60 ))
eta_seconds=$((eta_seconds % 60))

# Matrix-like output
echo "### vKatch #############################"
echo "Chain Name: $chain_name"
echo "────────────────────────────"
echo "Puplic Node Height: $latest_height"
echo "Local Node Height: $current_height"
echo "────────────────────────────"
echo "Average Block Time (s): $avg_block_time"
echo "────────────────────────────"
echo "Blocks to Catch Up: $block_difference"
echo "────────────────────────────"
echo "ETA to Catch Up: ${eta_hours}h ${eta_minutes}m ${eta_seconds}s"
echo "########################## vNodes[V] ###"
