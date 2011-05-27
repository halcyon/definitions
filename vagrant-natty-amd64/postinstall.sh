#Invoked using Bourne shell

#Updating the box
aptitude -y install python-software-properties
apt-add-repository ppa:git-core/ppa

aptitude -y update
aptitude -y upgrade

aptitude -y remove apparmor
aptitude -y install linux-headers-$(uname -r)

aptitude -y install build-essential bison openssl libreadline6
aptitude -y install libreadline6-dev curl git-core zlib1g zlib1g-dev
aptitude -y install libssl-dev libyaml-dev libsqlite3-0 libsqlite3-dev
aptitude -y install sqlite3 libxml2-dev libxslt-dev autoconf libc6-dev
aptitude -y install ncurses-dev

aptitude -y purge vim-tiny
aptitude -y install vim-nox

aptitude -y install ruby ruby-dev libopenssl-ruby rdoc ri irb wget ssl-cert

aptitude clean

#install rubygems
wget http://production.cf.rubygems.org/rubygems/rubygems-1.3.7.tgz
tar zxf rubygems-1.3.7.tgz
cd rubygems-1.3.7
ruby setup.rb --no-format-executable
cd
rm -rf rubygems-1.3.7

#Setting up sudo
cp /etc/sudoers /etc/sudoers.orig
sed -i -e 's/%admin ALL=(ALL) ALL/%admin ALL=NOPASSWD:ALL/g' /etc/sudoers

#Installing ruby
#REE=ruby-enterprise-1.8.7-2011.03
#wget http://rubyenterpriseedition.googlecode.com/files/$REE.tar.gz
#tar xzvf $REE.tar.gz
#./$REE/installer -a /opt/ruby --no-dev-docs --dont-install-useful-gems
#echo 'PATH=$PATH:/opt/ruby/bin/'> /etc/profile.d/rubyenterprise.sh
#rm -rf ./$REE/
#rm $REE.tar.gz

#Installing RVM
#bash -l -c 'bash < <(curl -s https://rvm.beginrescueend.com/install/rvm)'
#bash -l -c 'rvm install ree-1.8.7; rvm use --default ree-1.8.7'

#Installing chef & Puppet
bash -l -c 'gem install chef puppet --no-ri --no-rdoc'

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
