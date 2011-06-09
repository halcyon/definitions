#Invoked using Bourne shell

echo '$Rev$' > /etc/basebox_version

cat > /etc/yum.repos.d/public-yum.repo <<-EOF
	[ol5_u6_base]
	name=Oracle Linux 5 - U6 - x86_64 - base
	baseurl=http://public-yum.oracle.com/repo/OracleLinux/OL5/6/base/x86_64
	gpgkey=http://public-yum.oracle.com/RPM-GPG-KEY-oracle-el5
	gpgcheck=1
	enabled=1

	[epel]
	name=epel 5 - x86_64
	baseurl=http://download.fedoraproject.org/pub/epel/5/x86_64
	gpgkey=http://download.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL
	gpgcheck=1
	enabled=1

	[aegisco]
	name=AegisCo rhel5 - x86_64
	baseurl=http://rpm.aegisco.com/aegisco/rhel/5/x86_64
	gpgkey=http://rpm.aegisco.com/aegisco/RPM-GPG-KEY-aegisco
	gpgcheck=1
	enabled=1
EOF

yum -y upgrade

#kernel source is needed for vbox additions

yum -y install kernel-uek-devel
#yum -y install gcc bzip2 make kernel-devel-`uname -r`

yum -y install gcc gcc-c++ zlib-devel openssl-devel readline-devel sqlite3-devel

yum -y install git curl

yum -y clean all

#Installing RVM
REE="ree-1.8.7-2011.03"
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

VBOX_VERSION=$(cat /home/vagrant/.vbox_version)
#Installing the virtualbox guest additions
cd /tmp
wget http://download.virtualbox.org/virtualbox/$VBOX_VERSION/VBoxGuestAdditions_$VBOX_VERSION.iso   
mount -o loop VBoxGuestAdditions_$VBOX_VERSION.iso /mnt
sh /mnt/VBoxLinuxAdditions.run
umount /mnt

rm VBoxGuestAdditions_$VBOX_VERSION.iso

sed -i "s/^.*requiretty/#Defaults requiretty/" /etc/sudoers
echo "Defaults always_set_home" >> /etc/sudoers

sed -i '/HOSTNAME/d' /etc/sysconfig/network
echo 'HOSTNAME=vagrant-oel56-amd64' >> /etc/sysconfig/network

sed -i '$d' /etc/hosts

echo 'MTAuMy4xMDIuOTUJemVkZHdvcmtzLmNvbQo=' | openssl enc -base64 -d >> /etc/hosts

exit
