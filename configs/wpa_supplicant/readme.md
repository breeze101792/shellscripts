start interface service
sudo systemctl start wpa_supplicant@wlan0.service

start systemd-networkd
Create the /etc/systemd/network/25-wlan.network file
