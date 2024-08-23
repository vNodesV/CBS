#!/bin/bash

# Function to get the latest block height of the external network
get_ext_node_latest_height() {
  curl -s $EXT_NODE_RPC/status | jq -r '.result.sync_info.latest_block_height' 2>/dev/null
}

# Function to get the current block height of the local node
get_local_node_current_height() {
  curl -s $LOCAL_NODE_RPC/status | jq -r '.result.sync_info.latest_block_height' 2>/dev/null
}

# Function to calculate the average block time of the external network
get_ext_node_avg_block_time() {
  local latest_block_time=$(curl -s $EXT_NODE_RPC/block | jq -r '.result.block.header.time')
  local earlier_block_time=$(curl -s $EXT_NODE_RPC/block?height=$((latest_height-100)) | jq -r '.result.block.header.time')
  
  # Convert to seconds since epoch
  latest_block_epoch=$(date -d "$latest_block_time" +%s)
  earlier_block_epoch=$(date -d "$earlier_block_time" +%s)
  
  # Calculate time difference
  time_diff=$((latest_block_epoch - earlier_block_epoch))
  
  # Calculate average block time over 100 blocks
  avg_block_time=$((time_diff / 100))
  
  echo $avg_block_time
}
