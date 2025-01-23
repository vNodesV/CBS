#!/bin/bash
version="1.0.0"
# Function to check if the local node is catching up
is_local_node_catching_up() {
  curl -s $LOCAL_NODE_RPC/status | jq -r '.result.sync_info.catching_up' 2>/dev/null
}
