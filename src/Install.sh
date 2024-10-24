#!/bin/sh

link="/usr/local/bin/change_niceness"
install_dir="/usr/local/bin/change_niceness_bin"
SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
echo Installing change_niceness

#Remove Previous Installation Links
sudo rm -f "$link"

#Install Executables
sudo mkdir -p "$install_dir"
sudo cp -f "$SCRIPTPATH"/*_* "$install_dir/"
sudo chown -R root:wheel "$install_dir"
sudo chmod 755 "$install_dir"/change_niceness*
sudo xattr -r -d com.apple.quarantine "$install_dir"
sudo chmod u+s "$install_dir"/change_niceness*

#Create Sym Link to correct change_niceness Executable
"$install_dir/change_niceness_arm64" -h > /dev/null 2>&1
if [ $? -eq 0 ]; then
	sudo ln -s "$install_dir/change_niceness_arm64" "$link"
else
	"$install_dir/change_niceness_intel" -h > /dev/null 2>&1
	if [ $? -eq 0 ]; then
		sudo ln -s "$install_dir/change_niceness_intel" "$link"
	else
		sudo ln -s "$install_dir/change_niceness_snowleopard" "$link"
	fi
fi

#modified from https://stackoverflow.com/a/40853418
sudo sed -i bak "/^127\.0\.0\.1/s/.*/127.0.0.1 localhost $(hostname)/" /etc/hosts
sudo sed -i bak "/^::1/s/.*/::1 localhost $(hostname)/" /etc/hosts
echo "Reboot is Required for all Changes to Take Effect"

# Uncomment out this code below if you want to install change_niceness without requiring a reboot.
# Note: this will reboot your wifi which is why We want users to reboot when they can and are not downloading anything

#sudo ifconfig en0 down
#sudo dscacheutil -flushcache
#sudo killall -HUP mDNSResponder
#sudo ifconfig en0 up
