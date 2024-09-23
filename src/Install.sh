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
