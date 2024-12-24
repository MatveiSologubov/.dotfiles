sudo pacman -S qemu virt-manager virt-viewer dnsmasq vde2 bridge-utils openbsd-netcat

sudo systemctl start libvirtd

sudo systemctl enable libvirtd

sudo echo "unix_sock_group = \"libvirt\"" >> /etc/libvirt/libvirtd.conf
sudo echo "unix_sock_ro_perms = \"0777\"" >> /etc/libvirt/libvirtd.conf
sudo echo "unix_sock_rw_perms = \"0770\"" >> /etc/libvirt/libvirtd.conf

sudo usermod -aG libvirt disco

