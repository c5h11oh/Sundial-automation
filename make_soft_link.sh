# initialize.sh: script automatically runned during cloudlab initialization -

# Don't run this script directly. Run setup_sundial.sh instead
# 1. link Sundial to the home directory
ln -s /opt/db/Sundial ~/Sundial

# 2. link "setup_sundial.sh" to home directory and chmod +x
ln -s /opt/db/automation/setup_sundial.sh ~/setup_sundial.sh
chmod +x ~/setup_sundial.sh

# 3. enables vscode-debug (gdb) to attach existing process (Wuh-Chwen)
sudo sysctl -w kernel.yama.ptrace_scope=0