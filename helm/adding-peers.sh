#!/bin/bash

# Step 1: Port forward to the Besu node's RPC port
kubectl port-forward besu-node-bootnode-1-0 8545:8545 -n quorum &
sleep 5
kubectl port-forward besu-node-validator-1-0 8546:8545 -n quorum &
sleep 5
kubectl port-forward besu-node-validator-2-0 8547:8545 -n quorum &
sleep 5
kubectl port-forward besu-node-validator-3-0 8548:8545 -n quorum &
sleep 5
kubectl port-forward besu-node-validator-4-0 8549:8545 -n quorum &
sleep 5
kubectl port-forward besu-node-rpc-1-0  8550:8545 -n quorum &

# Wait for the port-forward to be established
sleep 5

# Step 2: Use curl to get the enode URL from the node's admin_nodeInfo
enode_url=$(curl -s -X POST --data '{"jsonrpc":"2.0","method":"admin_nodeInfo","params":[],"id":1}' http://127.0.0.1:8545 | jq -r '.result.enode')

# Step 3: Verify that enode_url is retrieved
if [ -z "$enode_url" ]; then
  echo "Failed to retrieve enode URL"
  exit 1
else
  echo "Enode URL retrieved: $enode_url"
fi

BOOTNODE_CLUSTER_IP=$(kubectl get svc besu-node-bootnode-1 -n quorum -o jsonpath='{.spec.clusterIP}')
enode_url="${enode_url/0.0.0.0/$BOOTNODE_CLUSTER_IP}"
echo $enode_url
## Step 4: Add the peer using the retrieved enode URL
#peer_ip="34.118.228.127"  # Replace with the correct IP address of the peer node
#peer_enode="${enode_url%@*}@$peer_ip:30303"  # Combine the enode key and the peer's IP

curl -X POST --data "{\"jsonrpc\":\"2.0\",\"method\":\"admin_addPeer\",\"params\":[\"$enode_url\"],\"id\":1}" http://127.0.0.1:8546
sleep 5
curl -X POST --data "{\"jsonrpc\":\"2.0\",\"method\":\"admin_addPeer\",\"params\":[\"$enode_url\"],\"id\":1}" http://127.0.0.1:8547
sleep 5
curl -X POST --data "{\"jsonrpc\":\"2.0\",\"method\":\"admin_addPeer\",\"params\":[\"$enode_url\"],\"id\":1}" http://127.0.0.1:8548
sleep 5
curl -X POST --data "{\"jsonrpc\":\"2.0\",\"method\":\"admin_addPeer\",\"params\":[\"$enode_url\"],\"id\":1}" http://127.0.0.1:8549
curl -X POST --data "{\"jsonrpc\":\"2.0\",\"method\":\"admin_addPeer\",\"params\":[\"$enode_url\"],\"id\":1}" http://127.0.0.1:8550
