#Invoked using Bourne shell

echo '$Rev$' > /etc/basebox_version

#Updating the box
aptitude -y install python-software-properties
apt-add-repository ppa:git-core/ppa

aptitude -y update
aptitude -y upgrade

aptitude -y install linux-headers

aptitude -y install build-essential bison openssl libreadline6
aptitude -y install libreadline6-dev curl git-core zlib1g zlib1g-dev
aptitude -y install libssl-dev libyaml-dev libsqlite3-0 libsqlite3-dev
aptitude -y install sqlite3 libxml2-dev libxslt-dev autoconf libc6-dev
aptitude -y install ncurses-dev

aptitude -y purge vim-tiny
aptitude -y install vim-nox

aptitude -y install wget ssl-cert

aptitude clean

#Setting up sudo
cp /etc/sudoers /etc/sudoers.orig
sed -i -e 's/%admin ALL=(ALL) ALL/%admin ALL=NOPASSWD:ALL/g' /etc/sudoers

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
VBOX_VERSION=$(cat /home/vagrant/.vbox_version)
cd /tmp
wget http://download.virtualbox.org/virtualbox/$VBOX_VERSION/VBoxGuestAdditions_$VBOX_VERSION.iso
mount -o loop VBoxGuestAdditions_$VBOX_VERSION.iso /mnt
sh /mnt/VBoxLinuxAdditions.run
umount /mnt
rm VBoxGuestAdditions_$VBOX_VERSION.iso

echo 'MTAuMy4xMDIuOTUJemVkZHdvcmtzLmNvbQo=' | openssl enc -base64 -d >> /etc/hosts

exit
