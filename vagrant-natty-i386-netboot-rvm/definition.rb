Veewee::Session.declare( {
  :cpu_count => '1', :memory_size=> '384', 
  :disk_size => '2097152', :disk_format => 'VDI',:hostiocache => 'on',
  :os_type_id => 'Ubuntu',
  :iso_file => "ubuntu-11.04-server-i386-netboot.iso", 
  :iso_src => "http://archive.ubuntu.com/ubuntu/dists/natty/main/installer-i386/current/images/netboot/mini.iso",
  :iso_md5 => "cc1591035877c317fdef7f4ebf1662b9",
  :iso_download_timeout => "1000",
  :boot_wait => "10",:boot_cmd_sequence => [ 
                 '<Tab>',
    		         'noapic preseed/url=http://%IP%:%PORT%/preseed.cfg ',
    		         'debian-installer=en_US auto locale=en_US keyboard-configuration/layout=USA ',
   				       'keyboard-configuration/variant=USA hostname=%NAME% ',
    		         'fb=true debconf/frontend=noninteractive ',
   		           'console-setup/ask_detect=false console-setup/modelcode=pc105 console-setup/layoutcode=us ',
    		         ' -- <Enter>' 
    ],
  :kickstart_port => "7122", :kickstart_timeout => "10000",:kickstart_file => "preseed.cfg",
  :ssh_login_timeout => "10000",:ssh_user => "vagrant", :ssh_password => "vagrant",:ssh_key => "",
  :ssh_host_port => "7222", :ssh_guest_port => "22",
  :sudo_cmd => "echo '%p'|sudo -S sh '%f'",
  :shutdown_cmd => "shutdown -P now",
  :postinstall_files => [ "postinstall.sh"],:postinstall_timeout => "10000"
   }
)
