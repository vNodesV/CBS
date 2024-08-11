#!/bin/bash

# Function to get the latest block height of the external network
get_ext_node_latest_height() {
  curl -s $EXT_NODE_RPC/status | jq -r '.result.sync_info.latest_block_height' 2>/dev/null
}

# Function to get the current block height of the local node
get_local_node_current_height() {
  curl -s $LOCAL_NODE_RPC/status | jq -r '.result.sync_info.latest_block_height' 2>/dev/null
}

# Function to get the average block time of the external network
get_ext_node_avg_block_time() {
  curl -s $EXT_NODE_RPC/status | jq -r '.result.sync_info.latest_block_time' 2>/dev/null
}
