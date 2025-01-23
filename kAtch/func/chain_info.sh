#!/bin/bash
version="1.0.0"
# Function to get the chain name from the external node
get_chain_name() {
  curl -s $EXT_NODE_RPC/genesis | jq -r '.result.genesis.chain_id' 2>/dev/null
}
