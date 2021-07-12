#!/bin/bash
export AUTOMATION=`pwd`
sudo mkdir /opt/db
sudo chown $USER /opt/db
# cp *.sh /opt/db/
cd /opt/db
git clone https://github.com/ScarletGuo/Sundial.git
cd Sundial
export SUNDIAL=`pwd`
ln -s $SUNDIAL ~/Sundial
git checkout grpc-1pc-redis-dev
# read -p "Be sure you have \"set_authorized_keys.sh\" and \"ifconfig.txt.new\" in $AUTOMATION. Press enter to continue."
# mv ./ifconfig.txt ./ifconfig.txt.old 
# cp $AUTOMATION/ifconfig.txt.new ./ifconfig.txt
# rm -f init.sh && cp $AUTOMATION/*.sh . && chmod +x *.sh
rm -f tools/conf.sh && mv ./conf.sh tools/

# ./set_authorized_keys.sh
./init.sh
# rm ./set_authorized_keys.sh

mkdir /opt/db/redis_data
cp $AUTOMATION/redis_my.conf $SUNDIAL/redis/

cd tools/ && chmod +x * && cd ..
./setup.sh

echo "To run redis: \$SUNDIAL/redis/src/redis-server \$SUNDIAL/redis/redis_my.conf"
echo "To run cornus on single node: python3 test.py CONFIG=experiments/ycsb_debug.json NODE_ID=0 FAILURE_ENABLE=false MODE=compile NUM_NODES=1"
echo "To run cornus on multiple nodes, run the following command on node 0: python3 test_distrib.py CONFIG=experiments/ycsb_debug.json NODE_ID=0 FAILURE_ENABLE=false MODE=debug NUM_NODES=2"
