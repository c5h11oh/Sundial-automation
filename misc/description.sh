#!/usr/bin/env bash

# the automation folder contains:
# description.sh
# build_sundial_image.sh
# initialize.sh
# setup_sundial.sh
# setup_keys.sh
# redis.conf.modified

# build_sundial_image.sh: script that build up necessary components (and helpful tools) for Sundial -
# 1. install sundial in /opt/db
# 2. init.sh: apt-get update and install in init.sh
# 3. init.sh: clone and make redis in Sundial
# 4. modify tools/conf.sh
# 5. mkdir /opt/db/redis_data
# 6. rename redis.conf to redis.conf.default and copy modified redis.conf
# 7. chmod +x *.sh in Sundial/ and Sundial/tools/
# 8. run setup.sh

# initialize.sh: script automatically runned during cloudlab initialization -
# 1. link Sundial to the home directory
# 2. copy the below "setup_sundial.sh" script to home directory and chmod +x

# setup_sundial.sh: script runned when first logged in -
# 0. echo "only run this on node0. press enter"
# 1. ask name and email for github settings and key generation
# 2. generate ifconfig (who runs redis?) -> propagate the setting to all other nodes
# 3. set up keys for all machines' communication
# instructions to start the system