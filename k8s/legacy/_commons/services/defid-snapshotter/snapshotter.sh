#!/bin/sh

echo "Installing dependencies.."
yum install tar gzip jq -y

while :
do
    INITIAL_BLOCK_DOWNLOAD=$(curl -s --location $RPC_URL --header 'Content-Type: application/json' --data '{ "jsonrpc": "2.0", "id": "getinfo", "method": "getblockchaininfo", "params": [] }' | jq '.result.initialblockdownload')
    CURRENT_BLOCKS=$(curl -s --location $RPC_URL --header 'Content-Type: application/json' --data '{ "jsonrpc": "2.0", "id": "getinfo", "method": "getblockchaininfo", "params": [] }' | jq '.result.blocks')
    CURRENT_HEADERS=$(curl -s --location $RPC_URL --header 'Content-Type: application/json' --data '{ "jsonrpc": "2.0", "id": "getinfo", "method": "getblockchaininfo", "params": [] }' | jq '.result.headers')

    echo "Verifying sync status. INITIAL_BLOCK_DOWNLOAD=$INITIAL_BLOCK_DOWNLOAD | CURRENT_HEADERS=$CURRENT_HEADERS | CURRENT_BLOCKS=$CURRENT_BLOCKS"
    if [ $INITIAL_BLOCK_DOWNLOAD = "false" ] && [ $(($CURRENT_HEADERS - $CURRENT_BLOCKS)) -lt 10 ]
        then break
    else
        echo "Defid is still synching. Blocks: $CURRENT_BLOCKS. Headers: $CURRENT_HEADERS." && sleep 30s
    fi
done

echo "Fully synced! Stopping defid service.."
export DEFID_BLOCKHEIGHT=$(curl -s --location $RPC_URL --header 'Content-Type: application/json' --data '{ "jsonrpc": "2.0", "id": "getinfo", "method": "getblockchaininfo", "params": [] }' | jq '.result.blocks')
curl -s --location $RPC_URL --header 'Content-Type: application/json' --data '{ "jsonrpc": "2.0", "id": "stop", "method": "stop", "params": [] }'
sleep 30s

echo "Archiving..."
tar -czvf /snapshot/defid-$DEFID_BLOCKHEIGHT.tar.gz -C $DEFID_PATH anchors blocks burn chainstate enhancedcs evm history indexes vault

echo "Uploading..."
aws s3 cp /snapshot/defid-$DEFID_BLOCKHEIGHT.tar.gz s3://$BUCKET_NAME/defid-$DEFID_BLOCKHEIGHT.tar.gz
aws s3 cp s3://$BUCKET_NAME/defid-$DEFID_BLOCKHEIGHT.tar.gz s3://$BUCKET_NAME/defid.tar.gz

echo "Done!"