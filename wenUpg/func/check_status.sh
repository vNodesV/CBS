#!/bin/bash

is_local_node_catching_up() {
  curl -s $LOCAL_NODE_RPC/status | jq -r '.result.sync_info.catching_up'
}
