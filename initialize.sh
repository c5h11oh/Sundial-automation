# initialize.sh: script automatically runned during cloudlab initialization -

# 1. link Sundial to the home directory
ln -s /opt/db/Sundial ~/Sundial

# 2. link "setup_sundial.sh" to home directory and chmod +x
ln -s /opt/db/automation/setup_sundial.sh ~/setup_sundial.sh
chmod +x ~/setup_sundial.sh
