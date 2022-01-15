#!/usr/bin/env bash

echo "⚠️  WARNING ⚠️  - This will delete ALL LOCAL NFT data."
echo -n "Don't do this unless you're testing, or all your NFTs have been pinned. "
echo -n "Proceed? (y/n) "
read yesno < /dev/tty

if [ "x$yesno" = "xy" ];then
    rm -rfv ipfs-data/*
    touch ipfs-data/.gitkeep

    rm -rfv mint-data/*
    touch mint-data/.gitkeep

    echo "🧹 DONE 🧹 (Generated contracts were not removed.)"
else

    echo "Aborting."
    exit 1
fi
