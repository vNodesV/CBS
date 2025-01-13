#!/bin/bash

get_local_node_current_height() {
  curl -s $LOCAL_NODE_RPC/status | jq -r '.result.sync_info.latest_block_height'
}

get_ext_node_avg_block_time() {
  # This should calculate the average block time
  echo 5  # Placeholder for average block time in seconds
}
