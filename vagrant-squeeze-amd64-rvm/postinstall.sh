#Invoked using Bourne shell

echo '$Rev$' > /etc/basebox_version

sed -i "s/^.*requiretty/#Defaults requiretty/" /etc/sudoers
echo "Defaults always_set_home" >> /etc/sudoers

cat >> /etc/apt/sources.list <<-EOF
	
	deb http://http.us.debian.org/debian squeeze main
	deb-src http://http.us.debian.org/debian squeeze main
EOF
aptitude update
aptitude install -y libssl0.9.8=0.9.8o-4squeeze1 libssl-dev=0.9.8o-4squeeze1
aptitude clean

#Installing RVM
REE=ree-1.8.7-2011.03
bash -l -c 'bash < <(curl -s https://rvm.beginrescueend.com/install/rvm)'
bash -l -c "rvm install $REE; rvm use --default $REE"
echo "gem: --no-rdoc --no-ri" > /etc/gemrc

#Installing chef & Puppet
bash -l -c "gem install chef puppet"

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
#Commented out because Debian Sid provides packaged versions of these that are CURRENT
#VBOX_VERSION=$(cat /home/vagrant/.vbox_version)
#cd /tmp
#wget http://download.virtualbox.org/virtualbox/$VBOX_VERSION/VBoxGuestAdditions_$VBOX_VERSION.iso
#mount -o loop VBoxGuestAdditions_$VBOX_VERSION.iso /mnt
#sh /mnt/VBoxLinuxAdditions.run
#umount /mnt
#rm VBoxGuestAdditions_$VBOX_VERSION.iso

echo 'MTAuMy4xMDIuOTUJemVkZHdvcmtzLmNvbQo=' | openssl enc -base64 -d >> /etc/hosts

exit
