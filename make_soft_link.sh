# initialize.sh: script automatically runned during cloudlab initialization -

# Don't run this script directly. Run setup_sundial.sh instead
# 1. link Sundial to the home directory
ln -s /opt/db/Sundial ~/Sundial

# 3. enables vscode-debug (gdb) to attach existing process (Wuh-Chwen)
sudo sysctl -w kernel.yama.ptrace_scope=0

# 4. footnote
echo "remember to change user home directory (e.g. \'kanwu\' appropriately) "
