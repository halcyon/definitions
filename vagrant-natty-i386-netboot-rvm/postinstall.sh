#http://adrianbravo.tumblr.com/post/644860401

#Updating the box
aptitude -y update
#aptitude -y upgrade
aptitude -y remove apparmor
aptitude -y install linux-headers-$(uname -r) build-essential
aptitude -y install zlib1g-dev libssl-dev libreadline5-dev
aptitude clean

#Setting up sudo
cp /etc/sudoers /etc/sudoers.orig
sed -i -e 's/%admin ALL=(ALL) ALL/%admin ALL=NOPASSWD:ALL/g' /etc/sudoers

#Installing ruby
REE=ruby-enterprise-1.8.7-2011.03
wget http://rubyenterpriseedition.googlecode.com/files/$REE.tar.gz
tar xzvf $REE.tar.gz
./$REE/installer -a /opt/ruby --no-dev-docs --dont-install-useful-gems
echo 'PATH=$PATH:/opt/ruby/bin/'> /etc/profile.d/rubyenterprise.sh
rm -rf ./$REE/
rm $REE.tar.gz

#Installing chef & Puppet
/opt/ruby/bin/gem install chef --no-ri --no-rdoc
/opt/ruby/bin/gem install puppet --no-ri --no-rdoc

#Installing vagrant keys
mkdir /home/vagrant/.ssh
chmod 700 /home/vagrant/.ssh
cd /home/vagrant/.ssh
wget --no-check-certificate 'http://github.com/mitchellh/vagrant/raw/master/keys/vagrant.pub' -O authorized_keys
chown -R vagrant /home/vagrant/.ssh

#Installing the virtualbox guest additions
VBOX_VERSION=$(cat /home/vagrant/.vbox_version)
aptitude purge -y virtualbox-ose-guest-dkms
aptitude purge -y virtualbox-ose-guest-utils
aptitude purge -y virtualbox-ose-guest-x11
cd /tmp
wget http://download.virtualbox.org/virtualbox/$VBOX_VERSION/VBoxGuestAdditions_$VBOX_VERSION.iso
mount -o loop VBoxGuestAdditions_$VBOX_VERSION.iso /mnt
sh /mnt/VBoxLinuxAdditions.run
umount /mnt

rm VBoxGuestAdditions_$VBOX_VERSION.iso
exit
