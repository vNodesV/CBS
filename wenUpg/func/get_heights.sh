#!/bin/bash

get_local_node_current_height() {
  curl -s $LOCAL_NODE_RPC/status | jq -r '.result.sync_info.latest_block_height'
}

get_ext_node_avg_block_time() {
  # Fetch the timestamp of the latest block
  latest_block_time=$(curl -s $LOCAL_NODE_RPC/block | jq -r '.result.block.header.time')

  # Fetch the timestamp of a block 100 blocks earlier
  earlier_block_height=$(($(get_local_node_current_height) - 100))
  earlier_block_time=$(curl -s $LOCAL_NODE_RPC/block?height=$earlier_block_height | jq -r '.result.block.header.time')

  # Convert timestamps to epoch seconds
  latest_block_epoch=$(date -d "$latest_block_time" +%s)
  earlier_block_epoch=$(date -d "$earlier_block_time" +%s)

  # Calculate the average block time in seconds
  time_difference=$((latest_block_epoch - earlier_block_epoch))
  avg_block_time=$(echo "$time_difference / 100" | bc -l)

  echo "$avg_block_time"
}

