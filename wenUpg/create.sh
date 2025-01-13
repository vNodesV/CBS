#!/bin/bash

# Base directory for the project
BASE_DIR="wenUpg"

# Folders to be created
CONFIG_DIR="$BASE_DIR/config"
FUNC_DIR="$BASE_DIR/func"

# Files to be created
MAIN_SCRIPT="$BASE_DIR/wenUpg.sh"
NODE_CONFIG="$CONFIG_DIR/node_config.sh"
GET_HEIGHTS="$FUNC_DIR/get_heights.sh"
CHECK_STATUS="$FUNC_DIR/check_status.sh"
CHAIN_INFO="$FUNC_DIR/chain_info.sh"

# Create directories
echo "Creating project directories..."
mkdir -p "$CONFIG_DIR" "$FUNC_DIR"

# Create main script
echo "Creating main script: $MAIN_SCRIPT..."
cat << 'EOF' > "$MAIN_SCRIPT"
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
upgrade_height=<REPLACE_WITH_UPGRADE_HEIGHT>  # Replace with the actual upgrade height or fetch dynamically
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
EOF

# Make main script executable
chmod +x "$MAIN_SCRIPT"

# Create node configuration script
echo "Creating node configuration script: $NODE_CONFIG..."
cat << 'EOF' > "$NODE_CONFIG"
# Example node configuration
LOCAL_NODE_RPC="http://127.0.0.1:26657"
EXT_NODE_RPC="http://public-node.rpc.endpoint"
EOF

# Create get_heights function script
echo "Creating get_heights function script: $GET_HEIGHTS..."
cat << 'EOF' > "$GET_HEIGHTS"
#!/bin/bash

get_local_node_current_height() {
  curl -s $LOCAL_NODE_RPC/status | jq -r '.result.sync_info.latest_block_height'
}

get_ext_node_avg_block_time() {
  # This should calculate the average block time
  echo 5  # Placeholder for average block time in seconds
}
EOF

# Create check_status function script
echo "Creating check_status function script: $CHECK_STATUS..."
cat << 'EOF' > "$CHECK_STATUS"
#!/bin/bash

is_local_node_catching_up() {
  curl -s $LOCAL_NODE_RPC/status | jq -r '.result.sync_info.catching_up'
}
EOF

# Create chain_info function script
echo "Creating chain_info function script: $CHAIN_INFO..."
cat << 'EOF' > "$CHAIN_INFO"
#!/bin/bash

get_chain_name() {
  curl -s $EXT_NODE_RPC/status | jq -r '.result.node_info.network'
}
EOF

# Print completion message
echo "Project 'wenUpg' has been created successfully!"
