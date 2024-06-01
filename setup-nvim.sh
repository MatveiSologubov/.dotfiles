SCRIPT_DIR=""$(dirname "$0")"/nvim"

CONFIG_DIR="$(echo $HOME)/.config/"

rm -rf $CONFIG_DIR/nvim 

cp -r $SCRIPT_DIR $CONFIG_DIR

