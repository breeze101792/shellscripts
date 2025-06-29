mkdir ~/.config/sway
mkdir ~/.config/waybar

ln -s $(realpath sway.config) ~/.config/sway/config
ln -s $(realpath waybar)/* ~/.config/waybar/
