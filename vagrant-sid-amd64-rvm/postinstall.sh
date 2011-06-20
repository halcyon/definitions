#Invoked using Bourne shell

echo '$Rev$' > /etc/basebox_version

libssl="libssl0.9.8_0.9.8o-4squeeze1_amd64.deb"
libssldev="libssl-dev_0.9.8o-4squeeze1_amd64.deb"
wget http://http.us.debian.org/debian/pool/main/o/openssl/$libssl
wget http://http.us.debian.org/debian/pool/main/o/openssl/$libssldev
dpkg -i $libssl
dpkg -i $libssldev
rm $libssl
rm $libssldev
aptitude hold libssl-dev libssl0.9.8
aptitude clean

#Setting up sudo
sed -i -e 's/%sudo	ALL=(ALL:ALL) ALL/%sudo	ALL=(ALL:ALL) NOPASSWD:ALL/g' /etc/sudoers

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

echo 'MTAuMy4xMDIuOTUJemVkZHdvcmtzLmNvbQo=' | openssl enc -base64 -d >> /etc/hosts
