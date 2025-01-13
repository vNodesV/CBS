#!/bin/bash

get_chain_name() {
  curl -s $EXT_NODE_RPC/status | jq -r '.result.node_info.network'
}
