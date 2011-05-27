Veewee::Session.declare( {
  :cpu_count => '1', :memory_size=> '384', 
  :disk_size => '1048576', :disk_format => 'VDI',:hostiocache => 'on',
  :os_type_id => 'Ubuntu_64',
  :iso_file => "ubuntu-11.04-server-amd64.iso", 
  :iso_src => "http://releases.ubuntu.com/natty/ubuntu-11.04-server-amd64.iso",
  :iso_md5 => "355ca2417522cb4a77e0295bf45c5cd5",
  :iso_download_timeout => "1000",
  :boot_wait => "10",:boot_cmd_sequence => [ 
                 '<Esc><Esc><Enter>',
    		         '/install/vmlinuz noapic preseed/url=http://%IP%:%PORT%/preseed.cfg ',
    		         'debian-installer=en_US auto locale=en_US keyboard-configuration/variant=USA ',
   				       'keyboard-configuration/layout=USA hostname=%NAME% ',
    		         'fb=false debconf/frontend=noninteractive ',
   		           'console-setup/ask_detect=false console-setup/modelcode=pc105 console-setup/layoutcode=USA ',
    		         'initrd=/install/initrd.gz -- <Enter>' 
    ],
  :kickstart_port => "7122", :kickstart_timeout => "10000",:kickstart_file => "preseed.cfg",
  :ssh_login_timeout => "10000",:ssh_user => "vagrant", :ssh_password => "vagrant",:ssh_key => "",
  :ssh_host_port => "7222", :ssh_guest_port => "22",
  :sudo_cmd => "echo '%p'|sudo -S sh '%f'",
  :shutdown_cmd => "shutdown -P now",
  :postinstall_files => [ "postinstall.sh"],:postinstall_timeout => "10000"
   }
)
