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

# Get the upgrade block height from configuration or input
upgrade_height=738750  # Replace with the actual upgrade height or fetch dynamically
if [[ -z "$upgrade_height" ]]; then
  echo "Error: Upgrade height not set."
  exit 1
fi

# Get the current block height of the local node
current_height=$(get_local_node_current_height)

# Check if the upgrade height has already been reached
if [[ $current_height -ge $upgrade_height ]]; then
  echo "### wenUpg #############################"
  echo "Chain Name: $chain_name"
  echo "────────────────────────────"
  echo "Upgrade Height: $upgrade_height"
  echo "Current Block Height: $current_height"
  echo "────────────────────────────"
  echo "The upgrade height has already been reached."
  echo "########################## wenUpg[V] ###"
  exit 0
fi

# Calculate blocks remaining until the upgrade height
blocks_remaining=$((upgrade_height - current_height))

# Get the average block time from the local node
avg_block_time=$(get_ext_node_avg_block_time)

# Ensure we have valid data
if [[ -z "$current_height" || -z "$avg_block_time" ]]; then
  echo "Error: Unable to fetch necessary data from nodes."
  exit 1
fi

# Countdown to the upgrade height
echo "Countdown to Upgrade Height:"
while [[ $blocks_remaining -gt 0 ]]; do
  # Clear the line for live updates
  printf "\r"

  # Fetch the latest current block height
  current_height=$(get_local_node_current_height)
  blocks_remaining=$((upgrade_height - current_height))

  # Recalculate ETA
  eta_seconds=$(echo "$blocks_remaining * $avg_block_time" | bc)
  eta_hours=$(echo "$eta_seconds / 3600" | bc)
  eta_minutes=$(echo "($eta_seconds % 3600) / 60" | bc)
  eta_seconds_remaining=$(echo "$eta_seconds % 60" | bc)

  # Display real-time countdown
  printf "Blocks Remaining: %d | ETA: %02dh %02dm %02ds" \
    $blocks_remaining $eta_hours $eta_minutes $eta_seconds_remaining

  # Wait for one second before updating
  sleep 1
done

# Confirm twice that the upgrade height is reached
echo ""
echo "Verifying upgrade height has been reached..."
for attempt in {1..2}; do
  current_height=$(get_local_node_current_height)
  if [[ $current_height -ge $upgrade_height ]]; then
    echo "Confirmation $attempt: Upgrade height reached (Height: $current_height)"
  else
    echo "Confirmation $attempt failed: Current Height: $current_height, Upgrade Height: $upgrade_height"
    exit 1
  fi
  sleep 1  # Wait for a second before the second confirmation
done

# Display success message
echo "### wenUpg #############################"
echo "Chain Name: $chain_name"
echo "────────────────────────────"
echo "Upgrade Height: $upgrade_height"
echo "Current Block Height: $current_height"
echo "────────────────────────────"
echo "The upgrade height has been successfully confirmed."
echo "########################## wenUpg[V] ###"
