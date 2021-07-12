# TO-DO

## automation_entry.sh
- the environment variable is not kept, change $SUNDIAL to ~/Sundial in the end echo

## init.sh
- transform some personal info to interactive settings

## MISC
- the home folder will be gone, so you need to setup keys again

# DID
- using automation_entry.sh to make tow nodes
- made a disk image on node0
- then node0 marked shutdown on the web UI. VSCODE (SSH) can reach it while it seems to be a new machine. and then it couldn't connect (what else did I do?)
- node0 successfully entered recovery mode. I SSHed it, did nothing, and then reboot the node from web UI. SSH disconnected.
- boot OUT of recovery mode needs to be asked via web UI by clicking again Recovery. Reboot when it is in recovery mode doesn't bring you out.

# IMAGE
- it worked, although the initialization took ~11 mins.
- change: ssh key, ifconfig, git-config in init.sh