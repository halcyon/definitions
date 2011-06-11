#Invoked using Bourne shell

echo '$Rev$' > /etc/basebox_version

#Setting up sudo
sed -i -e 's/%sudo	ALL=(ALL:ALL) ALL/%sudo	ALL=(ALL:ALL) NOPASSWD:ALL/g' /etc/sudoers

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

exit