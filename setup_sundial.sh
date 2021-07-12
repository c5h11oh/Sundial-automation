#!/usr/bin/env bash

# setup_sundial.sh: script runned when first logged in -

# 0. echo "only run this on node0. press enter"
read -p "This script is intended to be run only on node0. Press enter to continue."

# 0.5 run initialize.sh
/opt/db/automation/initialize.sh

# 1. ask name and email for github settings and key generation
# Copied from init.sh made by Kan Wu with some modification
echo "Please enter your email. This is only used for setting up ssh-key and git user.email"
echo -n "Enter email: "
read email
echo "Please enter your name. This is only used for setting up git user.name"
echo -n "Enter name: "
read name
git config --global user.name "$name"
git config --global user.email "$email"

# 2. set up node0's key and send pubkey to other nodes
echo "Generating ed25519 key for communication between nodes. Use default name and location."
sudo rm /users/$USER/.ssh/id_ed25519
ssh-keygen -t ed25519 -C "$email"
echo "Run the following commands in all other nodes."
echo "echo \"`cat /users/$USER/.ssh/id_ed25519.pub`\" >> /users/$USER/.ssh/authorized_keys"
read -p "Press enter when you finish."

# 3. read ifconfig -> set up & collect other nodes' key
read -p "Please ensure that /opt/db/Sundial/ifconfig.txt on this node contains proper information. Press enter to continue."

address=()
while IFS= read  -r line; do # https://stackoverflow.com/questions/47215946/bash-build-array-in-while-loop-does-not-persist
    if [[ $line =~ ^(.*):[0-9]+$ ]]; then
        address+=("${BASH_REMATCH[1]}")
    elif [[ $line == "=l" ]]; then
        break
    else 
        continue
    fi
done < <(cat /opt/db/Sundial/ifconfig.txt)

echo "" > /opt/db/pubkeys.txt
for addr in "${address[@]}"; do
    if [[ $addr == ${address[0]} ]]; then
        continue
    else
        ssh $addr "/opt/db/automation/initialize.sh && git config --global user.name \"$name\" && git config --global user.email \"$email\""
        ssh $addr "sudo rm /users/$USER/.ssh/id_ed25519 && ssh-keygen -t ed25519 -C \"$email\""
        ssh $addr "cat /users/$USER/.ssh/id_ed25519.pub" >> /opt/db/pubkeys.txt
    fi
done

# 4. update authorized_keys in itself and other nodes, and ifconfig.txt in other nodes
cat /opt/db/pubkeys.txt >> /users/$USER/.ssh/authorized_keys
for addr in "${address[@]}"; do
    if [[ $addr == ${address[0]} ]]; then
        continue
    else
        scp /opt/db/pubkeys.txt $addr:/opt/db/pubkeys.txt
        ssh $addr "cat /opt/db/pubkeys.txt >> /users/$USER/.ssh/authorized_keys"
        scp /opt/db/Sundial/ifconfig.txt $addr:/opt/db/Sundial/ifconfig.txt
    fi
done
