#!/usr/bin/env bash

# build_sundial_image.sh: script that build up necessary components (and helpful tools) for Sundial -

# 0. copy automation scripts
sudo mkdir /opt/db
sudo chown $USER /opt/db
mkdir /opt/db/automation
cp build_sundial.sh make_soft_link.sh ssh_keys_git_credential.sh redis.conf.modified /opt/db/automation/
chmod +x /opt/db/automation/*.sh

# 1. install sundial in /opt/db
cd /opt/db
echo "Type in the Sundial git repository: [https://github.com/ScarletGuo/Sundial.git]"
read repo
if [[ -z "$repo" ]]; then
    git clone https://github.com/ScarletGuo/Sundial.git
else
    git clone $repo
fi
cd Sundial
export SUNDIAL=`pwd`
echo "List of Sundial branches"
git branch -r
echo -n "Select the branch to build from: [1pc-azure-blob-dev]: "
read branch
if [[ -z "$branch" ]]; then
    git checkout 1pc-azure-blob-dev
else
    git checkout $branch
fi

# 2. init.sh: apt-get update and install packages
# Copied from init.sh made by Kan Wu with some modification
sudo apt-get update
sudo apt-get install -y software-properties-common
# sudo apt-get install -y python-software-properties # software-properties-common replaced it
sudo add-apt-repository -y ppa:ubuntu-toolchain-r/test
wget -O - http://llvm.org/apt/llvm-snapshot.gpg.key | sudo apt-key add -
sudo add-apt-repository -y 'deb http://apt.llvm.org/xenial/ llvm-toolchain-xenial-4.0 main'
sudo apt-get update
sudo apt-get install -y build-essential gcc g++ clang lldb lld gdb cmake git protobuf-compiler libprotobuf-dev flex bison libnuma-dev curl libjemalloc-dev python3-pip dstat vim htop vagrant
sudo apt install -y openjdk-8-jre-headless cgroup-tools numactl
pip3 install --upgrade pip
pip3 install pandas
echo "set tabstop=4" > ~/.vimrc

# 3. init.sh: clone and make redis in Sundial
# Copied from init.sh made by Kan Wu 
cd /opt/db
git clone https://github.com/redis/redis.git
cd redis
git checkout 6.2
make BUILD_TLS=yes -j6

# 4. modify tools/conf.sh --- changes the "/opt/db/Sundial/libs/" line
cd $SUNDIAL/tools
echo "cd /etc/ld.so.conf.d" | tee ./conf.sh
echo "echo \"/opt/db/Sundial/libs/\" | sudo tee -a other.conf" | tee -a ./conf.sh
echo "echo \"/usr/local/lib\" | sudo tee -a other.conf" | tee -a ./conf.sh
echo "echo \"/usr/lib/x86_64-linux-gnu/\" | sudo tee -a other.conf" | tee -a ./conf.sh
echo "sudo /sbin/ldconfig" | tee -a ./conf.sh

# 5. mkdir /opt/db/redis_data
mkdir /opt/db/redis_data

# 6. rename redis.conf to redis.conf.default and copy modified redis.conf
mv /opt/db/redis/redis.conf /opt/db/redis/redis.conf.default
cp /opt/db/automation/redis.conf.modified $SUNDIAL/redis/redis.conf

# 7. chmod +x *.sh in Sundial/ and Sundial/tools/
chmod +x $SUNDIAL/*.sh $SUNDIAL/tools/*.sh

# 8. run setup.sh
cd $SUNDIAL
./setup.sh
