# Sundial Auto Deployment on CloudLab
Bash scripts that 1) builds CloudLab bootable images with selected branch from `ScarletGuo/Sundial` and 2) setup the environment, including ssh-keys for nodes' communication, in the created CloudLab experiment.

## Usage
There are two ways to build Sundial instances on CloudLab. One option is to start an experiment with the preconfigured profile on CloudLab, which contains the prebuilt image that gives you branch `grpc-1pc-redis-dev` commit `b6d3800dcfa544d3d83e77d768bcbd4693609469` (as of Jun 18, 2021). The other way is to execute the building scripts on default image nodes by yourself. You can ensure the latest git repo is cloned and you can checkout the branch you prefer.

## Use Preconfigured Profile and Prebuilt Image
### Initiate
To get two-node Sundial, initiate `Sundial-naive-installed` profile. This takes about ~11 minutes to finish.

### Setup
Run `/opt/db/automation/initialize.sh` on every node.

Do the following thing only on node0. Update `ifconfig.txt` in Sundial folder (`~Sundial` and soft linked as `~/Sundial`). Execute `./setup_sundial.sh` and follow the instruction. See `setup_sundial.sh` in `Build Sundial on Your Own` section for detail. 

## Build Sundial on Your Own
The process is made up of three scripts: `build_sundial_image.sh`, `initialize.sh`, and `setup_sundial.sh`. They are expected to be run in the same order as the order being mentioned.

### `build_sundial_image.sh`
This script 1) downloads git repos, packages that Sundial needs, 2) modifies `tools/conf.sh` in Sundial folder to configure library paths, 3) replaces `redis.conf` with `redis.conf.modified`, and 4) runs the `setup.sh` in Sundial folder. Some details worth mentioning:
1. The git repo downloaded are Sundial, Redis, and those installed by Sundial's `setup.sh` (gRPC, cppredit).
2. Packages installed:
   - apt/apt-get: software-properties-common build-essential gcc g++ clang lldb lld gdb cmake git protobuf-compiler libprotobuf-dev flex bison libnuma-dev curl libjemalloc-dev python3-pip dstat vim htop vagrant openjdk-8-jre-headless cgroup-tools numactl
   - pip: pandas
3. Changes in `redis.conf.modified`
   - line 75: commented out `bind 127.0.0.1 -::1`
   - line 94: change `protected-mode` to `no`
   - line 454: change `dir` to `/opt/db/redis_data/`
   - line 1252: change `appendonly` to `yes`
   - line 1281: change `appendfsync` to `always`
4. Sundial is in `/opt/db/Sundial`, Redis is in `/opt/db/Sundial/redis`, `gRPC` and `cpp_redis` are in `/opt/db`. They are not stored in user directory (`/users/*`) because CloudLab doesn't copy items in user directories when generating images. Later we will make a soft link in the user directory.

The prebuilt image is the machine's disk snapshot after running this script.

### `initialize.sh`
*June 20 Update: CloudLab runs this code as user `geniuser`, so the linked `Sundial` and `setup_sundial.sh` will not be in your home directory but `geniuser`'s. Try run this script manually on every nodes, or run `Sundial` from `/users/geniuser/Sundial` or `/opt/db/Sundial`. [Note: Should we just setup as if Sundial are executed from `/opt/db/Sundial` ?]

In CloudLab profile, one can specify what script should be run after a disk image is booted on a node. This is the script for that. 

This script simply soft links `/opt/db/Sundial` to `~/Sundial` so that Sundial can work properly. It also soft links `setup_sundial.sh` to `~/setup_sundial.sh` so that we can find it easier in the next step.

If you build Sundial on your own, you should run this after `build_sundial_image.sh`.

### `setup_sundial.sh`
Before running this script, modifiy `ifconfig.txt` on the first computing node specified in `ifconfig.txt` (node0 hereafter) to be in compliance with the experiment settings. 

This script only needs to be run on node0. This script tries to setup ssh key settings in all nodes (generating keys and sharing public keys with each other) and send `ifconfig.txt` from node0 to all other nodes. 

It does the following:
- Asks your name to set up git `user.name` property, your email to set up git `user.email` property and ssh-keygen `-C` argument. 
- Makes its own key (node0), prompts you to add its public key to all other nodes.
- `ssh` to all other nodes and make keys on each node. Fetch other node's public key.
- make a list of public keys and append them to `~/.ssh/authorized_keys` in all nodes.
- Replace `ifconfig.txt` in all other nodes with node0's `ifconfig.txt`.

Feel free to contect me if you found something is broken or not useful.