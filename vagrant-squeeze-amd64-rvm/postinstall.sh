#Invoked using Bourne shell

echo '$Rev$' > /etc/basebox_version

#netboot installs virtualbox stuff so we have to remove it
/etc/init.d/virtualbox-ose-guest-utils stop
rmmod vboxguest
aptitude -y purge virtualbox-ose-guest-x11 virtualbox-ose-guest-dkms virtualbox-ose-guest-utils

aptitude update
aptitude -y upgrade
aptitude -y install linux-headers-$(uname -r)
aptitude -y install libpcre3-dev libcurl4-openssl-dev

aptitude clean

#Setting up sudo
cp /etc/sudoers /etc/sudoers.orig
sed -i -e 's/%sudo ALL=(ALL) ALL/%sudo ALL=NOPASSWD:ALL/g' /etc/sudoers

#Installing RVM
REE=ree-1.8.7-2011.03
bash -l -c 'bash < <(curl -s https://rvm.beginrescueend.com/install/rvm)'
bash -l -c "rvm install $REE; rvm use --default $REE"
echo "gem: --no-rdoc --no-ri" > /etc/gemrc

#Installing gems
bash -l -c "gem install chef puppet rvm"

#Installing vagrant keys
mkdir /home/vagrant/.ssh
chmod 700 /home/vagrant/.ssh
cd /home/vagrant/.ssh
wget --no-check-certificate 'https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub' -O authorized_keys
chown -R vagrant /home/vagrant/.ssh
mkdir -p /etc/chef
wget --no-check-certificate 'https://raw.github.com/mitchellh/vagrant/master/keys/vagrant' -O /etc/chef/encrypted_data_bag_secret
chmod 0400 /etc/chef/encrypted_data_bag_secret

#Installing the virtualbox guest additions
VBOX_VERSION=$(cat /home/vagrant/.vbox_version)
cd /tmp
wget http://download.virtualbox.org/virtualbox/$VBOX_VERSION/VBoxGuestAdditions_$VBOX_VERSION.iso
mount -o loop VBoxGuestAdditions_$VBOX_VERSION.iso /mnt
sh /mnt/VBoxLinuxAdditions.run
umount /mnt
rm VBoxGuestAdditions_$VBOX_VERSION.iso


# Zero out the free space to save space in the final image:
dd if=/dev/zero of=/EMPTY bs=10M
rm -f /EMPTY

# Removing leftover leases and persistent rules
echo "cleaning up dhcp leases"
rm /var/lib/dhcp3/*

# Make sure Udev doesn't block our network
# http://6.ptmc.org/?p=164
echo "cleaning up udev rules"
rm /etc/udev/rules.d/70-persistent-net.rules
mkdir /etc/udev/rules.d/70-persistent-net.rules
rm -rf /dev/.udev/
rm /lib/udev/rules.d/75-persistent-net-generator.rules

echo "Adding a 2 sec delay to the interface up, to make the dhclient happy"
echo "pre-up sleep 2" >> /etc/network/interfaces
exit
