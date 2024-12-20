#!/bin/bash

if [ $# -eq 2 ];
then
	FLAG=$1
	RICE_DIR=$2
fi

if [ $# -eq 1 ];
then
	RICE_DIR=$1
fi

I3_CONFIG_DIR=~/.config/i3/
KITTY_CONFIG_DIR=~/.config/kitty/
POLYBAR_CONFIG_DIR=~/.config/polybar/
TMUX_CONFIG_DIR=~/.config/tmux/
ZSH_DIR=~

I3_CONFIG="config"
KITTY_CONFIG="kitty.conf"
POLYBAR_CONFIG="config.ini"
TMUX_CONFIG="tmux.conf"
ZSH_CONFIG=".zshrc" # an rc file, so I'm in doubt if "config" should be used here

usage()
{
	echo "usage: ricecooker --flags(optional) \"RICE_DIR\"" && exit 1
}

apply_rice()
{
echo "$RICE_DIR rice applied successfully."
xdotool key ctrl+shift+F5
i3-msg restart
source ~/.zshrc # This actually doesn't carry any effect on currently running terminals.
# You'll have to start new terminals in order to see the actual changes.
}

change_config_files()
{
cd $RICE_DIR && cp $I3_CONFIG $I3_CONFIG_DIR \
			 && cp $KITTY_CONFIG $KITTY_CONFIG_DIR \
			 && cp $POLYBAR_CONFIG $POLYBAR_CONFIG_DIR \
			 && cp $TMUX_CONFIG $TMUX_CONFIG_DIR 	   \
			 && cp $ZSH_CONFIG $ZSH_DIR \
			 && apply_rice
}

main()
{
if [ -d $RICE_DIR ];
then
	if [ $# -eq 1 ];
	then
		echo "Applying $RICE_DIR. Do you wish to continue?(y/N)"
		read YN
		[ "$YN" == "y" ] && change_config_files || echo "No changes have been made." && exit 0
	fi

	if [ $# -eq 2 ];
	then
		[ "$FLAG" = "--no-check" -o "$FLAG" = "-n" ] && change_config_files
	fi
else
	echo -e "Directory $RICE_DIR not found!\nPlease input a valid directory."
fi
}

[ $# -eq 1 -o $# -eq 2 ] && main $@ || usage
